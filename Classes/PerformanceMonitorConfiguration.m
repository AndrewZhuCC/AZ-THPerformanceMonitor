//
//  PerformanceMonitorConfiguration.m
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "PerformanceMonitorConfiguration.h"

@implementation PerformanceMonitorConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _monitorType = MonitorType_RunLoop;
        _milliseconds = 10;
        _countToNotify = 1;
        _cpuUsageToNotify = 90.0;
    }
    return self;
}

@end
