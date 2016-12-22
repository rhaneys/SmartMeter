# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'SmartMeter' do
pod 'Alamofire', '~> 3.4'
pod 'SwiftyJSON', '~> 2.3'
pod 'ReactiveCocoa', '~>4.2.2'
pod 'Realm', '~> 2.0.2'
pod 'RealmSwift', '~> 2.0.2'
pod 'XCGLogger', '~> 3.1.1'
pod 'OpenCV'

end

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

target 'SmartMeterTests' do
    testing_pods
end

target 'SmartMeterUITests' do
    testing_pods
end
