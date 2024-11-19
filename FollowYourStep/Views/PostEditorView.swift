//
//  PostEditorView.swift
//  Test
//
//  Created by admin on 2024/11/19.
//

import SwiftUI
import CoreLocation

struct PostEditorView: View {
    @StateObject var viewModel: PostEditorViewModel
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var isLocationPickerPresented: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                // 标题输入
                Section(header: Text("Title")) {
                    TextField("Enter post title", text: $viewModel.title)
                        .onChange(of: viewModel.title) { newTitle in
                            viewModel.updateTitle(newTitle)
                        }
                        .foregroundColor(viewModel.isTitleValid ? .primary : .red)
                }
                
                // 内容输入
                Section(header: Text("Post Text")) {
                    TextEditor(text: $viewModel.text)
                        .onChange(of: viewModel.text) { newText in
                            viewModel.updateText(newText)
                        }
                        .frame(height: 150)
                        .foregroundColor(viewModel.isTextValid ? .primary : .red)
                }
                
                // 图片选择
                Section(header: Text("Images")) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        HStack {
                            Image(uiImage: viewModel.images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Spacer()
                            Button(action: {
                                viewModel.deleteImage(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Image")
                        }
                    }
                }
                
                // 位置选择
                Section(header: Text("Location")) {
                    Button(action: {
                        isLocationPickerPresented = true
                    }) {
                        Text("Select Location")
                    }
                }
                
                // 保存按钮
                Section {
                    Button(action: savePost) {
                        Text("Save Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isTitleValid && viewModel.isTextValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(!(viewModel.isTitleValid && viewModel.isTextValid))
                }
            }
            .navigationBarTitle("Edit Post", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                // Handle cancel action (e.g., dismiss view)
            })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
                    .onChange(of: selectedImage) { newImage in
                        if let newImage = newImage {
                            viewModel.addImage(newImage)
                        }
                    }
            }
            .sheet(isPresented: $isLocationPickerPresented) {
                LocationPickerView(selectedCoordinate: $viewModel.selectedLocation)
            }
        }
    }
    
    private func savePost() {
        // Handle saving the post
        let savedPost = viewModel.savePost()
        print("Saved Post: \(savedPost)")
    }
}

struct PostEditorView_Previews: PreviewProvider {
    static var previews: some View {
        // 预览需要一个示例的 PostEditorViewModel
        // 这里初次传入的坐标在应用中为当前坐标
        let examplePost = Post(id: UUID(),
                               title: "",
                               images: [UIImage(systemName: "star.fill")!],
                               text: "",
                               likeCount: 0,
                               favoriteCount: 0,
                               latitude: 37.7749,
                               longitude: -122.4194)

        let viewModel = PostEditorViewModel(post: examplePost)
        
        // 返回 PostEditorView 的预览
        PostEditorView(viewModel: viewModel)
    }
}

