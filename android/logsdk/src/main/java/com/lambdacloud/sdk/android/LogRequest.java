package com.lambdacloud.sdk.android;

import android.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

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
