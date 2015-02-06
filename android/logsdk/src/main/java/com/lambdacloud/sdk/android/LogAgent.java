package com.lambdacloud.sdk.android;

import java.util.List;

/**
 * Created by sky4star on 15/2/5.
 */
public class LogAgent {

    public static void setToken(String token)
    {
        LogSdkConfig.LOGSDK_TOKEN = token;
    }

    public static void sendLog(String message)
    {
        LogSpout.getInstance().addLog(message, null);
    }

    public static void sendLog(String message, List<String> tags)
    {
        LogSpout.getInstance().addLog(message, tags);
    }
}
