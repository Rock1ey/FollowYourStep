//
//  PathView.swift
//  FollowYourStep
//
//  Created by admin on 2024/11/15.
//

import SwiftUI
import MapKit

struct PathView: UIViewRepresentable {
    var coordinates: [CLLocationCoordinate2D]
    var posts: [Post]
    var onPostSelected: (Post) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator // 设置地图的代理
        mapView.showsUserLocation = true // 显示用户当前位置
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 清除之前的所有覆盖物
        uiView.removeOverlays(uiView.overlays)
        
        // 如果坐标数组不为空，创建并添加新的路径
        if coordinates.count > 1 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            uiView.addOverlay(polyline) // 添加路径到地图
        }
        
        // 添加 Post 的标记
        for post in posts {
            let annotation = MKPointAnnotation()
            annotation.coordinate = post.coordinate
            annotation.title = post.title
            uiView.addAnnotation(annotation)
        }
        
        // 更新地图的显示区域，使其显示所有的路径
        if let firstCoordinate = coordinates.first {
            let region = MKCoordinateRegion(
                center: firstCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(posts: posts, onPostSelected: onPostSelected)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var posts: [Post]
        var onPostSelected: (Post) -> Void

        init(posts: [Post], onPostSelected: @escaping (Post) -> Void) {
            self.posts = posts
            self.onPostSelected = onPostSelected
        }
        
        // 处理标记点击事件
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            guard let title = annotation.title else { return }
            if let selectedPost = posts.first(where: { $0.title == title }) {
                // 调用闭包，传递被点击的 Post
                onPostSelected(selectedPost)
            }
        }
        
        // 代理方法，用于绘制路径样式
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .red // 设置路径颜色为红色
                renderer.lineWidth = 3 // 设置路径线宽
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

//#Preview {
//    PathView()
//}
