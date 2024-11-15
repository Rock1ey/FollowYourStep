//
//  PostDetailViewModel.swift
//  FollowYourStep
//
//  Created by 李明哲 on 2024/11/13.
//


import Foundation
import Combine
import UIKit

// 这是 ViewModel，用于处理视图的业务逻辑
class PostDetailViewModel: ObservableObject {
    
    @Published var post: Post
    @Published var currentImageIndex: Int = 0  // 当前显示的图片索引
    
    // 计算属性：返回用于显示的图片数量
    var images: [UIImage] {
        return post.images
    }
    
    // 计算属性：获取图片数量
    var totalImagesCount: Int {
        return post.images.count
    }
    
    // 初始化方法
    init(post: Post) {
        self.post = post
    }
    
    // 切换到下一张图片
    func goToNextImage() {
        if currentImageIndex < totalImagesCount - 1 {
            currentImageIndex += 1
        }
    }
    
    // 切换到上一张图片
    func goToPreviousImage() {
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        }
    }
    
    // 获取点赞和收藏的文本
    func likeText() -> String {
        return "\(post.likeCount)"
    }
    
    func favoriteText() -> String {
        return "\(post.favoriteCount)"
    }
}
