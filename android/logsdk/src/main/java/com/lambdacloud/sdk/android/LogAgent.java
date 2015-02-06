package com.lambdacloud.sdk.android;

import java.util.List;

/**
 * Created by sky4star on 15/2/5.
 */
public class LogAgent {

    public static void SetToken(String token)
    {
        LogSdkConfig.LOGSDK_TOKEN = token;
    }

    public static void SendLog(String message)
    {
        LogSpout.getInstance().addLog(message, null);
    }

    public static void SendLog(String message, List<String> tags)
    {
        LogSpout.getInstance().addLog(message, tags);
    }
}
