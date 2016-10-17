//
//  AZPerformanceMonitorMarco.h
//  PerformanceMonitor
//
//  Created by 朱安智 on 2016/10/10.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#ifndef AZPerformanceMonitorMarco_h
#define AZPerformanceMonitorMarco_h

#import "AZPerformanceMonitorManager.h"
#import "AZPerformanceMonitor.h"
#import "AZPerformanceMonitorConfiguration.h"

#define ObserveRunLoop(mostCount, mils) (AZPerformanceMonitor *)^(){\
    AZPerformanceMonitorManager *manager = [AZPerformanceMonitorManager sharedInstance]; \
    AZPerformanceMonitorConfiguration *config = AZPerformanceMonitorConfiguration.new; \
    config.monitorType = MonitorType_RunLoop; \
    config.milliseconds = mils; \
    config.countToNotify = mostCount; \
    AZPerformanceMonitor *monitor = [[AZPerformanceMonitor alloc] initWithConfiguration:config]; \
    return [manager addObserver:monitor]; \
}();

#define ObserveCPU(mostUsage, mills) (AZPerformanceMonitor *)^(){ \
    AZPerformanceMonitorManager *manager = [AZPerformanceMonitorManager sharedInstance]; \
    AZPerformanceMonitorConfiguration *config = AZPerformanceMonitorConfiguration.new; \
    config.monitorType = MonitorType_CPU; \
    config.milliseconds = mills; \
    config.cpuUsageToNotify= mostUsage; \
    AZPerformanceMonitor *monitor = [[AZPerformanceMonitor alloc] initWithConfiguration:config]; \
    return [manager addObserver:monitor]; \
}();

#endif /* AZPerformanceMonitorMarco_h */
