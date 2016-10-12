//
//  PerformanceMonitorManager.m
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "PerformanceMonitorManager.h"

@interface PerformanceMonitorManager ()

@property (nonatomic, strong) NSMutableArray<PerformanceMonitor *> *observers;

@end

@implementation PerformanceMonitorManager

+ (instancetype)sharedInstance {
    static PerformanceMonitorManager *instance = nil;
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

- (PerformanceMonitor *)addObserver:(PerformanceMonitor *)monitor {
    if (monitor) {
        [self.observers addObject:monitor];
        [monitor start];
    }
    return monitor;
}

- (PerformanceMonitor *)removeObserver:(PerformanceMonitor *)monitor {
    if (monitor) {
        [monitor stop];
        [self.observers removeObject:monitor];
    }
    return monitor;
}

- (void)removeAllObservers {
    for (PerformanceMonitor *monitor in self.observers) {
        [monitor stop];
    }
    [self.observers removeAllObjects];
}

- (void)pauseForIO:(BOOL)pause {
    for (PerformanceMonitor *monitor in self.observers) {
        monitor.pause = pause;
    }
}

@end
