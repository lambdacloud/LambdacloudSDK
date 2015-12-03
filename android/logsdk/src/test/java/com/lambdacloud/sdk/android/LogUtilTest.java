package com.lambdacloud.sdk.android;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import java.util.HashMap;
import java.util.Map;


@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public class LogUtilTest {

    @Test
    public void testMap2StrWithNull() {
        String str = LogUtil.map2Str(null);
        Assert.assertEquals(str, "");
    }

    @Test
    public void testMap2StrWithEmpty() {
        String str = LogUtil.map2Str(new HashMap<String, String>());
        Assert.assertEquals(str, "");
    }

    @Test
    public void testMap2StrWithContents() {
        Map<String, String> props = new HashMap<String, String>();
        props.put("玩家等级", "10");
        props.put("服务器名称", "服务器1");
        props.put("userinfo", "1");
        String str = LogUtil.map2Str(props);
        Assert.assertEquals(str, ",玩家等级[10],服务器名称[服务器1],userinfo[1]");
    }

    @Test
    public void testMap2StrWithNullContent() {
        Map<String, String> props = new HashMap<String, String>();
        props.put("玩家等级", "10");
        props.put("服务器名称", "服务器1");
        props.put(null, null);
        props.put("userinfo", null);
        String str = LogUtil.map2Str(props);
        Assert.assertEquals(str, ",玩家等级[10],服务器名称[服务器1],userinfo[null]");
    }

    @Test
    public void testMap2StrOnlyWithReservedKey() {
        Map<String, String> props = new HashMap<String, String>();
        props.put("用户", "123");
        String str = LogUtil.map2Str(props);
        Assert.assertEquals(str, "");
    }

    @Test
    public void testMap2StrWithReservedKey() {
        Map<String, String> props = new HashMap<String, String>();
        props.put("玩家等级", "10");
        props.put("服务器名称", "服务器1");
        props.put("用户", "123");
        props.put("时间", "2015/01/01");
        props.put("userinfo", null);
        String str = LogUtil.map2Str(props);
        Assert.assertEquals(str, ",玩家等级[10],服务器名称[服务器1],userinfo[null]");
    }

    @Test
    public void testGetTimestamp() {
        String timestamp = LogUtil.getTimestamp();

        // Timestamp should be in format of yyyy-MM-dd'T'HH:mm:ss.SSSXXX
        Assert.assertTrue(
            timestamp.matches("\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d.\\d\\d\\d[\\+\\-]\\d\\d:\\d\\d"));
    }


}
