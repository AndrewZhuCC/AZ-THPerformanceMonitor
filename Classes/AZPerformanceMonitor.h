//
//  AZPerformanceMonitor.h
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitorConfiguration.h"

@interface AZPerformanceMonitor : NSObject

@property (nonatomic, assign, getter=isPaused) BOOL pause;

@property (nonatomic, strong, readonly) AZPerformanceMonitorConfiguration *config;

- (instancetype)initWithConfiguration:(AZPerformanceMonitorConfiguration *)configuration;
- (void)start;
- (void)stop;

- (void)asyncWriteCrashLogToFileWithName:(NSString *)name;
- (void)syncWriteCrashLogToFileWithName:(NSString *)name;

@end
