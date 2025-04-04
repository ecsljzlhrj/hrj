//
//  Search.swift
//  a p p
//
//  Created by Mac on 2025/3/28.
//

// BookSearchView.swift
import SwiftUI

struct BookSearchView: View {
    @State private var isbn = ""
    @State private var book: Book?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            // 输入框
            TextField("输入ISBN号", text: $isbn)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding()
                .onChange(of: isbn) { newValue in
                    isbn = newValue.filter { $0.isNumber || $0 == "-" }
                }
            
            // 搜索按钮
            Button(action: searchBook) {
                Text("搜索书籍")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isbn.isEmpty)
            
            // 加载状态
            if isLoading {
                ProgressView()
                    .controlSize(.large)
            }
            
            // 错误提示
            if let errorMessage {
                Text("错误: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // 书籍信息展示
            if let book {
                VStack(spacing: 15) {
                    // 封面图片
                    AsyncImage(url: book.coverImageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // 书籍信息
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.title)
                            .font(.title2.bold())
                        
                        Text("作者: \(book.author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(book.category)
                                .font(.caption)
                                .padding(4)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.2))
                                )
                            
                            RatingView(rating: book.rating)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 3)
                )
            }
        }
        .padding()
        .navigationTitle("图书搜索")
    }
    
    private func searchBook() {
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            do {
                // 1. 验证ISBN格式
                guard isValidISBN(isbn) else {
                    throw ParsingError.invalidISBN
                }
                
                // 2. 获取HTML内容
                let html = try await fetchHTML()
                
                // 3. 解析书籍信息
                let result = try WebScraper.parseBookInfo(from: html)
                
                // 4. 创建书籍对象
                book = Book(
                    isbn: normalizedISBN,
                    title: result.title,
                    author: result.author,
                    category: "未分类", // 可根据需要添加分类解析
                    rating: 0.0,      // 可根据需要添加评分解析
                    isInBookmark: false, description: "无描述" // 这里可以根据需要修改DESCRIPTION
                )
                
            } catch {
                handleError(error)
            }
        }
    }
    private func fetchHTML() async throws -> String {
        let normalizedISBN = isbn.replacingOccurrences(of: "-", with: "")
        guard let url = URL(string: "https://book.douban.com/isbn/\(normalizedISBN)/") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    private var normalizedISBN: String {
        isbn.replacingOccurrences(of: "-", with: "")
    }
    
    private func isValidISBN(_ isbn: String) -> Bool {
        let cleanedISBN = normalizedISBN
        return cleanedISBN.count == 10 || cleanedISBN.count == 13
    }
    
    private func handleError(_ error: Error) {
        switch error {
        case ParsingError.invalidTitle:
            errorMessage = "标题解析失败"
        case ParsingError.invalidAuthor:
            errorMessage = "作者信息无效"
        case ParsingError.invalidCoverURL:
            errorMessage = "封面获取失败"
        case ParsingError.invalidISBN:
            errorMessage = "无效的ISBN格式"
        case let urlError as URLError:
            errorMessage = "网络错误: \(urlError.localizedDescription)"
        default:
            errorMessage = "发生未知错误: \(error.localizedDescription)"
        }
    }
}

// 预览
struct BookSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookSearchView()
        }
    }
}
