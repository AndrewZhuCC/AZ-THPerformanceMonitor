//
//  PerformanceMonitor.h
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Andrew. All rights reserved.
//

#import "PerformanceMonitorConfiguration.h"

@interface PerformanceMonitor : NSObject

- (instancetype)initWithConfiguration:(PerformanceMonitorConfiguration *)configuration;
- (void)start;
- (void)stop;

- (void)asyncWriteCrashLogToFileWithName:(NSString *)name;
- (void)syncWriteCrashLogToFileWithName:(NSString *)name;

@end
