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

    public static void setMaxQueueSize(int queueSize) {
        if (queueSize > 0) {
            LogSdkConfig.LOGSDK_QUEUE_SIZE = queueSize;
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

    public static boolean sendChannelInfo(String userID, String channelID, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_channel_info", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_channelID[%s]%s", basicPart, channelID, propPart);
            LogUtil.debug(LogSdkConfig.LOG_TAG, log);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "SendChannelInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLoginInfo(String userID, String serverID, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_login", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_serverID[%s]%s", basicPart, serverID, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLoginInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLogoutInfo(String userID, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_logout", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s%s", basicPart, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLogoutInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendUserTag(String userID, String tag, String timestamp, String subtag) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_user_tag", userID, timestamp);
            String log = String.format("%s,ldp_user_tag[%s],ldp_user_sub_tag[%s]", basicPart, tag, subtag);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendUserTag failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelBeginInfo(String userID, String levelName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_level_begin", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_level_name[%s],ldp_status[begin]%s", basicPart, levelName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelBeginInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelCompleteInfo(String userID, String levelName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_level_complete", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_level_name[%s],ldp_status[complate]%s", basicPart, levelName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelCompleteInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendLevelFailInfo(String userID, String levelName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_level_fail", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_level_name[%s],ldp_status[fail]%s", basicPart, levelName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendLevelFailedInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendTaskBeginInfo(String userID, String taskName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_task_begin", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_task_name[%s]%s", basicPart, taskName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendTaskBeginInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendTaskCompleteInfo(String userID, String taskName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_task_complete", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_task_name[%s]%s", basicPart, taskName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendTaskCompleteInfo failed with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendTaskFailInfo(String userID, String taskName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_task_fail", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_task_name[%s]%s", basicPart, taskName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendTaskFailInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendGetItemInfo(String userID, String itemName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_item_get", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_item_name[%s]%s", basicPart, itemName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendGetItemInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendBuyItemInfo(String userID, String itemName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_item_buy", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_item_name[%s]%s", basicPart, itemName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendBuyItemInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendConsumeItemInfo(String userID, String itemName, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_item_consume", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_item_name[%s]%s", basicPart, itemName, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendConsumeItemInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendGainCoinInfo(String userID, String coinType, long gain, long total, String reason, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_coin_gain", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_coin_type[%s],gain[%d],total[%d],reason[%s]%s", basicPart, coinType, gain, total, reason, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendGainCoinInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendConsumeCoinInfo(String userID, String coinType, long use, long total, String reason, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_coin_consume", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_coin_type[%s],consume[%d],total[%d],reason[%s]%s", basicPart, coinType, use, total, reason, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendConsumeCoinInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendDeviceInfo(String userID, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_device_info", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String osName = "android";
            String connection = DeviceInfo.getInternetConnectionStatus();
            String deviceName = DeviceInfo.getDeviceName();
            String imei = DeviceInfo.getImei();
            String osVersion = DeviceInfo.getOsVersion();
            String operator = DeviceInfo.getOperationInfo();
            String screen = DeviceInfo.getScreenDimension();
            String othersAppName = DeviceInfo.getAppList();
            String log = String.format("%s,ldp_os_type[%s],ldp_connection_status[%s],ldp_device_name[%s],ldp_imei[%s],ldp_os_version[%s],ldp_operator[%s],ldp_screen[%s],ldp_others_app_name[%s]%s",
                                       basicPart, osName, connection, deviceName, imei, osVersion, operator, screen, propPart,othersAppName);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendDeviceInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendCurrencyPaymentInfo(String userID, String orderID, String iapID, String amount, String currencyType, String paymentType, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo("ldp_currency_payment", userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_order_id[%s],ldp_iap_id[%s],ldp_amount[%s],ldp_currency_type[%s],ldp_payment_type[%s]%s",
                                       basicPart, orderID, iapID, amount, currencyType, paymentType, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendCurrencyPaymentInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendCustomizedInfo(String userID, String logtype, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo(logtype, userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s%s", basicPart, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendCustomizedInfo fail with exception " + e.getMessage());
        }

        return false;
    }

    public static boolean sendCustomizedFunnel(String userID, String funnelType, String stepName, String stepStatus, String description, String timestamp, Map<String, String> properties) {
        try {
            String basicPart = LogUtil.getBasicInfo(funnelType, userID, timestamp);
            String propPart = LogUtil.map2Str(properties);
            String log = String.format("%s,ldp_step_name[%s],ldp_step_status[%s],ldp_desc[%s]%s", basicPart, stepName, stepStatus, description, propPart);
            return sendLog(log);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "sendCustomizedFunnel fail with exception " + e.getMessage());
        }

        return false;
    }
}
