//
//  AZPerformanceMonitor.h
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitorConfiguration.h"

extern NSNotificationName const AZPerformanceMonitorWritingLog;

@interface AZPerformanceMonitor : NSObject

@property (nonatomic, assign, getter=isPaused) BOOL pause;

@property (nonatomic, strong, readonly) AZPerformanceMonitorConfiguration *config;

- (instancetype)initWithConfiguration:(AZPerformanceMonitorConfiguration *)configuration;
- (void)start;
- (void)stopWithCompletionHandler:(void(^)())completionHandler;

- (void)asyncWriteCrashLogToFileWithName:(NSString *)name attach:(NSString *)attach;
- (void)syncWriteCrashLogToFileWithName:(NSString *)name attach:(NSString *)attach;

@end
