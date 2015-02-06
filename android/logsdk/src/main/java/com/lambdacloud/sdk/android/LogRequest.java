package com.lambdacloud.sdk.android;

import android.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

/**
 * Created by sky4star on 15/2/5.
 */
public class LogRequest {
    private String message;
    private List<String> tags;

    public LogRequest(String message, List<String> tags)
    {
        this.message = message;
        this.tags = tags;
    }

    public String toJsonStr()
    {
        if (message == null)
        {
            Log.d(LogSdkConfig.LOG_TAG, "Message should not be empty.");
            return null;
        }

        try {
            JSONObject json = new JSONObject();
            json.put("message", message);
            if (tags != null && !tags.isEmpty())
            {
                JSONArray jsonTags = new JSONArray(tags);
                json.putOpt("tags", jsonTags);
            }
            return json.toString();
        } catch (JSONException e) {
            Log.d(LogSdkConfig.LOG_TAG, "Got an exception while composing json request, detail is " + Log.getStackTraceString(e));
            return null;
        }
    }
}
