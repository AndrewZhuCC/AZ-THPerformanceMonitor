//
//  PerformanceMonitorMarco.h
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/10.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#ifndef PerformanceMonitorMarco_h
#define PerformanceMonitorMarco_h

#import "PerformanceMonitorManager.h"
#import "PerformanceMonitor.h"
#import "PerformanceMonitorConfiguration.h"

#define ObserveRunLoop(mostCount, mils) (PerformanceMonitor *)^(){\
    PerformanceMonitorManager *manager = [PerformanceMonitorManager sharedInstance]; \
    PerformanceMonitorConfiguration *config = PerformanceMonitorConfiguration.new; \
    config.monitorType = MonitorType_RunLoop; \
    config.milliseconds = mils; \
    config.countToNotify = mostCount; \
    PerformanceMonitor *monitor = [[PerformanceMonitor alloc] initWithConfiguration:config]; \
    return [manager addObserver:monitor]; \
}();

#define ObserveCPU(mostUsage, mills) (PerformanceMonitor *)^(){ \
    PerformanceMonitorManager *manager = [PerformanceMonitorManager sharedInstance]; \
    PerformanceMonitorConfiguration *config = PerformanceMonitorConfiguration.new; \
    config.monitorType = MonitorType_CPU; \
    config.milliseconds = mills; \
    config.cpuUsageToNotify= mostUsage; \
    PerformanceMonitor *monitor = [[PerformanceMonitor alloc] initWithConfiguration:config]; \
    return [manager addObserver:monitor]; \
}();

#endif /* PerformanceMonitorMarco_h */
