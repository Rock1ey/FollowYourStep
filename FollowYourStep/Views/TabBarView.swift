import SwiftUI

struct TabBarView: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("首页按钮点击")
            }) {
                Text("首页")
                    .font(.system(size: 16))
                    .padding()
            }
            Spacer()
            Button(action: {
                print("攻略按钮点击")
            }) {
                Text("攻略")
                    .font(.system(size: 16))
                    .padding()
            }
            Spacer()
            Button(action: {
                print("发布按钮点击")
            }) {
                Text("发布")
                    .font(.system(size: 16))
                    .padding()
            }
            Spacer()
            Button(action: {
                print("个人中心按钮点击")
            }) {
                Text("个人中心")
                    .font(.system(size: 16))
                    .padding()
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .frame(height: 60)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        // 单独预览 TabBarView
        TabBarView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white) // 背景设置为白色，便于查看
    }
}
