import SwiftUI
import MapKit

struct PostDetailView: View {
    
    @ObservedObject var viewModel: PostDetailViewModel
    
    @State private var region: MKCoordinateRegion // 地图显示区域
    
    // 自定义标记图标
    let pinImage = Image(systemName: "mappin.circle.fill") // 使用系统的地图标记图标
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        // 初始化地图的区域，设置为帖子地点的经纬度
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.post.latitude, longitude: viewModel.post.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 帖子标题
                Text(viewModel.post.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                // 帖子中的图片（可滑动）
                if !viewModel.images.isEmpty {
                    TabView(selection: $viewModel.currentImageIndex) {
                        ForEach(0..<viewModel.images.count, id: \.self) { index in
                            Image(uiImage: viewModel.images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 250)
                                .cornerRadius(10)
                                .tag(index) // 每张图片都有一个唯一标识
                        }
                    }
                    .frame(height: 250)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))  // 显示点点
                }

                // 帖子文字内容
                Text(viewModel.post.text)
                    .font(.body)
                    .lineSpacing(8)
                    .padding(.horizontal)

                // 点赞和收藏显示
                HStack {
                    // 点赞部分
                    VStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        Text(viewModel.likeText())
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)

                    // 收藏部分
                    VStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.yellow)
                        Text(viewModel.favoriteText())
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top)

                // 帖子对应地点的地图显示+标记
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: [viewModel.post]) { post in
                    // Custom pin at the post's location
                    MapAnnotation(coordinate: post.coordinate) {
                        pinImage
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                }
                .frame(height: 250)
                .cornerRadius(10)
                .padding(.top)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - LocationAnnotation
struct LocationAnnotation: Identifiable {
    var id = UUID()  // 唯一标识符
    var coordinate: CLLocationCoordinate2D

    init(post: Post) {
        self.coordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
    }
}

// MARK: - Previews
struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // 模拟数据：Post
        let post = Post(
            title: "Post 1",
            images: [
                UIImage(systemName: "mountain.2.fill") ?? UIImage(),
                UIImage(systemName: "mountain.2.circle") ?? UIImage(),
                UIImage(systemName: "mountain.2") ?? UIImage()
            ],
            text: "This is the first post",
            likeCount: 10,
            favoriteCount: 5,
            latitude: 37.7749,
            longitude: -122.4194
        )
        
        // 创建 ViewModel，并传入模拟的 Post 数据
        let viewModel = PostDetailViewModel(post: post)
        
        // 返回 PostDetailView，传递 ViewModel
        return PostDetailView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)  // 让预览根据内容调整大小
            .padding()  // 给视图加点内边距，避免内容贴边显示
    }
}
