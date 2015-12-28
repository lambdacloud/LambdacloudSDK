/**
 *   Copyright (c) 2015, LambdaCloud
 *   All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *   POSSIBILITY OF SUCH DAMAGE.
 */

#import "LogAgent.h"
#import "LogSdkConfig.h"
#import "LogSpout.h"
#import "DeviceInfo.h"
#import "LogUtil.h"

@implementation LogAgent

+ (void)setToken:(NSString *)token
{
    [LogSdkConfig SetLogSdkToken:token];
}

+ (void)SetMaxQueueSize:(NSInteger)maxQueueSize{
    if(maxQueueSize>0)
    kQueueSize =maxQueueSize;
}

+ (void)setDebugMode:(BOOL)debug
{
    kDebug = debug;
}

+ (BOOL)addLog:(NSString *)message
{
    NSString *str = [[NSString alloc]initWithFormat:@"%@%@",message,@",设备平台[IOS]"];
    return [[LogSpout sharedInstance] addRequest:str];
}

+ (BOOL)addLog:(NSString *)message tags:(NSArray *)tags
{
    NSString *str = [[NSString alloc]initWithFormat:@"%@%@",message,@",设备平台[IOS]"];
    return [[LogSpout sharedInstance] addRequest:str tags:tags];
}

+ (BOOL)sendDeviceInfo:(NSString *)userId properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_device_info" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *deviceName = [DeviceInfo getDeviceName];
    NSString *internetConnectionStatus = [DeviceInfo getInternetConnectionStatus];
    NSString *operatorInfo = [DeviceInfo getOperationInfo];
    NSString *systemOs = [DeviceInfo getSystemOS];

    NSString *log = [[NSString alloc]initWithFormat:@"%@,ldp_device_name[%@],ldp_connection_status[%@],ldp_os_version[%@],ldp_operator[%@]%@",basicPart, deviceName, internetConnectionStatus, systemOs, operatorInfo, propPart];
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendDeviceInfo:(NSString *)userId methods:(NSArray *)methods properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_device_info" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    NSMutableString *log = [[NSMutableString alloc]init];
    [log appendString:basicPart];
    for (int i=0;i<[methods count];i++) {
        if ([[methods objectAtIndex:i] isEqualToString:kGetDeviceName]==YES) {
            NSString *deviceName = [[NSString alloc]initWithFormat:@",ldp_device_name[%@]",[DeviceInfo getDeviceName]];
            [log appendString:deviceName];
        } else if ([methods[i] isEqualToString:kGetInternetConnectionStatus]==YES){
            NSString *internetConnectionStatus = [[NSString alloc]initWithFormat:@",ldp_connection_status[%@]",[DeviceInfo getInternetConnectionStatus]];
            [log appendString:internetConnectionStatus];
        } else if ([methods[i] isEqualToString:kGetOperationInfo]==YES){
            NSString *operatorInfo = [[NSString alloc]initWithFormat:@",ldp_operator[%@]",[DeviceInfo getOperationInfo]];
            [log appendString:operatorInfo];
        } else if ([methods[i] isEqualToString:kGetSystemOs]==YES){
            NSString *systemOs = [[NSString alloc]initWithFormat:@",ldp_os_version[%@]",[DeviceInfo getSystemOS]];
            [log appendString:systemOs];
        }
    }
    [log appendString:propPart];
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendChannelInfo:(NSString *)userId channelId:(NSString *)channelId properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_channel_info" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    NSString *log = [NSString stringWithFormat:@"%@,ldp_channelID[%@]%@", basicPart, channelId, propPart];

    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendLoginInfo:(NSString *)userId serverId:(NSString *)serverId properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_login_info" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];

    NSString *log = [NSString stringWithFormat:@"%@,ldp_serverID[%@]%@",basicPart, serverId, propPart];

    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendLogoutInfo:(NSString *)userId properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_logout_info" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
  
    NSString *log = [NSString stringWithFormat:@"%@%@",basicPart, propPart];
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];

}

+ (BOOL)sendUserTag:(NSString *)userId tag:(NSString *)tag subTag:(NSString *)subTag
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_user_tag" userId:userId];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_user_tag[%@],ldp_user_sub_tag[%@]",basicPart,tag,subTag];

    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];

    
}

+ (BOOL)sendLevelBeginInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_level_begin" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];

    NSString *log = [NSString stringWithFormat:@"%@,ldp_level_name[%@],ldp_status[begin]%@",basicPart, levelName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendLevelComleteInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_level_complete" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_level_name[%@],ldp_status[complete]%@",basicPart, levelName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendLevelFailInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_level_fail" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_level_name[%@],ldp_status[fail]%@",basicPart, levelName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendTaskBeginInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_task_begin" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_task_name[%@],ldp_status[begin]%@",basicPart, taskName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendTaskComleteInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_task_complete" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_task_name[%@],ldp_status[complete]%@",basicPart, taskName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendTaskFailInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_task_fail" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_task_name[%@],ldp_status[fail]%@",basicPart, taskName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendGetItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_item_get" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_item_name[%@]%@",basicPart, itemName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendBuyItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_item_buy" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_item_name[%@]%@",basicPart, itemName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendConsumeItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_item_consume" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_item_name[%@]%@",basicPart, itemName, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendGainCoinInfo:(NSString *)userId coinType:(NSString *)coinType gain:(long)gain total:(long)total reason:(NSString *)reason properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_coin_gain" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_coin_type[%@],gain[%ld],total[%ld],reason[%@]%@",basicPart, coinType, gain, total, reason, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendConsumeCoinInfo:(NSString *)userId coinType:(NSString *)coinType use:(long)use total:(long)total reason:(NSString *)reason properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_coin_consume" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_coin_type[%@],use[%ld],total[%ld],reason[%@]%@",basicPart, coinType, use, total, reason, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendCurrencyPaymentInfo:(NSString *)userId orderId:(NSString *)orderId iapId:(NSString *)iapId amount:(NSString *)amount currencyType:(NSString *)currencyType paymentType:(NSString *)paymentType properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:@"ldp_currency_payment" userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
   
    NSString *log = [NSString stringWithFormat:@"%@,ldp_order_id[%@],ldp_iap_id[%@],ldp_amount[%@],ldp_currency_type[%@],ldp_payment_type[%@]%@",basicPart, orderId, iapId, amount, currencyType, paymentType, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendCustomizedInfo:(NSString *)userId logType:(NSString *)logType properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:logType userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@%@",basicPart, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];
}

+ (BOOL)sendCustomizedFunnel:(NSString *)userId funnelType:(NSString *)funnelType stepName:(NSString *)stepName stepStatus:(NSString *)stepStatus description:(NSString *)description properties:(NSMutableDictionary *)properties
{
    NSString *basicPart = [LogUtil getBasicInfo:funnelType userId:userId];
    NSString *propPart = [LogUtil dic2str:properties];
    
    NSString *log = [NSString stringWithFormat:@"%@,ldp_step_name[%@],ldp_step_status[%@],ldp_desc[%@]%@",basicPart, stepName, stepStatus, description, propPart];
    
    [LogUtil debug:kLogTag message:log];
    return [LogAgent addLog:log];

}

@end