package com.lambdacloud.sdk.android;

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

    public String getMessage()
    {
        return message;
    }

    public List<String> getTags()
    {
        return tags;
    }
}
