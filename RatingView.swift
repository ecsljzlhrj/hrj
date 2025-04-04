//
//  RatingView.swift
//  a p p
//
//  Created by Mac on 2025/3/29.
//

import SwiftUI

/// 可定制的评分视图
struct RatingView: View {
    // 配置参数
    let rating: Double
    let maxRating: Int
    let starColor: Color
    let starSize: CGFloat
    let spacing: CGFloat
    
    /// 初始化配置
    /// - Parameters:
    ///   - rating: 当前评分（支持小数）
    ///   - maxRating: 最大星数（默认5）
    ///   - starColor: 星星颜色（默认系统黄色）
    ///   - starSize: 星星尺寸（默认20）
    ///   - spacing: 星星间距（默认2）
    init(
        rating: Double,
        maxRating: Int = 5,
        starColor: Color = .yellow,
        starSize: CGFloat = 20,
        spacing: CGFloat = 2
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.starColor = starColor
        self.starSize = starSize
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<maxRating, id: \.self) { index in
                starImage(for: Double(index))
                    .foregroundColor(starColor)
                    .frame(width: starSize, height: starSize)
            }
        }
    }
    
    // MARK: - 私有方法
    /// 根据当前索引计算星标显示状态
    private func starImage(for position: Double) -> Image {
        let difference = rating - position
        
        return switch difference {
        case ...0.0: // 空星
            Image(systemName: "star")
        case 0.01..<0.25: // 空星（微调范围）
            Image(systemName: "star")
        case 0.25..<0.75: // 半颗星
            Image(systemName: "star.leadinghalf.filled")
        case 0.75...1.0: // 一颗星
            Image(systemName: "star.fill")
        default:
            Image(systemName: "star.fill")
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RatingView(rating: 3.5)
                .font(.largeTitle)
            
            RatingView(rating: 4.2, starColor: .purple, starSize: 30)
            
            RatingView(rating: 2.7, maxRating: 10, starColor: .blue)
        }
        .previewLayout(.sizeThatFits)
    }
}
