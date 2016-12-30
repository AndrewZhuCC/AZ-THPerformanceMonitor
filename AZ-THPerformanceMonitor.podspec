Pod::Spec.new do |s|
  s.name         = "AZ-THPerformanceMonitor"
  s.version      = "0.0.15"
  s.summary      = "iOS performance monitor."
  s.homepage     = "https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrew" => "zaz92537@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/AndrewZhuCC/AZ-THPerformanceMonitor.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/*.{h,m}"
  s.requires_arc = true
  s.vendored_framework = "PerformanceMonitor/CrashReporter.framework"
end
