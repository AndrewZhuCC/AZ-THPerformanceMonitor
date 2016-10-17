//
//  AZPerformanceMonitorRunLoop.m
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitorRunLoop.h"

@interface AZPerformanceMonitorRunLoop ()

@property (nonatomic, assign) NSUInteger timeout;
@property (nonatomic, assign) NSUInteger milliseconds;
@property (nonatomic, assign) NSUInteger timeoutCount;
@property (nonatomic, assign) CFRunLoopObserverRef observer;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CFRunLoopActivity activity;

@property (nonatomic, strong) dispatch_queue_t observeQueue;

@property (nonatomic, strong) dispatch_semaphore_t ioLock;

@end

@implementation AZPerformanceMonitorRunLoop

- (instancetype)initWithConfiguration:(AZPerformanceMonitorConfiguration *)configuration {
    self = [super init];
    if (self) {
        _timeout = configuration.countToNotify;
        _milliseconds = configuration.milliseconds;
        _observeQueue = dispatch_queue_create("RunLoop Performance Observe Queue", DISPATCH_QUEUE_SERIAL);
        _ioLock = dispatch_semaphore_create(0);
    }
    return self;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    AZPerformanceMonitorRunLoop *monitor = (__bridge AZPerformanceMonitorRunLoop*)info;
    
    monitor.activity = activity;
    
    if (monitor.observer && !monitor.isPaused) {
        dispatch_semaphore_t semaphore = monitor.semaphore;
        dispatch_semaphore_wait(semaphore, NSEC_PER_USEC);
        dispatch_semaphore_signal(semaphore);
    }
}

- (void)stop
{
    if (!self.observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    CFRelease(self.observer);
    self.observer = NULL;
}

- (void)start
{
    if (self.observer)
        return;
    
    // 信号
    self.semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(self.observeQueue, ^{
        while (YES)
        {
            if (!self.observer)
            {
                self.timeoutCount = 0;
                self.semaphore = 0;
                self.activity = 0;
                return;
            }
            
            if (self.isPaused) {
                dispatch_semaphore_wait(self.ioLock, DISPATCH_TIME_FOREVER);
            }
            
            long st = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, self.milliseconds*NSEC_PER_MSEC));
            if (st != 0)
            {
                if (self.activity==kCFRunLoopBeforeSources || self.activity==kCFRunLoopAfterWaiting)
                {
                    if ((++self.timeoutCount < self.timeout) || self.isPaused)
                        continue;
                    
                    printf("------>\nRunLoop observe fires\n<------\n");
                    [self asyncWriteCrashLogToFileWithName:[NSString stringWithFormat:@"RunLoop(LimitCount:%@ ObserveTimestamp:%@)", @(self.timeout), @(self.milliseconds)]];
                }
            }
            self.timeoutCount = 0;
        }
    });
}

- (void)setPause:(BOOL)pause {
    [super setPause:pause];
    if (!pause && self.observer) {
        dispatch_semaphore_wait(self.ioLock, NSEC_PER_USEC);
        dispatch_semaphore_signal(self.ioLock);
    }
}

@end
