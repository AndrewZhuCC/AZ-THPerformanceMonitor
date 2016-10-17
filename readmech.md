# AZ-THPerformanceMonitor
[AZ-THPerformanceMonitor](https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor) 是一个基于 [老谭笔记](http://www.tanhao.me/code/151113.html/) 博客中对 **主线程RunLoop** 卡顿的监控demo，并集成 **CPU使用率** 监控功能的框架。当`RunLoop`耗时超过设定的时间一定次数或者CPU使用率超过一定限度，则会抓取当前所有线程的函数调用栈，以`*.crash`的格式保存在`~/Documents/PerformanceMonitorLogs/`文件夹下。目前开源在 [GitHub](https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor) 上。

## Install
### - CocoaPods
[CocoaPods](https://www.cocoapods.org) 是一个管理供 Xcode 使用的开源框架的工具。可以方便的集成、更新开源框架，或者自己私有的框架。
通过 CocoaPods 将 AZ-THPerformanceMonitor 集成到项目中很简单，把 `pod 'AZ-THPerformanceMonitor', '~> 0.0.7'` 加入到你的 `Podfile` 中即可
```ruby
platform :ios, '7.0'

target :YourTarget do
   pod 'AZ-THPerformanceMonitor', '~> 0.0.7'
end
```
### - Manual
你也可以手动把 AZ-THPerformanceMonitor 加入到项目中。把 `Class` 目录下的所有文件导入到项目中即可。

## Usage
```objc
#import "AZPerformanceMonitorMarco.h"

...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AZPerformanceMonitor *monitor = ObserveRunLoop(1, 10)
    AZPerformanceMonitor *anotherMonitor = ObserveCPU(90.f, 500)
    
    return YES;
}
```
`OberveRunLoop(mostCount, mils)` 是一个便捷启动 **RunLoop监控** 的宏。`mils` 的含义是当主线程的[两个耗时阶段](https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor/blob/master/LICENSE)的**监控耗时触发点**，以毫秒为单位。`mostCount` 的含义是连续出现**耗时超时**则触发抓取动作的次数。<br>
`ObserveCPU(usage, mils)` 则是启动 **CPU使用率监控** 的宏。`usage` 参数指触发抓取动作的CPU使用率下限，`mils` 是两次监控的时间间隔，以毫秒为单位。<br>
这两个宏都会返回一个 `AZPerformanceMonitor` 的实例，可以持有该实例，进而可以在适时停止或者暂停监控(*目前抓取所有线程函数调用栈的动作会导致CPU占用率提高30%～40%左右，因此每次触发抓取动作，`AZPerformanceMonitorManager` 会主动暂停所有监控，待抓取动作完成才继续监控*)。也可以通过 `AZPerformanceMonitorManager` 单例来管理所有的监控动作。

## License
[MIT](https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor/blob/master/LICENSE)

