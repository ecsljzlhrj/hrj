//
//  BookListVieW.swift
//  a p p
//
//  Created by Mac on 2025/4/4.
//
import SwiftUI
import Foundation

class BookListView: ObservableObject {
    @Published var selectedCategory = "推荐"
    @Published var recommendedBooks: [Book] = []
    @Published var hotListBooks: [Book] = []
    
    init() {
        fetchBooks()
    }
    
    func fetchBooks() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.recommendedBooks = [
                Book(
                    isbn: "9787536692930",
                    title: "三体",
                    author: "刘慈欣",
                    category: "科幻",
                    rating: 9.4,
                    isInBookmark: false,
                    description: """
                    文化大革命如火如荼进行的同时，军方探寻外星文明的绝秘计划"红岸工程"取得了突破性进展。
                    """
                ),
                Book(
                    isbn: "9787506365437",
                    title: "活着",
                    author: "余华",
                    category: "文学",
                    rating: 9.2,
                    isInBookmark: true,
                    description: """
                    《活着》讲述了农村人福贵悲惨的人生遭遇。
                    """
                )
            ]
            
            self?.hotListBooks = [
                Book(
                    isbn: "9787544291170",
                    title: "百年孤独",
                    author: "加西亚·马尔克斯",
                    category: "魔幻现实主义",
                    rating: 9.5,
                    isInBookmark: false,
                    description: """
                    讲述了布恩迪亚家族七代人的故事，融入了魔幻与现实。
                    """
                ),
                Book(
                    isbn: "9787020042494",
                    title: "平凡的世界",
                    author: "路遥",
                    category: "现实主义",
                    rating: 9.0,
                    isInBookmark: true,
                    description: """
                    描述了中国农村改革开放初期的艰辛与希望。
                    """
                )
            ]
        }
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
        filterBooks()
    }
    
    private func filterBooks() {
        // 示例筛选逻辑
        if selectedCategory == "推荐" {
            recommendedBooks.sort { $0.rating > $1.rating }
        } else {
            recommendedBooks = recommendedBooks.filter { $0.category == selectedCategory }
        }
    }
}

