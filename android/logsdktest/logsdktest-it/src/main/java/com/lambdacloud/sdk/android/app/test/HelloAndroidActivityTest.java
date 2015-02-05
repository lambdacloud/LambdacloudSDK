package com.lambdacloud.sdk.android.app.test;

import android.test.ActivityInstrumentationTestCase2;
import com.lambdacloud.sdk.android.app.*;

public class HelloAndroidActivityTest extends ActivityInstrumentationTestCase2<HelloAndroidActivity> {

    public HelloAndroidActivityTest() {
        super(HelloAndroidActivity.class); 
    }

    public void testActivity() {
        HelloAndroidActivity activity = getActivity();
        assertNotNull(activity);
    }
}

