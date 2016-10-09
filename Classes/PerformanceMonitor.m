//
//  PerformanceMonitor.m
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Andrew. All rights reserved.
//

#import "PerformanceMonitor.h"
#import "PerformanceMonitorRunLoop.h"
#import "PerformanceMonitorCPU.h"

@interface PerformanceMonitor ()
@end

@implementation PerformanceMonitor

- (instancetype)initWithConfiguration:(PerformanceMonitorConfiguration *)configuration {
    switch (configuration.monitorType) {
            case MonitorType_RunLoop:
        {
            return [[PerformanceMonitorRunLoop alloc] initWithConfiguration:configuration];
        }
            case MonitorType_CPU:
        {
            return [[PerformanceMonitorCPU alloc] initWithConfiguration:configuration];
        }
    }
}

- (void)start {
    NSAssert(0, @"Must be called in Subclass");
}

- (void)stop {
    NSAssert(0, @"Must be called in Subclass");
}

@end
