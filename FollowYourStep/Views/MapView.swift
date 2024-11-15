import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel() // 使用 ViewModel
    @State private var region: MKCoordinateRegion
    @State private var isLocationPermissionRequested = false
    
    // 初始化默认的地图区域
    init() {
        // 设置初始显示区域（例如：旧金山）
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        _region = State(initialValue: initialRegion)
    }
    
    var body: some View {
        ZStack {
            // 使用 Map 视图来展示地图
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onAppear {
                    // 请求位置权限并获取用户的坐标
                    viewModel.requestLocationPermission() // 请求位置权限
                    viewModel.startUpdatingLocation() // 开始获取用户坐标
                }
                .onChange(of: viewModel.userLocation) { newLocation in
                    // 当用户的坐标从后端获取后，更新地图区域
                    if let userLocation = newLocation {
                        region = MKCoordinateRegion(
                            center: userLocation,
                            span: region.span
                        )
                    }
                }
            
            // 如果有用户位置，更新地图区域并显示标记
//            if let userLocation = viewModel.userLocation {
//                VStack {
//                    Image(systemName: "location.fill")
//                        .foregroundColor(.blue)
//                        .font(.title)
//                    Text("Your Location")
//                        .font(.caption)
//                        .foregroundColor(.blue)
//                        .padding(5)
//                        .background(Color.white)
//                        .cornerRadius(8)
//                }
//                .offset(x: 0, y: -30) // 上移标记
//            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
