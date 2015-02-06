package com.lambdacloud.sdk.android;

import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * Created by sky4star on 15/2/5.
 */
class LogSpout implements Runnable{
    private static LogSpout instance;

    private HandlerThread handlerThread;
    private Handler handler;
    private ConcurrentLinkedQueue<LogRequest> queue;
    private LogSender sender;

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
        queue = new ConcurrentLinkedQueue<LogRequest>();
        sender = new LogSender();

        handlerThread=new HandlerThread("LogSpout");
        handlerThread.start();
        handler = new Handler(handlerThread.getLooper());
        handler.postDelayed(this, LogSdkConfig.SPOUT_SLEEPTIME_MS);
    }

    public void run()
    {
        while (!queue.isEmpty())
        {
            LogRequest log = queue.peek();
            if (log == null)
                break;
            boolean success = sender.sendLog(log);

            // Remove log from queue if success, or sleep a certain time if any failure
            if (success)
            {
                queue.poll();
            }
            else
            {
                break;
            }
        }

        handler.postDelayed(this, LogSdkConfig.SPOUT_SLEEPTIME_MS);
    }

    public void addLog(String message, List<String> tags)
    {
        // Request queue has a limited size
        if (queue.size() >= LogSdkConfig.LOGSDK_QUEUE_SIZE)
        {
            Log.d(LogSdkConfig.LOG_TAG, "Log is discard since queue size is " + LogSdkConfig.LOGSDK_QUEUE_SIZE);
            return;
        }

        LogRequest log = new LogRequest(message, tags);
        queue.add(log);
    }
}
