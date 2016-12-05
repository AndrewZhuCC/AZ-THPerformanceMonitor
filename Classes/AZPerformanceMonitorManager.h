//
//  AZPerformanceMonitorManager.h
//  AZPerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitor.h"

@interface AZPerformanceMonitorManager : NSObject

+ (instancetype)sharedInstance;

- (AZPerformanceMonitor *)addObserver:(AZPerformanceMonitor *)monitor;

- (AZPerformanceMonitor *)removeObserver:(AZPerformanceMonitor *)monitor;
- (void)removeAllObservers;

- (void)pauseForIO:(BOOL)pause;

- (NSArray<AZPerformanceMonitor *> *)monitorsWithType:(MonitorType)type;

@end
