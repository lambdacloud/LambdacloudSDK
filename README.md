# LambdaCloudSDK 
SDK to record client logs
================================

# How to integrate LambdaCloudSDK to your project (for Cocos2dx v2)

#### Android

1. 生成liblogsdk.jar库

   - 下载工程到本地(下载链接：https://github.com/lambdacloud/LambdacloudSDK/tree/master/android）
   - 使用终端到工程目录下(android/logsdk)
   - 使用命令行生成liblogsdk.jar
   
     ```
     mvn package
     ```
   - 生成libsdklog.jar可在路径logsdk->target中查看

2. 在Android.mk文件中添加路径(请根据实际路径添加)

   ```
   LOCAL_SRC_FILES := \ 
   +$(LOCAL_PATH)/logsdk/android/source/LambdaClient.cpp \ 
   +$(LOCAL_PATH)/logsdk/android/source/LambdaDevice.cpp \ 
   +$(LOCAL_PATH)/logsdk/android/source/LogSdkJniHelper.cpp \ 

   +LOCAL_C_INCLUDES := $(LOCAL_PATH)/logsdk/android/include
   ```

3. 在proj.android/jni/android.mk中添加路径

   ```
   +LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../logsdk/android/include \
   ```

4. 在AndroidManifest.xml中添加uses-permission

   ```
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   ```

5. 添加logsdk库到您的工程中
   
   - 在eclipse中，右键点击工程名，properties->Java Build Path->Libraries->Add External JARs,然后添加liblogsdk.jar到工程中，并在Project Settings->Libraries中添加该库。

6. 在工程中初始化LogSdkJniHelper

   ```
   //In main class,
   // please add this include 
   #include "LogSdkJniHelper.h"
   jint JNI_OnLoad(JavaVM *vm, void *reserved)
   {
      JniHelper::setJavaVM(vm);
      // please add this line
     lambdacloud::LogSdkJniHelper::setJavaVM(vm);
   ```

7. 在工程中初始化DeviceInfo
   
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

8. 示例

   - https://github.com/lambdacloud/cocos2d-x/tree/v2/samples/Cpp/TestCpp/Classes/LambdacloudTest

#### IOS

1. 生成liblogsdk.a
   
   - 下载工程到本地(下载链接：https://github.com/lambdacloud/LambdacloudSDK/tree/master/ios)
   - 使用Xcode打开该工程，点击Product->Clean
   - 点击Product->Build,运行该工程即可生成静态库
   - 查看Xcode左侧目录结构Products下，即可看到liblogsdk.a静态库
   - 合成真机和模拟器静态库

     ```
     lipo -create /所在路径/Release-iphoneos/liblogsdk.a /所在路径/Release-iphonesimulator/liblogsdk.a -output /自定义路径/liblogsdk.a
     ```
   - 查看合成静态库架构,若查询结果为：liblogsdk.a are: arm7 i386 x86_64 arm64即为合成成功

     ```
     lipo -info liblogsdk.a
     ```

2. 添加liblogsdk.a静态库及其头文件

   - 在xcode中，右键点击您的工程，选择Add Files to"XXX"（XXX为当前工程名称），添加合成liblogsdk.a静态库及其头文件
   - 在Added folders中，选择Create groups
   - 在Add to targets中，务必勾选当前工程

3. 添加引用库CoreTelephony.framework,SystemConfiguration.framework

   - 在Build Phases->Link Binary With Libraries中添加上述引用库

4. 使用SDK

   - 在需要使用SDK中相关方法时，#import "xxx.h"即可（xxx.h为所需头文件名称）

5. 问题
  
   - 导入liblogsdk.a后运行工程报错：clang: error: linker command failed with exit code 1 (use -v to see invocation)
     解决方法：
     - 在Bulid Settings->Header Search Paths中添加头文件路径，在Build Settings->Library Search Paths中添加静态库路径




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

