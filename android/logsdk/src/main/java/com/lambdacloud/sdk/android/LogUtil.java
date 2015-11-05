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
package com.lambdacloud.sdk.android;

import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.*;


public class LogUtil {

    private static List<String> reservedFieldNames = new ArrayList<String>(Arrays.asList("日志类型", "时间", "用户id"));

    public static void debug(String tag, String message) {
        if (LogSdkConfig.LOGSDK_DEBUG) {
            Log.d(tag, message);
        }
    }

    public static String getBasicInfo(String logtype, String userid) {
        String basic = String.format("日志类型[%s],时间[%s],用户ID[%s]", logtype, getTimestamp(), userid);
        return basic;
    }

    // Timestamp in format of 2011-10-08T07:07:09+08:00
    public static String getTimestamp() {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
        String formattedDate = sdf.format(date);
        if (!formattedDate.toLowerCase().endsWith("z")) {
            formattedDate = formattedDate.substring(0, formattedDate.length() - 2) + ":00";
        }
        return formattedDate;
    }

    public static String map2Str(Map<String, String> properties) {
        if (properties == null || properties.size() == 0) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        Iterator it = properties.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, String> pair = (Map.Entry) it.next();

            // In case value is null, we still record it
            if (pair.getKey() != null && !reservedFieldNames.contains(pair.getKey().toLowerCase())) {
                sb.append(',');
                sb.append(pair.getKey());
                sb.append('[');
                sb.append(pair.getValue());
                sb.append(']');
            }
        }

        return sb.toString();
    }
}
