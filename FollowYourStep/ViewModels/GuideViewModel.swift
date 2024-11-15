//
//  GuideViewModel.swift
//  FollowYourStep
//
//  Created by 李明哲 on 2024/11/15.
//

import Foundation
import MapKit
import Combine

class GuideViewModel: ObservableObject {
    @Published var guide: Guide
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    
    init(guide: Guide) {
        self.guide = guide
        self.routeCoordinates = guide.posts.map { $0.coordinate }
    }
    
    // 如果需要从后端获取数据，您可以定义一个方法来请求并解析数据
    func fetchGuideData() {
        // 假设从后端获取数据并更新 `guide` 和 `routeCoordinates`
    }
}
