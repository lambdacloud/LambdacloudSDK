# LambdaCloudSDK 
SDK to record client logs
================================

# How to integrate LambdaCloudSDK to your project (for Cocos2dx v2)

# For Android
* Add references to your android.mk (please modify path according to your actual situation)
...
LOCAL_SRC_FILES := \
+$(LOCAL_PATH)/logsdk/android/source/LambdaClient.cpp \
+$(LOCAL_PATH)/logsdk/android/source/LambdaDevice.cpp \
+$(LOCAL_PATH)/logsdk/android/source/LogSdkJniHelper.cpp \
+LOCAL_C_INCLUDES := $(LOCAL_PATH)/logsdk/android/include
...

* Add reference to your proj.android/jni/android.mk if necessary

`+LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../logsdk/android/include \`

* Add required permission settings to your AndroidManifest.xml

```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```

* Add logsdk library into your project

In Eclipse, right click your project, properties->Java Build Path->Libraries->Add External JARs
In Intellij, F4 to open Project Structure, add library in Project Settings->Libraries, then add it as module in Modules

* Initialize LogSdkJniHelper in your project


```
In main class,
// please add this include 
#include "LogSdkJniHelper.h"
jint JNI_OnLoad(JavaVM *vm, void *reserved)
{
JniHelper::setJavaVM(vm);
// please add this line
lambdacloud::LogSdkJniHelper::setJavaVM(vm);
```

* Initialize DeviceInfo class in your project

In your Activity class,

```
// please add these import
import android.content.Context;   
import com.lambdacloud.sdk.android.DeviceInfo;

public class YOURAPP extends Cocos2dxActivity{

protected void onCreate(Bundle savedInstanceState){
super.onCreate(savedInstanceState);
// please add these lines
Context context = getApplicationContext();
DeviceInfo.init(context);
```

* Example: https://github.com/lambdacloud/cocos2d-x/tree/v2/samples/Cpp/TestCpp/Classes/LambdacloudTest

# For Android Lua
TBD

# For IOS 
TBD


================================

# How to test your android proj in GenyMotion
GenyMotion is a fantastic Android simulator, with much better performance than Android's original simulator.
1. Download GeneMotion and choose the coresponding virtual device
2. If you are compiling your proj with ARM system image, you have to download and drop a Genymotion ARM Translation zip file into your virtual device and reboot it.
a. i am using Genymotion-ARM-Translation_v1.1.zip
b. reboot by YOUR_SDK_ROOT> ./platform-tools/adb reboot
3. Install Eclipse GenyMotion plugin
4. Start the virtual device in your Eclipse and run your project as Android application

Trouble shooting
1. "unfortunately app has stopped" with "java.lang.IllegalArgumentException: No config chosen" in your LogCat
in your main java file
glSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0);

