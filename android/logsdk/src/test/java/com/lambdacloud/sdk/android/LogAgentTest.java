/**
 Copyright (c) 2015, LambdaCloud
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */
package com.lambdacloud.sdk.android;

import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
import com.github.tomakehurst.wiremock.http.Request;
import com.github.tomakehurst.wiremock.http.RequestListener;
import com.github.tomakehurst.wiremock.http.Response;
import com.github.tomakehurst.wiremock.junit.WireMockRule;
import com.github.tomakehurst.wiremock.verification.LoggedRequest;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowLooper;

import java.util.ArrayList;
import java.util.List;

import static com.github.tomakehurst.wiremock.client.WireMock.*;


@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public class LogAgentTest {
  WireMockRule wireMockRule;

  List<Request> successReqs = new ArrayList<Request>();
  List<Request> illegalReqs = new ArrayList<Request>();
  List<Request> failedReqs = new ArrayList<Request>();

  @Before
  public void setUp() {
    LogSdkConfig.HTTP_URL = "http://localhost:8089/log";

    // Config Robolectric not to intercept http request
    Robolectric.getFakeHttpLayer().interceptHttpRequests(false);

    // Config request rules
    WireMockConfiguration wireMockConfig = WireMockConfiguration.wireMockConfig();
    wireMockRule = new WireMockRule(wireMockConfig.port(8089));
    wireMockRule.stubFor(post(urlMatching("/log"))
                           .withHeader("Content-Type", equalTo("application/json;charset=UTF-8"))
                           .withHeader("Token", equalTo("C2D56BC4-D336-4248-9A9F-B0CC8F906671"))
                           .willReturn(aResponse()
                                         .withStatus(204)
                                         .withBody("log received")));
    wireMockRule.stubFor(post(urlMatching("/log"))
                           .withHeader("Content-Type", equalTo("application/json;charset=UTF-8"))
                           .withHeader("Token", equalTo("d029dfc9-c74f-4f31-b896-998f7d18fcfc"))
                           .willReturn(aResponse()
                                         .withStatus(406)
                                         .withBody("token illegal")));
    wireMockRule.stubFor(post(urlMatching("/log"))
                           .withHeader("Content-Type", equalTo("application/json;charset=UTF-8"))
                           .withHeader("Token", equalTo("12345679-abcd-4f31-b896-998f7d18fcfc"))
                           .willReturn(aResponse()
                                         .withStatus(401)
                                         .withBody("request failed")));
    wireMockRule.addMockServiceRequestListener(new RequestListener() {
      @Override
      public void requestReceived(Request request, Response response) {
        if (response.getStatus() == 204) {
          successReqs.add(LoggedRequest.createFrom(request));
        } else if (response.getStatus() == 406) {
          illegalReqs.add(LoggedRequest.createFrom(request));
        } else if (response.getStatus() == 401) {
          failedReqs.add(LoggedRequest.createFrom(request));
        }
      }
    });
    wireMockRule.start();
  }

  @After
  public void tearDown() {
    wireMockRule.stop();
  }


  @Test
  public void testBasicLog2MockServer() {
    LogAgent.setToken("C2D56BC4-D336-4248-9A9F-B0CC8F906671");
    LogAgent.sendLog("test message from android sdk 0.0.1");

    LogSpout logSpout = LogSpout.getInstance();
    ShadowLooper sdLooper = Robolectric.shadowOf(logSpout.handler.getLooper());
    sdLooper.runOneTask();

    Assert.assertEquals(successReqs.size(), 1);
    Assert.assertEquals(logSpout.queue.size(), 0);
    wireMockRule.verify(1, postRequestedFor(urlEqualTo("/log")));
    wireMockRule.verify(postRequestedFor(urlMatching("/log"))
                          .withRequestBody(matching("\\{\"message\":\"test message from android sdk 0.0.1\"\\}")));
    successReqs.clear();
  }

  @Test
  public void testBasicLogWithTags2MockServer() {
    LogAgent.setToken("C2D56BC4-D336-4248-9A9F-B0CC8F906671");
    String tags = "test, debug, android";
    LogAgent.sendLog("test message from android sdk 0.0.1", tags);

    LogSpout logSpout = LogSpout.getInstance();
    ShadowLooper sdLooper = Robolectric.shadowOf(logSpout.handler.getLooper());
    sdLooper.runOneTask();

    Assert.assertEquals(successReqs.size(), 1);
    Assert.assertEquals(logSpout.queue.size(), 0);
    wireMockRule.verify(1, postRequestedFor(urlEqualTo("/log")));
    wireMockRule.verify(postRequestedFor(urlMatching("/log"))
                          .withRequestBody(matching(
                            "\\{\"tags\":\\[\"test\",\"debug\",\"android\"\\],\"message\":\"test message from android" +
                            " sdk 0.0.1\"\\}")));
    successReqs.clear();
  }

  @Test
  public void testBasicLogWithIllegalToken2MockServer() {
    LogAgent.setToken("d029dfc9-c74f-4f31-b896-998f7d18fcfc");
    LogAgent.sendLog("test message from android sdk 0.0.1");

    LogSpout logSpout = LogSpout.getInstance();
    ShadowLooper sdLooper = Robolectric.shadowOf(logSpout.handler.getLooper());
    sdLooper.runOneTask();

    Assert.assertEquals(illegalReqs.size(), 1);
    Assert.assertEquals(successReqs.size(), 0);
    Assert.assertEquals(logSpout.queue.size(), 0);
    wireMockRule.verify(1, postRequestedFor(urlEqualTo("/log")));
    wireMockRule.verify(postRequestedFor(urlMatching("/log"))
                          .withRequestBody(matching("\\{\"message\":\"test message from android sdk 0.0.1\"\\}")));

    // New logs will not be sent
    LogAgent.sendLog("test message from android sdk 0.0.1");
    sdLooper.runOneTask();
    Assert.assertEquals(illegalReqs.size(), 1);
    Assert.assertEquals(successReqs.size(), 0);
    Assert.assertEquals(logSpout.queue.size(), 0);

    illegalReqs.clear();
    successReqs.clear();
    failedReqs.clear();
  }

  @Test
  public void testBasicLogFailedMockServer() {
    // Since last test uses an illegal token, after setting new token, we should be able to send log again
    LogAgent.setToken("12345679-abcd-4f31-b896-998f7d18fcfc");
    LogAgent.sendLog("test message from android sdk 0.0.1");

    LogSpout logSpout = LogSpout.getInstance();
    ShadowLooper sdLooper = Robolectric.shadowOf(logSpout.handler.getLooper());
    sdLooper.runOneTask();

    // Log should always be discard even if send failed
    Assert.assertEquals(illegalReqs.size(), 0);
    Assert.assertEquals(successReqs.size(), 0);
    Assert.assertEquals(failedReqs.size(), 1);
    Assert.assertEquals(logSpout.queue.size(), 0);
    wireMockRule.verify(1, postRequestedFor(urlEqualTo("/log")));
    wireMockRule.verify(postRequestedFor(urlMatching("/log"))
                          .withRequestBody(matching("\\{\"message\":\"test message from android sdk 0.0.1\"\\}")));

    // New log should be sent but failed again
    LogAgent.sendLog("test message from android sdk 0.0.1");
    sdLooper.runOneTask();
    Assert.assertEquals(illegalReqs.size(), 0);
    Assert.assertEquals(successReqs.size(), 0);
    Assert.assertEquals(failedReqs.size(), 2);
    Assert.assertEquals(logSpout.queue.size(), 0);

    illegalReqs.clear();
    successReqs.clear();
    failedReqs.clear();
  }
}

