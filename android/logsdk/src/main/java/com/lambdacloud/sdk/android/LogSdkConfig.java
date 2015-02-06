package com.lambdacloud.sdk.android;

/**
 * Created by sky4star on 15/2/6.
 */
public class LogSdkConfig {

    public static long SPOUT_SLEEPTIME_MS = 1000000;

    public static String LOGSDK_TOKEN = null;

    // Default http connection time out is 60s
    public static int HTTP_TIMEOUT = 60000;

    // Request queue has a limited size. If queue is full, new coming requests will be discarded
    public static int LOGSDK_QUEUE_SIZE = 100;

    protected final static String HTTP_URL = "http://api.lambdacloud.com/log";

    protected final static String LOG_TAG = "LambdacloudSDK";
}
