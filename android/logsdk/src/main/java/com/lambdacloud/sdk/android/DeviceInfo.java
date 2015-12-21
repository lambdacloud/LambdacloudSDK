/**
 * Copyright (c) 2015, LambdaCloud
 * All rights reserved.
 * <p/>
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * <p/>
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * <p/>
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * <p/>
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package com.lambdacloud.sdk.android;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.graphics.Point;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Looper;
import android.telephony.TelephonyManager;
import android.view.Display;
import android.view.WindowManager;

import java.util.List;


public class DeviceInfo {
    private static Context appContext;


    public static void init(Context context, String token) {
        appContext = context;
        try {
            getLocation();
            getBatteryPower();
            String imei = getImei();
            LogAgent.setToken(token);
            LogAgent.sendDeviceInfo(imei, null);
            LogAgent.sendAppList(imei);
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "Failed to send message while starting app.");
        }
    }

    static LocationManager locationManager;
    static LocationListener locationListener;
    static CountDownTimer cdtForLocation;
    public static void getLocation(){
        try{
            //设置倒计时，2min后移除位置监听
            cdtForLocation = new CountDownTimer(1000 * 60 * 2,1000) {
                @Override
                public void onTick(long l) {
                    LogUtil.debug(LogSdkConfig.LOG_TAG, "count down timer for location:"+String.valueOf(l));
                }

                @Override
                public void onFinish() {
                    LogUtil.debug(LogSdkConfig.LOG_TAG, "count down finished");
                    locationManager.removeUpdates(locationListener);

                }
            };
            //注册位置监听
             locationListener = new LocationListener() {
                @Override
                public void onLocationChanged(Location location){
                    //当有位置变化时，发送位置日志，并移除监听，停止倒计时
                    LogUtil.debug(LogSdkConfig.LOG_TAG,"latitude:"+location.getLatitude()+" longitude:"+location.getLongitude());
                    LogAgent.sendLocationInfo(location);
                    locationManager.removeUpdates(locationListener);
                    cdtForLocation.cancel();
                }

                 @Override
                 public void onStatusChanged(String s, int i, Bundle bundle) {

                 }

                 @Override
                 public void onProviderEnabled(String s) {

                 }

                 @Override
                 public void onProviderDisabled(String s) {

                 }
             };
            locationManager = (LocationManager) appContext.getSystemService(Context.LOCATION_SERVICE);
            List<String> providers = locationManager.getProviders(true);

            if (providers.contains(LocationManager.GPS_PROVIDER)) {
                String locationProvider = LocationManager.GPS_PROVIDER;
                try {
                    //请求位置更新，启动倒计时
                    locationManager.requestLocationUpdates(locationProvider, 60 * 1000, 0, locationListener, Looper.getMainLooper());
                    cdtForLocation.start();
                } catch (Exception e) {
                    LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception when locationManager requestLocationUpdates, detail is : " + e.toString());
                }
            } else {
                LogUtil.debug(LogSdkConfig.LOG_TAG, "GPS不可用");
            }
        } catch (Exception e){
            LogUtil.debug(LogSdkConfig.LOG_TAG, "Failed to get location, detail is:"+e.toString());
        }
    }

    static BroadcastReceiver broadcastReceiver;
    public static void getBatteryPower(){
        try{
            //当电量变化时获取该电量并发送日志
            broadcastReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    if (Intent.ACTION_BATTERY_CHANGED.equals(intent.getAction())){
                        int level = intent.getIntExtra("level", -1);
                        int scale = intent.getIntExtra("scale", -1);
                        String batteryPower = ((scale * 100) / level)+"%";
                        LogUtil.debug(LogSdkConfig.LOG_TAG,"battery power:"+batteryPower);
                        LogAgent.sendBatteryPower(batteryPower);
                        appContext.unregisterReceiver(broadcastReceiver);
                    }
                }
            };
            //注册接受广播
            IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            appContext.registerReceiver(broadcastReceiver,intentFilter);
        } catch (Exception e){
            LogUtil.debug(LogSdkConfig.LOG_TAG, "Failed to get battery power, detail is:"+e.toString());
        }
    }

    public static String getInternetConnectionStatus() {
        LogUtil.debug(LogSdkConfig.LOG_TAG, "Read connection status");
        try {
            ConnectivityManager connManager = (ConnectivityManager) appContext.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (connManager != null) {
                NetworkInfo.State state = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState();
                if (NetworkInfo.State.CONNECTED == state) {
                    return DeviceInfoConstant.NETWORK_REACHABLE_VIA_WIFI;
                }

                state = connManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState();
                if (NetworkInfo.State.CONNECTED == state) {
                    return DeviceInfoConstant.NETWORK_REACHABLE_VIA_WWAN;
                }
            }
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting connection status, detail is " + e.toString());
            return DeviceInfoConstant.UNKNOWN;
        }

        return DeviceInfoConstant.NETWORK_NOT_REACHABLE;
    }

    public static String getDeviceName() {
        try {
            String manufacturer = Build.MANUFACTURER;
            String model = Build.MODEL;
            if (manufacturer.equals(Build.UNKNOWN)) {
                return model;
            } else if (model.equals(Build.UNKNOWN)) {
                return manufacturer;
            } else if (model.toLowerCase().startsWith(manufacturer.toLowerCase())) {
                return model;
            } else {
                return manufacturer + " " + model;
            }
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while reading device name, detail is " + e.toString());
            return DeviceInfoConstant.UNKNOWN;
        }
    }

    public static String getOperationInfo() {
        try {
            TelephonyManager teleManager = (TelephonyManager) appContext.getSystemService(Context.TELEPHONY_SERVICE);
            if (teleManager != null) {
                return teleManager.getNetworkOperatorName();
            }
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting operation name, detail is " + e.toString());
        }

        return DeviceInfoConstant.UNKNOWN;
    }

    public static String getOsVersion() {
        try {
            String release = Build.VERSION.RELEASE;
            return release;
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting os version, detail is " + e.toString());
        }

        return DeviceInfoConstant.UNKNOWN;
    }

    public static String getScreenDimension() {
        try {
            WindowManager wm = (WindowManager) appContext.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            Point size = new Point();
            display.getSize(size);
            String dimension = String.format("%s x %s", size.x, size.y);
            return dimension;
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting screen dimension, detail is " + e.toString());
        }

        return DeviceInfoConstant.UNKNOWN;
    }

    public static String getImei() {
        try {
            TelephonyManager teleManager = (TelephonyManager) appContext.getSystemService(Context.TELEPHONY_SERVICE);
            if (teleManager != null) {
                return teleManager.getDeviceId();
            }
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting phone IMEI info, detail is " + e.toString());
        }

        return DeviceInfoConstant.UNKNOWN;
    }

    public static String getAppList() {
        try {
            List<PackageInfo> packages = appContext.getPackageManager().getInstalledPackages(0);
            StringBuffer stringBuffer = new StringBuffer();
            for (int i = 0; i < packages.size() && packages.size() >= 1; i++) {
                PackageInfo packageInfo = packages.get(i);
                String temp = packageInfo.applicationInfo.loadLabel(appContext.getPackageManager()).toString();
                if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0 && !temp.contains("[") && !temp.contains("]")) {
                    stringBuffer.append(temp);
                    stringBuffer.append(",");
                }
            }
            return stringBuffer.toString();
        } catch (Exception e) {
            LogUtil.debug(LogSdkConfig.LOG_TAG, "get exception while getting appName ,detail is " + e.toString());
        }
        return DeviceInfoConstant.UNKNOWN;
    }
}