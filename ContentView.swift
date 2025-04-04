//
//  ContentView.swift
//  a p p
//
//  Created by Mac on 2025/3/28.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var bookListView = BookListView()
    @State private var Category: String = "推荐"

    var body: some View {
        NavigationView {
            VStack {
                Text("欢迎使用图书搜索")
                    .font(.largeTitle)
                    .padding()
                
                // 嵌入 BookSearchView
                BookSearchView()
                    .padding()
            }
            .navigationTitle("主界面")
            .navigationBarTitleDisplayMode(.inline) // 设置导航栏标题样式
        }
        NavigationView {
            VStack {
                // 选择分类的按钮
                Picker("选择分类", selection: $bookListView.selectedCategory) {
                    Text("推荐").tag("推荐")
                    Text("热销").tag("热销")
                    // 可以根据需要添加更多分类
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 显示书籍
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(bookListView.recommendedBooks, id: \.isbn) { book in
                            BookCoverView(book: book, size: CGSize(width: 120, height: 180))
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("书籍列表")
        }
        .onChange(of: bookListView.selectedCategory) { _ in
            bookListView.filterBooks()
        }
        NavigationView {
                    VStack {
                        // 选择分类的按钮
                        Picker("选择分类", selection: $bookListView.selectedCategory) {
                            Text("推荐").tag("推荐")
                            Text("热销").tag("热销")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        // 显示书籍
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(bookListView.recommendedBooks, id: \.isbn) { book in
                                    BookCard(book: book, cardType: .medium) {
                                        // 点击书籍卡片时的操作，例如：打开书籍详情
                                        print("Tapped on \(book.title)")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)

                        Spacer()
                    }
                    .navigationTitle("书籍列表")
                    .onChange(of: bookListView.selectedCategory) { _ in
                        bookListView.filterBooks()
                    }
                }
        NavigationView {
                    VStack {
                        // 分类按钮行
                        HStack(spacing: 20) {
                            CategoryButton(title: "推荐", selectedCategory: Category)
                            CategoryButton(title: "热销", selectedCategory: Category)
                            CategoryButton(title: "经典", selectedCategory: Category, color: .green)
                        }
                        .padding()

                        // 显示书籍
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(bookListView.books(for: Category), id: \.isbn) { book in
                                    BookCard(book: book, cardType: .medium) {
                                        // 点击书籍卡片时的操作
                                        print("Tapped on \(book.title)")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)

                        Spacer()
                    }
                    .navigationTitle("书籍列表")
                    .onChange(of: Category) { _ in
                        bookListView.filterBooks(for: Category)
                    }
                }
        NavigationView {
                    VStack {
                        // 分类按钮行
                        HStack(spacing: 20) {
                            CategoryButton(title: "推荐", selectedCategory: Category)
                            CategoryButton(title: "热销", selectedCategory: Category)
                            CategoryButton(title: "经典", selectedCategory: Category, color: .green)
                        }
                        .padding()

                        // 显示书籍
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(bookListView.books(for: Category), id: \.isbn) { book in
                                    HapticButton(action: {
                                        // 点击书籍卡片时的操作
                                        print("Tapped on \(book.title)")
                                    }) {
                                        BookCard(book: book, cardType: .medium) // 在 HapticButton 中包裹 BookCard
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)

                        Spacer()

                        // 示例 HapticButton，执行其他操作
                        HapticButton(action: {
                            // 在点击按钮时，执行某个操作
                            print("Action button tapped!")
                        }) {
                            Text("执行操作")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .navigationTitle("书籍列表")
                    .onChange(of: Category) { _ in
                        bookListView.filterBooks(for: Category)
                    }
                }
            
            }
    
    // 预览
    struct ParentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
