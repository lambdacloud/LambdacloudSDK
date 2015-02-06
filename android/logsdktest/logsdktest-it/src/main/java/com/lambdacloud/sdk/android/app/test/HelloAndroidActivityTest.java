package com.lambdacloud.sdk.android.app.test;

import android.test.ActivityInstrumentationTestCase2;
import com.lambdacloud.sdk.android.app.*;
import com.lambdacloud.sdk.android.*;

public class HelloAndroidActivityTest extends ActivityInstrumentationTestCase2<HelloAndroidActivity> {

    public HelloAndroidActivityTest() {
        super(HelloAndroidActivity.class); 
    }

    public void testActivity() {
        HelloAndroidActivity activity = getActivity();
        assertNotNull(activity);
    }

    public void testSendBasicLog()
    {
        LogAgent.setToken("C2D56BC4-D336-4248-9A9F-B0CC8F906671");
        LogAgent.sendLog("test message from android sdk 0.0.1");
        try {
            Thread.sleep(100000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

