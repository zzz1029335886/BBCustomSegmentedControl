//
//  ImageAttachmentLabelImage.swift
//  ZZAutoRollView
//
//  Created by zerry on 2021/10/15.
//

import UIKit

extension ASAttributedString.ImageAttachment{
    
    /// 扩展AttributedString富文本，实现文本的边框，圆角，背景色，内外边距等
    /// - Parameters:
    ///   - text: 文本
    ///   - fontWeight: 文本字重
    ///   - fontSize: 文本大小
    ///   - textColor: 文本颜色
    ///   - backgroundColor: 背景色
    ///   - gradientColor: gradient背景色
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    ///   - cornerRadius: 圆角
    ///   - paddingEdge: 内边距
    ///   - marginEdge: 外边距
    /// - Returns: AttributedString富文本内容
    static func labelImage(
        _ text: String,
        fontWeight: UIFont.Weight,
        fontSize: CGFloat,
        textColor: UIColor,
        backgroundColor: UIColor? = nil,
        gradientColor: ASAttributedStringLabelImageGradientColor? = nil,
        borderColor: CGColor? = nil,
        borderWidth: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        paddingEdge: UIEdgeInsets? = nil,
        marginEdge: UIEdgeInsets = .zero
    ) -> ASAttributedString.ImageAttachment {
        let scale: CGFloat = 3
        
        let fontSize = fontSize * scale
        
        let marginEdge: UIEdgeInsets = .init(top: marginEdge.top * scale, left: marginEdge.left * scale, bottom: marginEdge.bottom * scale, right: marginEdge.right * scale)
        var paddingEdge = paddingEdge ?? .zero
        paddingEdge = .init(top: paddingEdge.top * scale, left: paddingEdge.left * scale, bottom: paddingEdge.bottom * scale, right: paddingEdge.right * scale)
        
        let font: UIFont = .systemFont(ofSize: fontSize, weight: fontWeight)
        
        let view = UIView()
        
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        
        if let borderWidth = borderWidth,
           let borderColor = borderColor {
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth * scale
        }
        if let cornerRadius = cornerRadius {
            view.layer.cornerRadius = cornerRadius * scale
            view.clipsToBounds = true
        }
        
        label.sizeToFit()
        view.addSubview(label)
        label.frame.origin = .init(x: paddingEdge.left, y: paddingEdge.top)
        view.frame.size = .init(width: paddingEdge.left + paddingEdge.right + label.frame.width, height: paddingEdge.top + paddingEdge.bottom + label.frame.height)
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
        if let gradientColor = gradientColor {
            view.backgroundColor = gradientColor.getColor(view.frame.size)
        }
        
        let image = view.zz_as_captureImageWith(edge: marginEdge)!
        return ASAttributedString.ImageAttachment.image(image, .custom(size: .init(width: image.size.width / scale, height: image.size.height / scale)))
    }
}

struct ASAttributedStringLabelImageGradientColor {
    enum Direction {
        /// 水平方向渐变
        /// 垂直方向渐变
        /// 主对角线方向渐变
        /// 副对角线方向渐变
        case horizontal, vertical, upwardDiagonalLine, downDiagonalLine
    }
    
    var direction: Direction
    var colors: [CGColor]
    
    func getColor(_ size: CGSize) -> UIColor {
        var size = size
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = size
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        if direction == .downDiagonalLine {
            startPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradientLayer.startPoint = startPoint
        
        switch direction {
        case .horizontal:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            size.height += 1
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .upwardDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .downDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return .init(patternImage: image ?? .init())
    }
}

fileprivate
extension UIView {
    func zz_as_captureImageWith(edge: UIEdgeInsets) -> UIImage? {
        
        let size: CGSize = .init(width: self.bounds.size.width + edge.left + edge.right, height: self.bounds.size.height + edge.top + edge.bottom)
        
        self.layer.frame.origin = .init(x: edge.left, y: edge.top)
        
        UIGraphicsBeginImageContext(size)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        
        let layer = CALayer.init()
        layer.frame.size = size
        layer.addSublayer(self.layer)
        layer.render(in: ctx)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
