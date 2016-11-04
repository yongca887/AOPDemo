//
//  AppDelegate+UMAnalytics.m
//  PBAShow
//
//  Created by yong on 16/5/13.
//  Copyright © 2016年 PBA. All rights reserved.
//

#import "AppDelegate+UMAnalytics.h"
#import <UMMobClick/MobClick.h>
#import "Aspects.h"
#import <objc/runtime.h>

#define UMENG_APPKEY @"581c02283eae252ef3002926"

// 登录友盟查看效果，账号：aopdemo@163.com 密码：aop123456

@implementation AppDelegate (UMAnalytics)

//配置友盟统计
- (void)configureUmengTrack {
    UMConfigInstance.appKey = UMENG_APPKEY;
    [UMConfigInstance setBCrashReportEnabled:YES];
//    UMConfigInstance.secret = UMENG_APPKEY;
//    UMConfigInstance.ePolicy = REALTIME;

    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:XcodeAppVersion];
    //TODO:正式环境去除集成测试
#ifdef  DEBUG
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    [MobClick setLogEnabled:YES];
#else
#endif
}

- (void)setupAnalytics {
    // 设置页面统计
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo) {
        [MobClick beginLogPageView:NSStringFromClass([self class])];
    }                               error:NULL];

    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo) {
        [MobClick beginLogPageView:NSStringFromClass([self class])];
    }                               error:NULL];

    // 设置事件统计
    [self setupUMEventAnalytics];
}

- (void)setupUMEventAnalytics {
    //设置事件统计
    //放到异步线程去执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取需要统计的事件列表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UMEventStatisticsList" ofType:@"plist"];
        NSDictionary *eventStatisticsDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        for (NSString *classNameString in eventStatisticsDict.allKeys) {
            //使用运行时创建类对象
            const char *className = [classNameString UTF8String];
            // 从一个字串返回一个类
            Class newClass = objc_getClass(className);
            NSArray *pageEventList = [eventStatisticsDict objectForKey:classNameString];
            for (NSDictionary *eventDict in pageEventList) {
                //事件方法名称
                NSString *eventMethodName = eventDict[@"EventName"];
                SEL seletor = NSSelectorFromString(eventMethodName);

                NSString *eventId = eventDict[@"EventId"];

                NSArray *params = eventDict[@"Params"];

                [self trackEventWithClass:newClass selector:seletor event:eventId params:params];
            }
        }
    });
}

- (void)trackEventWithClass:(Class)klass selector:(SEL)selector event:(NSString *)event params:(NSArray *)paramNames {
    [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo, NSDictionary *dict) {
//        NSLog(@"%@", aspectInfo);
//        NSLog(@"%@", dict);
        NSMutableString *appendString = nil;
        //如果有参数，那么把参数名和参数值拼接在eventID之后
        if (paramNames.count > 0) {
            appendString = [[NSMutableString alloc] initWithCapacity:15];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                //获取dict
                for (NSString *paramName in paramNames) {
                    NSString *paramValue = [dict objectForKey:paramName];
                    [appendString appendFormat:@"%@%@", paramName, paramValue];
                }
            }
        }

        NSString *eventId = event;
        if (appendString) {
            eventId = [NSString stringWithFormat:@"%@%@", event, appendString];
        }

        [MobClick event:eventId];
    }                    error:NULL];
}

@end
