//
//  PerformanceMonitorConfiguration.h
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MonitorType) {
    MonitorType_RunLoop,
    MonitorType_CPU,
};

@interface PerformanceMonitorConfiguration : NSObject

@property (nonatomic, assign) MonitorType monitorType;

/**
 Notify will be post after millisecondToNotify milliseconds no-response in run loop mode.
 Lauch observation of cpu usage by this param milliseconds in cpu mode.
 */
@property (nonatomic, assign) NSUInteger milliseconds;

/**
 Notify will be post when count of no-response in run loop mode reaches the countToNotify.
 */
@property (nonatomic, assign) NSUInteger countToNotify;

/**
 Notify will be post when the cpu usage reaches the cpuUsageToNotify.(Percent)
 */
@property (nonatomic, assign) double cpuUsageToNotify;

@end
