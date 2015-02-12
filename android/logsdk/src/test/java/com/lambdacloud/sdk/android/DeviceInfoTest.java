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

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.DetailedState;
import android.os.Build;
import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowConnectivityManager;
import org.robolectric.shadows.ShadowNetworkInfo;

@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public class DeviceInfoTest {
    @Before
    public void setUp() {
        Context context = Robolectric.application.getApplicationContext();
        DeviceInfo.init(context);
    }

    @Test
    public void testGetConnectionStatusOnlyWWAN() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(DeviceInfo.connManager);

        // Wifi is available but not connected
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                NetworkInfo.DetailedState.DISCONNECTED, ConnectivityManager.TYPE_WIFI, 0, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is available and connected
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(NetworkInfo.DetailedState.CONNECTED,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = DeviceInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_REACHABLE_VIA_WWAN);
    }

    @Test
    public void testGetConnectionStatusBoth() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(DeviceInfo.connManager);

        // Wifi is available and connected
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                DetailedState.CONNECTED, ConnectivityManager.TYPE_WIFI, 0, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is available and connected
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(NetworkInfo.DetailedState.CONNECTED,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = DeviceInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_REACHABLE_VIA_WIFI);
    }

    @Test
    public void testGetConnectionStatusConnecting() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(DeviceInfo.connManager);

        // Wifi is connecting
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                DetailedState.CONNECTING, ConnectivityManager.TYPE_WIFI, 0, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is connecting
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(DetailedState.CONNECTING,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = DeviceInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_NOT_REACHABLE);
    }

    @Test
    public void testGetDeviceNameModelStartsWithManufacturer() {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", "HTC");
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", "HTC Desire 123");
        String deviceName = DeviceInfo.getDeviceName();
        Assert.assertEquals(deviceName, "HTC Desire 123");
    }

    @Test
    public void testGetDeviceNameModelStartsWithoutManufacturer() {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", "HTC");
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", "Desire 123");
        String deviceName = DeviceInfo.getDeviceName();
        Assert.assertEquals(deviceName, "HTC Desire 123");
    }

    @Test
    public void testGetDeviceNameUnknown() {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", Build.UNKNOWN);
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", Build.UNKNOWN);
        String deviceName = DeviceInfo.getDeviceName();
        Assert.assertEquals(deviceName, Build.UNKNOWN);
    }

}
