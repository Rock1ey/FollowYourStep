//
//  Post.swift
//  FollowYourStep
//
//  Created by 李明哲 on 2024/11/13.
//


import Foundation
import UIKit
import MapKit

// 这是 Post 的数据模型
struct Post: Identifiable {
    var id: UUID
    var title: String
    var images: [UIImage] // 允许多张图片
    var text: String
    var likeCount: Int
    var favoriteCount: Int
    var latitude: Double // 纬度
    var longitude: Double // 经度
    var coordinate: CLLocationCoordinate2D
    
    // 初始化方法
    init(id: UUID = UUID(), title: String, images: [UIImage], text: String, likeCount: Int, favoriteCount: Int, latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.images = images
        self.text = text
        self.likeCount = likeCount
        self.favoriteCount = favoriteCount
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

// 要不要改成class

// 要做的页面：
// 1.首页推荐？列
// “附近”页面，查看附近的帖子
// 好友功能/关注功能
// “攻略”，即将几个帖子组织成一份攻略发布（在地图上标出路线等等）
// 个人信息界面
