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

public class LogSdkConfig {

  public static long SPOUT_SLEEPTIME_IN_SECOND = 10;

  public static String LOGSDK_TOKEN = null;

  // Default http connection time out is 60s
  public static int HTTP_TIMEOUT = 60000;

  // Request queue has a limited size. If queue is full, new coming requests will be discarded
  public static int LOGSDK_QUEUE_SIZE = 100;

  public static String HTTP_URL = "http://api.lambdacloud.com/log/v2";

  public static String LOG_TAG = "LambdacloudSDK";

  public static int HTTP_STATUSCODE_SUCCESS = 200;

  public static int HTTP_STATUSCODE_TOKENILLEGAL = 406;

  // Flag to decide if writing debug log
  public static boolean LOGSDK_DEBUG = false;

  // Method Name
    //获取操作系统名称
    public static final String GET_OS_NAME = "getosname";
    //获取网络状态
    public static final String GET_INTERNET_CONNECT_STATUS = "getinternetconnectstatus";
    //获取设备名称
    public static final String GET_DEVICE_NAME = "getdevicename";
    //获取Imei
    public static final String GET_IMEI = "getimei";
    //获取操作系统版本
    public static final String GET_OS_VERSION = "getosversion";
    //获取屏幕分辨率
    public static final String GET_SCREEN_DIMENSION = "getscreendimension";
    //获取运营商信息
    public static final String GET_OPERATOR = "getoperatorInfo";
    //获取电量
    public static final String GET_BATTERY_POWER = "getbatterypower";
    //获取位置信息
    public static final String GET_LOCATION = "getlocation";
}
