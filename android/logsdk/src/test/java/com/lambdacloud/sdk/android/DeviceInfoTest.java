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

/**
 * Created by sky4star on 15/2/10.
 */

@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public class DeviceInfoTest {

    private DeviceInfo devInfo;

    @Before
    public void setUp()
    {
        Context context = Robolectric.application.getApplicationContext();
        devInfo = new DeviceInfo(context);
    }

    @Test
    public void testGetConnectionStatusOnlyWWAN() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(devInfo.mConnManager);

        // Wifi is available but not connected
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                NetworkInfo.DetailedState.DISCONNECTED, ConnectivityManager.TYPE_WIFI, 0, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is available and connected
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(NetworkInfo.DetailedState.CONNECTED,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = devInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_REACHABLE_VIA_WWAN);
    }

    @Test
    public void testGetConnectionStatusBoth() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(devInfo.mConnManager);

        // Wifi is available and connected
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                DetailedState.CONNECTED, ConnectivityManager.TYPE_WIFI, 0, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is available and connected
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(NetworkInfo.DetailedState.CONNECTED,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, true);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = devInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_REACHABLE_VIA_WIFI);
    }

    @Test
    public void testGetConnectionStatusConnecting() {
        ShadowConnectivityManager sConnMng = Robolectric.shadowOf(devInfo.mConnManager);

        // Wifi is available but not connected
        NetworkInfo wifi = ShadowNetworkInfo.newInstance(
                DetailedState.CONNECTING, ConnectivityManager.TYPE_WIFI, 0, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_WIFI, wifi);

        // Mobile is available and connected
        NetworkInfo mobile = ShadowNetworkInfo.newInstance(DetailedState.CONNECTING,
                ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_MOBILE_MMS, true, false);
        sConnMng.setNetworkInfo(ConnectivityManager.TYPE_MOBILE, mobile);

        String connection = devInfo.getInternetConnectionStatus();
        Assert.assertEquals(connection, DeviceInfoConstant.NETWORK_NOT_REACHABLE);
    }

    @Test
    public void testGetDeviceNameModelStartsWithManufacturer()
    {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", "HTC");
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", "HTC Desire 123");
        String deviceName = devInfo.getDeviceName();
        Assert.assertEquals(deviceName, "HTC Desire 123");
    }

    @Test
    public void testGetDeviceNameModelStartsWithoutManufacturer()
    {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", "HTC");
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", "Desire 123");
        String deviceName = devInfo.getDeviceName();
        Assert.assertEquals(deviceName, "HTC Desire 123");
    }

    @Test
    public void testGetDeviceNameUnknown()
    {
        Robolectric.Reflection.setFinalStaticField(Build.class, "MANUFACTURER", Build.UNKNOWN);
        Robolectric.Reflection.setFinalStaticField(Build.class, "MODEL", Build.UNKNOWN);
        String deviceName = devInfo.getDeviceName();
        Assert.assertEquals(deviceName, Build.UNKNOWN);
    }

}
