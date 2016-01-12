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

#import <Foundation/Foundation.h>

@interface LogAgent : NSObject

+ (void)setToken:(NSString *)token;
+ (void)setMaxQueueSize:(NSInteger)maxQueueSize;
+ (BOOL)addLog:(NSString *)message;
+ (BOOL)addLog:(NSString *)message tags:(NSArray *)tags;
+ (void)setDebugMode:(BOOL)debug;
//地理位置信息日志发送接口
+ (BOOL)sendLocationInfo:(NSString *)userId locationInfo:(NSString *)locationInfo;
//设备信息日志发送接口
+ (BOOL)sendDeviceInfo:(NSString *)userId properties:(NSMutableDictionary *)properties;
+ (BOOL)sendDeviceInfo:(NSString *)userId methods:(NSArray *)methods properties:(NSMutableDictionary *)properties;
//渠道信息日志发送接口
+ (BOOL)sendChannelInfo:(NSString *)userId channelId:(NSString *)channelId properties:(NSMutableDictionary *)properties;
//登录登出日志发送接口
+ (BOOL)sendLoginInfo:(NSString *)userId serverId:(NSString *)serverId properties:(NSMutableDictionary *)properties;
+ (BOOL)sendLogoutInfo:(NSString *)userId properties:(NSMutableDictionary *)properties;
//用户标签日志发送接口
+ (BOOL)sendUserTag:(NSString *)userId tag:(NSString *)tag subTag:(NSString *)subTag;
//关卡日志发送接口
+ (BOOL)sendLevelBeginInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendLevelComleteInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendLevelFailInfo:(NSString *)userId levelName:(NSString *)levelName properties:(NSMutableDictionary *)properties;
//任务日志发送接口
+ (BOOL)sendTaskBeginInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendTaskComleteInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendTaskFailInfo:(NSString *)userId taskName:(NSString *)taskName properties:(NSMutableDictionary *)properties;
//物品信息日志发送接口
+ (BOOL)sendGetItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendBuyItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties;
+ (BOOL)sendConsumeItemInfo:(NSString *)userId itemName:(NSString *)itemName properties:(NSMutableDictionary *)properties;
//金币信息日志发送接口
+ (BOOL)sendGainCoinInfo:(NSString *)userId coinType:(NSString *)coinType gain:(long)gain total:(long)total reason:(NSString *)reason properties:(NSMutableDictionary *)properties;
+ (BOOL)sendConsumeCoinInfo:(NSString *)userId coinType:(NSString *)coinType use:(long)use total:(long)total reason:(NSString *)reason properties:(NSMutableDictionary *)properties;
//支付信息日志发送接口
+ (BOOL)sendCurrencyPaymentInfo:(NSString *)userId orderId:(NSString *)orderId iapId:(NSString *)iapId amount:(NSString *)amount currencyType:(NSString *)currencyType paymentType:(NSString *)paymentType properties:(NSMutableDictionary *)properties;
//自定义日志发送接口
+ (BOOL)sendCustomizedInfo:(NSString *)userId logType:(NSString *)logType properties:(NSMutableDictionary *)properties;
//漏斗日志发送接口
+ (BOOL)sendCustomizedFunnel:(NSString *)
userId funnelType:(NSString *)funnelType stepName:(NSString *)stepName stepStatus:(NSString *)stepStatus description:(NSString *)description properties:(NSMutableDictionary *)properties;

@end