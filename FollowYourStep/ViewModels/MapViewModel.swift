//
//  MapViewModel.swift
//  FollowYourStep
//
//  Created by 李明哲 on 2024/11/13.
//


import Foundation
import Combine
import CoreLocation


// ViewModel 用于处理位置逻辑
class MapViewModel: ObservableObject {
    
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager: UserLocationManager
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.locationManager = UserLocationManager()
        
        // 监听位置变化
        locationManager.$userLocation
            .assign(to: \.userLocation, on: self)
            .store(in: &cancellables)
    }
    
    // 请求权限并开始更新位置
    func requestLocationPermission() {
        locationManager.requestLocationPermission()
    }
    
    // 开始获取用户位置
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation { [weak self] coordinate in
            self?.userLocation = coordinate
        }
    }
}
