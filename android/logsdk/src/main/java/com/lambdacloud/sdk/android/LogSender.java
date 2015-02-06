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

/**
 * Created by sky4star on 15/2/6.
 */
public class LogSender {

    private HttpClient client;

    public LogSender()
    {
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

    public boolean sendLog(LogRequest log)
    {
        // First of all, valid token
        if (LogSdkConfig.LOGSDK_TOKEN == null)
        {
            Log.d(LogSdkConfig.LOG_TAG, "Token should not be empty");
            return false;
        }

        // Just return sent success if log is null
        if (log == null)
        {
            Log.d(LogSdkConfig.LOG_TAG, String.format(
                    "LogRequest should not be null. This log will be ignored"));
            return true;
        }

        // Just return sent success if log is empty
        String json = log.toJsonStr();
        if (json == null)
        {
            Log.d(LogSdkConfig.LOG_TAG, String.format(
                    "LogRequest.toJsonStr returns an empty json string. This log will be ignored"));
            return true;
        }

        // Send log as json entity
        try {

            StringEntity se = new StringEntity(json.toString(), "UTF-8");
            se.setContentType("application/json");

            HttpPost httpPost = new HttpPost(LogSdkConfig.HTTP_URL);
            httpPost.setHeader("Token", LogSdkConfig.LOGSDK_TOKEN);
            httpPost.setHeader("Content-type", "application/json;charset=UTF-8");
            httpPost.setEntity(se);

            HttpResponse response = client.execute(httpPost);
        } catch (Exception e) {
            Log.d(LogSdkConfig.LOG_TAG, "Got an exception while sending log, detail is " + Log.getStackTraceString(e));
            return false;
        }

        return true;
    }
}
