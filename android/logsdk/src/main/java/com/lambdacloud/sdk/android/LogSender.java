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

import android.util.Log;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;

public class LogSender {

    private HttpClient client;

    public LogSender() {
        // Create http client
        SchemeRegistry registry = new SchemeRegistry();
        registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
        registry.register(new Scheme("https", SSLSocketFactory.getSocketFactory(), 443));
        HttpParams params = new BasicHttpParams();
        HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
        HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);
        HttpConnectionParams.setSocketBufferSize(params, 8192);
        HttpConnectionParams.setConnectionTimeout(params, LogSdkConfig.HTTP_TIMEOUT);
        HttpConnectionParams.setSoTimeout(params, LogSdkConfig.HTTP_TIMEOUT);
        client = new DefaultHttpClient(params);
    }

    public boolean sendLog(LogRequest log) {
        // First of all, valid token
        if (LogSdkConfig.LOGSDK_TOKEN == null) {
            Log.d(LogSdkConfig.LOG_TAG, "Token should not be empty");
            return false;
        }

        // Just return sent success if log is null
        if (log == null) {
            Log.d(LogSdkConfig.LOG_TAG, String.format(
                    "LogRequest should not be null. This log will be ignored"));
            return true;
        }

        // Just return sent success if log is empty
        String json = log.toJsonStr();
        if (json == null) {
            Log.d(LogSdkConfig.LOG_TAG, String.format(
                    "LogRequest.toJsonStr returns an empty json string. This log will be ignored"));
            return true;
        }

        // Send log as json entity
        try {
            StringEntity se = new StringEntity(json.toString(), "UTF-8");
            se.setContentType("application/json");

            String serverUrl = LogSdkConfig.HTTP_URL;
            HttpPost httpPost = new HttpPost(serverUrl);
            httpPost.setHeader("Token", LogSdkConfig.LOGSDK_TOKEN);
            httpPost.setHeader("Content-type", "application/json;charset=UTF-8");
            httpPost.setEntity(se);
            HttpResponse response = client.execute(httpPost);

            if (response == null) {
                Log.d(LogSdkConfig.LOG_TAG, "response from server side is null");
                return false;
            }

            // Check response
            if (response.getStatusLine().getStatusCode() != LogSdkConfig.HTTP_STATUSCODE_SUCCESS) {
                Log.d(LogSdkConfig.LOG_TAG, "value of response status code is not expected. detail is: " +
                        response.getStatusLine().toString());
                return false;
            }

            // Debug info
            Log.d(LogSdkConfig.LOG_TAG, "sent one log message to lambda cloud successfully");
            return true;
        } catch (Exception e) {
            Log.d(LogSdkConfig.LOG_TAG, "Got an exception while sending log, detail is " + Log.getStackTraceString(e));
            return false;
        }
    }
}
