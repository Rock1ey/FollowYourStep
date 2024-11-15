import CoreLocation // 用于访问设备的位置信息和方向
import Combine // 用于响应式编程，允许我们将位置数据绑定到 UI 或其他逻辑中。通过 @Published 和 Combine 的机制，我们可以轻松地监听 userLocation 属性的变化

// 用于管理用户位置的 Model
class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    /*
     NSObject: CLLocationManager 需要继承 NSObject，因此 UserLocationManager 类也需要继承自 NSObject。
     ObservableObject: 使得该类成为一个可观察的对象，允许它发布变化，通知订阅者（如视图模型）更新。
     CLLocationManagerDelegate: 这是 CoreLocation 中的一个协议，UserLocationManager 需要遵循该协议来接收位置更新和处理错误。
     */
    
    private var locationManager: CLLocationManager // CLLocationManager 的实例，用来请求并获取设备的位置信息
    
    @Published var userLocation: CLLocationCoordinate2D? // 使用 @Published 属性包装器，表示用户的位置。这个属性一旦发生变化，会自动通知所有绑定该属性的视图更新。在这里，它是一个 CLLocationCoordinate2D 类型，存储经纬度坐标
    
    private var locationUpdateHandler: ((CLLocationCoordinate2D) -> Void)? // 一个闭包，保存用户位置更新后的处理逻辑。当位置更新时，它将会被调用
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    // 请求用户位置授权
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // 开始获取用户位置
    func startUpdatingLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        locationUpdateHandler = completion
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            // 处理没有开启位置服务的情况
            print("Location services are not enabled.")
        }
    }
    
    // CLLocationManagerDelegate 方法：更新位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 返回最新的用户位置
        self.userLocation = location.coordinate
        if let handler = locationUpdateHandler {
            handler(location.coordinate)
        }
    }
    
    // CLLocationManagerDelegate 方法：位置获取失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable{
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
