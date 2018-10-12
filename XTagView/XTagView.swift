//
//  XTagView.swift
//  XTagView
//
//  Created by shuhei komino on 2018/10/11.
//  Copyright © 2018年 komi2. All rights reserved.
//

import Foundation

class XTagLabel: UILabel {
    
    let insets: UIEdgeInsets
    
    init(frame: CGRect, cornerRadius: CGFloat, insets: UIEdgeInsets) {
        
        self.insets = insets
        super.init(frame: frame)
    
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
        
        numberOfLines = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        isUserInteractionEnabled = true
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

public protocol XTagViewDelegate {
    func selectTag(sender: UILabel)
    func backgroundColor(index: Int, title: String, currentColor: UIColor) -> UIColor
    func titleColor(index: Int, title: String, currentColor: UIColor) -> UIColor
}

public extension XTagViewDelegate {
    func backgroundColor(index: Int, title: String, currentColor: UIColor) -> UIColor {
        return currentColor
    }
    func titleColor(index: Int, title: String, currentColor: UIColor) -> UIColor {
        return currentColor
    }
}

public struct XTagViewOption {
    
    let insets: UIEdgeInsets
    let marginX: CGFloat
    let marginY: CGFloat
    let font: UIFont
    let containerWidth: CGFloat
    let titleColor: UIColor
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
    let labelInsets: UIEdgeInsets
    
    public init(insets: UIEdgeInsets, marginX: CGFloat, marginY: CGFloat, font: UIFont, containerWidth: CGFloat, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat, labelInsets: UIEdgeInsets) {
        self.insets = insets
        self.marginX = marginX
        self.marginY = marginY
        self.font = font
        self.containerWidth = containerWidth
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.labelInsets = labelInsets
    }
}

open class XTagView: UIView {
    
    open var delegate: XTagViewDelegate?
    
    let option: XTagViewOption
    
    public init(option: XTagViewOption) {
        self.option = option
        super.init(frame: .zero)
        
        frame.size = CGSize(width: option.containerWidth, height: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func updateTags(titles: [String]) {
        
        for sv in subviews {
            sv.removeFromSuperview()
        }
        
        let containerWidth = option.containerWidth
        frame.size = CGSize(width: containerWidth, height: 0)
        let marginX = option.marginX
        let marginY = option.marginY
        let font = option.font
        let labelInsets = option.labelInsets
        let insets = option.insets
        let areaWidth = bounds.width - (insets.left + insets.right)
        let height = font.lineHeight + labelInsets.top + labelInsets.bottom
        
        var x: CGFloat = insets.left
        var y: CGFloat = insets.top
        var line = 1
        
        for (index, title) in titles.enumerated() {
            var width = labelTextWidth(text: title, font: font, height: height)
            if width > areaWidth {
                width = areaWidth
            }
            
            if areaWidth - x < width {
                x = insets.left
                y += height + marginY
                line += 1
            }
            
            let label = XTagLabel(
                frame: CGRect(x: x, y: y, width: width, height: height),
                cornerRadius: option.cornerRadius,
                insets: labelInsets
            )
            
            label.text = title
            label.font = font
            label.textColor = option.titleColor
            label.backgroundColor = option.backgroundColor
            
            if let _ = delegate {
                label.backgroundColor = delegate!.backgroundColor(
                    index: index,
                    title: title,
                    currentColor: option.backgroundColor
                )
                label.textColor = delegate!.titleColor(
                    index: index,
                    title: title,
                    currentColor: option.titleColor
                )
            }
            
            addSubview(label)
            
            x += width + marginX
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.selectTag))
            label.addGestureRecognizer(gesture)
        }
        
        
        let frameHeight = CGFloat(line - 1) * marginY + CGFloat(line) * height + insets.top + insets.bottom
        
        frame.size = CGSize(width: containerWidth, height: frameHeight)
    }
    
    func labelTextWidth(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNormalMagnitude, height: height))
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size.width + option.labelInsets.left + option.labelInsets.right
    }
    
    @objc func selectTag(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
        switch sender.state {
        case .ended:
            delegate?.selectTag(sender: label)
        default:
            return
        }
    }
}
