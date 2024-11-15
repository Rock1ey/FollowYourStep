//
//  GuideView.swift
//  FollowYourStep
//
//  Created by 李明哲 on 2024/11/15.
//

import SwiftUI
import MapKit

struct GuideView: View {
    
    @StateObject private var viewModel: GuideViewModel
    @State private var region: MKCoordinateRegion
    @State private var selectedPost: Post?
    
    init(guide: Guide){
        _viewModel = StateObject(wrappedValue: GuideViewModel(guide: guide))
        
        // 设置默认的地图区域
        let center = guide.posts.first?.coordinate ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let initialRegion = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        _region = State(initialValue: initialRegion)
    }
    
    var body: some View{
        VStack{
            // 显示攻略标题和描述
            VStack(alignment: .leading) {
                Text(viewModel.guide.title)
                    .font(.largeTitle)
                    .bold()
                Text(viewModel.guide.description)
                    .font(.body)
                    .padding(.top, 5)
            }
            .padding()
            
            // 使用Map视图展示多个Post的标记和路线
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .none, annotationItems: viewModel.guide.posts) { post in
                MapPin(coordinate: post.coordinate, tint: .blue)
            }
            .onAppear {
                // 更新地图区域或其他初始化任务
                updateMapRegion()
            }
//            .overlay(
//                    PolylineView(coordinates: viewModel.routeCoordinates)
//            )
//            .onChange(of: selectedPost) { _ in
//                // 在这里处理点击标记后的操作，比如显示Post详情
//            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // 更新地图区域，使其显示所有Post的位置
    func updateMapRegion() {
        let coordinates = viewModel.guide.posts.map { $0.coordinate }
        if let firstCoordinate = coordinates.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            region = MKCoordinateRegion(center: firstCoordinate, span: span)
        }
    }
    
}

//struct PolylineView: View {
//    var coordinates: [CLLocationCoordinate2D]
//    
//    var body: some View {
//        // 使用MKPolyline来绘制路径
//        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//        
//        // 绘制红色路径线
//        MapOverlay(polyline)
//            .stroke(Color.red, lineWidth: 3)
//    }
//}

// 模拟数据
let samplePosts: [Post] = [
    Post(title: "Post 1", images: [UIImage(systemName: "star.fill")!], text: "This is the first post", likeCount: 10, favoriteCount: 5, latitude: 37.7749, longitude: -122.4194),
    Post(title: "Post 2", images: [UIImage(systemName: "star.fill")!], text: "This is the second post", likeCount: 20, favoriteCount: 10, latitude: 37.7849, longitude: -122.4094),
    Post(title: "Post 3", images: [UIImage(systemName: "star.fill")!], text: "This is the third post", likeCount: 15, favoriteCount: 8, latitude: 37.7949, longitude: -122.3994)
]

let sampleGuide = Guide(title: "Sample Guide", description: "This is a sample guide description", posts: samplePosts)

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView(guide: sampleGuide)
            .padding()
    }
}
