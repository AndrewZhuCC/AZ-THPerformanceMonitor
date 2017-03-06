//
//  AZPerformanceMonitorCPU.m
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/9.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "AZPerformanceMonitorCPU.h"
#import <mach/mach.h>
#import <pthread/pthread.h>

@interface AZPerformanceMonitorCPU ()

@property (nonatomic, assign) double cpuUsageToNotify;
@property (nonatomic, assign) NSUInteger millisecondsToObserve;

@property (nonatomic, strong) dispatch_queue_t observeQueue;
@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation AZPerformanceMonitorCPU

- (instancetype)initWithConfiguration:(AZPerformanceMonitorConfiguration *)configuration {
    self = [super init];
    if (self) {
        _cpuUsageToNotify = configuration.cpuUsageToNotify / 100.f;
        _millisecondsToObserve = configuration.milliseconds;
        _observeQueue = dispatch_queue_create("CPU Usage Observe Queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)start {
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.observeQueue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.millisecondsToObserve * NSEC_PER_MSEC, 0);
    
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(self.timer, ^{
        typeof(wself) sself = wself;
        if (sself) {
            [sself timerHandler];
        }
    });
    dispatch_resume(self.timer);
}

- (void)timerHandler {
    NSArray *threads = [self cpuUsage];
    double cpuUsage = [[threads lastObject] doubleValue];
    if (cpuUsage >= self.cpuUsageToNotify) {
        printf("<------\nCPU Usage Over:%.02f%% Now:%.02f%%\n------>\n", 100.f * self.cpuUsageToNotify, 100.f * cpuUsage);
        [self syncWriteCrashLogToFileWithName:[NSString stringWithFormat:@"CPU(PercentLimit-%@%% ObserveTimeStamp-%@ Now-%.02f)", @(self.cpuUsageToNotify * 100), @(self.millisecondsToObserve), 100.f * cpuUsage] attach:threads.debugDescription];
    }
}

- (void)stopWithCompletionHandler:(void(^)())completionHandler {
    dispatch_async(self.observeQueue, ^{
        if (self.timer) {
            dispatch_source_set_cancel_handler(self.timer, completionHandler);
            dispatch_source_set_event_handler(self.timer, nil);
            dispatch_resume(self.timer);
            dispatch_source_cancel(self.timer);
        }
    });
}

- (void)setPause:(BOOL)pause {
    dispatch_async(self.observeQueue, ^{
        [super setPause:pause];
        if (self.timer) {
            if (pause) {
                dispatch_suspend(self.timer);
            } else {
                dispatch_resume(self.timer);
            }
        }
    });
}

- (NSArray *)cpuUsage
{
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return @[@(0.0)];
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return @[@(0.0)];
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    NSMutableArray *threads = @[].mutableCopy;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return @[@(0.0)];
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
            
            pthread_t pthread = pthread_from_mach_thread_np(thread_list[i]);
            char name[1024] = { 0 };
            pthread_getname_np(pthread, name, sizeof(name));
            __uint64_t threadid = 0;
            pthread_threadid_np(pthread, &threadid);
            NSString *objName = [NSString stringWithUTF8String:name];
            [threads addObject:@{@"name":objName, @"id":@(threadid), @"usage":@(basic_info_th->cpu_usage / (float)TH_USAGE_SCALE)}];
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return @[@(0.0)];
    
    [threads addObject:@(tot_cpu)];
    
    return threads.copy;
}

@end
