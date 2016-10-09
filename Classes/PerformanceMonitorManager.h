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

- (void)addObserver:(PerformanceMonitor *)monitor;

- (void)removeObserver:(PerformanceMonitor *)monitor;
- (void)removeAllObservers;

@end
