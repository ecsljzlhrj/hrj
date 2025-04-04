//
//  Category Button.swift
//  a p p
//
//  Created by Mac on 2025/3/28.
//

import SwiftUI

struct CategoryButton: View {
    let title: String
    @Binding var selectedCategory: String
    let color: Color
    
    init(title: String, selectedCategory: Binding<String>, color: Color = .blue) {
        self.title = title
        self._selectedCategory = selectedCategory
        self.color = color
    }
    
    var body: some View {
        Button(action: handleTap) { // 简化按钮声明
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? color : .gray)
                
                if isSelected {
                    selectionIndicator
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(CategoryButtonStyle(color: color))
    }
    
    // 子组件
    private var selectionIndicator: some View {
        Capsule()
            .fill(color)
            .frame(height: 2)
            .frame(maxWidth: 30)
            .transition(
                .asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.8)),
                    removal: .opacity.combined(with: .scale(scale: 0.8))
                )
                )
    }
    

    private var isSelected: Bool {
        selectedCategory == title
    }
    
    private func handleTap() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedCategory = title
        }
        HapticManager.mediumImpact()
    }
}

// 触觉反馈管理器
struct HapticManager {
    static func mediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}

// 按钮样式
struct CategoryButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// 预览
struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var selected = "推荐"
        
        var body: some View {
            VStack(spacing: 20) {
                CategoryButton(
                    title: "推荐",
                    selectedCategory: $selected
                )
                CategoryButton(
                    title: "热门",
                    selectedCategory: $selected
                )
                CategoryButton(
                    title: "经典",
                    selectedCategory: $selected,
                    color: .green
                )
            }
            .padding()
        }
    }
}
