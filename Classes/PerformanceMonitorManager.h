//
//  PerformanceMonitorManager.h
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "PerformanceMonitor.h"

@interface PerformanceMonitorManager : NSObject

+ (instancetype)sharedInstance;

- (PerformanceMonitor *)addObserver:(PerformanceMonitor *)monitor;

- (PerformanceMonitor *)removeObserver:(PerformanceMonitor *)monitor;
- (void)removeAllObservers;

- (void)pauseForIO:(BOOL)pause;

@end
