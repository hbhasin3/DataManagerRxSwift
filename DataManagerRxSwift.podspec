Pod::Spec.new do |spec|

spec.name         = "DataManagerRxSwift"
spec.version      = "1.0.1"
spec.summary      = "Service Manager written purely on RxSwift."

spec.description  = <<-DESC
This CocoaPods library helps you perform Service Calls.
DESC

spec.homepage     = "https://github.com/hbhasin3/DataManagerRxSwift"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author       = { "Harsh" => "harsh.bhasin@yahoo.com" }

spec.ios.deployment_target = "10.0"
spec.swift_version = "4.0"

spec.source        = { :git => "https://github.com/hbhasin3/DataManagerRxSwift.git", :tag => "#{spec.version}" }
spec.source_files  = "DataManagerRxSwift/**/*.{h,m,swift}"
spec.dependency "RxSwift", "~> 4.0"

end
