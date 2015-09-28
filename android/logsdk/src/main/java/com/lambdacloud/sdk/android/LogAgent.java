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

import java.util.Map;

public class LogAgent {

    public static void setToken(String token) {
        LogSdkConfig.LOGSDK_TOKEN = token;
    }

    public static void setSendInteval(int intevalInSecond) {
        if (intevalInSecond > 0) {
            LogSdkConfig.SPOUT_SLEEPTIME_IN_SECOND = intevalInSecond;
        }
    }

    public static void debugLogSdk(boolean debug) {
        LogSdkConfig.LOGSDK_DEBUG = debug;
    }

    public static boolean sendLog(String message) {
        return LogSpout.getInstance().addLog(message, null);
    }

    // Tags are separated with comma (",")
    public static boolean sendLog(String message, String tags) {
        return LogSpout.getInstance().addLog(message, tags);
    }

    public static boolean sendChannelInfo(String userID, String channelID, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("channel_info", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,channelID[%s]%s", basicPart, channelID, propPart);
            LogUtil.debug(LogSdkConfig.LOG_TAG, log);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "SendChannelInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLoginInfo(String userID, String serverID, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("login", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,serverID[%s]%s", basicPart, serverID, propPart);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLoginInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLogoutInfo(String userID, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("logout", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s%s", basicPart, propPart);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLogoutInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendUserTag(String userID, String tag, String subtag) {
        try {
            String basicPart = LogUtil.getBasicInfo("logout", userID);
            String log = String.format("%s,user_tag[%s],user_sub_tag[%s]", basicPart, tag, subtag);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendUserTag failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelBeginInfo(String userID, String levelName, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("level_begin", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,level_name[%s],status[begin]%s", basicPart, levelName, propPart);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelBeginInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelCompleteInfo(String userID, String levelName, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("level_complete", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,level_name[%s],status[complate]%s", basicPart, levelName, propPart);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelCompleteInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelFailInfo(String userID, String levelName, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("level_fail", userID);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,level_name[%s],status[fail]%s", basicPart, levelName, propPart);
            return LogSpout.getInstance().addLog(log, null);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelFailedInfo fail with exception " + e.getMessage());
        }

        return false;
    }
}
