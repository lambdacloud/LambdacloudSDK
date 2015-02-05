package com.lambdacloud.sdk.android;

import android.os.Handler;

/**
 * Created by sky4star on 15/2/5.
 */
public class LogSpout {

    private static LogSpout instance;
    private RequestHandler handler;

    public static LogSpout getInstance()
    {
        if (instance == null)
        {
            instance = new LogSpout();
        }
        return instance;
    }

    private LogSpout()
    {
        handler = new RequestHandler();
    }
}
