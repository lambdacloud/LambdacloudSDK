package com.lambdacloud.sdk.android;

import android.os.Handler;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * Created by sky4star on 15/2/5.
 */
class RequestHandler implements Runnable{
    private Handler handler;

    private ConcurrentLinkedQueue<LogRequest> queue;

    public RequestHandler()
    {
        CQueue = new ConcurrentLinkedQueue<LogRequest>();
        handler = new Handler();
        handler.post(this);
    }

    public void run()
    {

    }

    public void addLog(LogRequest log)
    {
        queue.add(log);
    }
}
