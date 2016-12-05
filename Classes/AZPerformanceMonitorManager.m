//
//  AZPerformanceMonitorManager.m
//  AZPerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitorManager.h"

@interface AZPerformanceMonitorManager ()

@property (nonatomic, strong) NSMutableArray<AZPerformanceMonitor *> *observers;

@end

@implementation AZPerformanceMonitorManager

+ (instancetype)sharedInstance {
    static AZPerformanceMonitorManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = [NSMutableArray array];
    }
    return self;
}

- (AZPerformanceMonitor *)addObserver:(AZPerformanceMonitor *)monitor {
    if (monitor) {
        [self.observers addObject:monitor];
        [monitor start];
    }
    return monitor;
}

- (AZPerformanceMonitor *)removeObserver:(AZPerformanceMonitor *)monitor {
    if (monitor) {
        __weak typeof(monitor) wmonitor = monitor;
        __weak typeof(self) wself = self;
        [monitor stopWithCompletionHandler:^{
            [wself.observers removeObject:wmonitor];
        }];
    }
    return monitor;
}

- (void)removeAllObservers {
    for (AZPerformanceMonitor *monitor in self.observers) {
        __weak typeof(monitor) wmonitor = monitor;
        __weak typeof(self) wself = self;
        [monitor stopWithCompletionHandler:^{
            [wself.observers removeObject:wmonitor];
        }];
    }
}

- (void)pauseForIO:(BOOL)pause {
    for (AZPerformanceMonitor *monitor in self.observers) {
        monitor.pause = pause;
    }
}

- (NSArray<AZPerformanceMonitor *> *)monitorsWithType:(MonitorType)type {
    NSMutableArray *tempResult = [NSMutableArray array];
    for (AZPerformanceMonitor *monitor in self.observers) {
        if (monitor.config.monitorType == type) {
            [tempResult addObject:monitor];
        }
    }
    return [tempResult copy];
}

@end
