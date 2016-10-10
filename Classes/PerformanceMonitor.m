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
#import <CrashReporter/CrashReporter.h>

@interface PerformanceMonitor ()

@property (nonatomic, strong) dispatch_queue_t ioQueue;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("Monitor IO Queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)syncWriteCrashLogToFileWithName:(NSString *)name {
    dispatch_sync(self.ioQueue, ^{
        [self doWriteLogWithName:name];
    });
}

- (void)asyncWriteCrashLogToFileWithName:(NSString *)name {
    dispatch_async(self.ioQueue, ^{
        [self doWriteLogWithName:name];
    });
}

- (void)doWriteLogWithName:(NSString *)name {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy#MM#dd-HH$mm$ss$SSS"];
    NSString *logName = [NSString stringWithFormat:@"%@-%@.crash", [formatter stringFromDate:date], name];
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategySymbolTable];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                              withTextFormat:PLCrashReportTextFormatiOS];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];;
    filePath = [filePath stringByAppendingPathComponent:@"PerformanceMonitorLogs"];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            filePath = [filePath stringByAppendingPathComponent:logName];
            [fileManager createFileAtPath:filePath contents:[report dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    } else {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]) {
            filePath = [filePath stringByAppendingPathComponent:logName];
            [fileManager createFileAtPath:filePath contents:[report dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        } else {
            NSLog(@"Create Directory fail:%@", error);
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
