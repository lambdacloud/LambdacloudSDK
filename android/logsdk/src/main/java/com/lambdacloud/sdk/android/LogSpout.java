package com.lambdacloud.sdk.android;

import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;

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
class LogSpout implements Runnable{
    private static LogSpout instance;

    private HandlerThread handlerThread;
    private LogSender sender;

    // Set protected for tests
    protected Handler handler;
    protected ConcurrentLinkedQueue<LogRequest> queue;

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
