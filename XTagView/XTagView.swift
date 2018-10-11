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
}

public struct XTagViewOption {
    
    let marginX: CGFloat
    let marginY: CGFloat
    let font: UIFont
    let containerWidth: CGFloat
    let titleColor: UIColor
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
    let insets: UIEdgeInsets
    
    public init(marginX: CGFloat, marginY: CGFloat, font: UIFont, containerWidth: CGFloat, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat, insets: UIEdgeInsets) {
        self.marginX = marginX
        self.marginY = marginY
        self.font = font
        self.containerWidth = containerWidth
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.insets = insets
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
        let areaWidth = bounds.width
        let marginX = option.marginX
        let marginY = option.marginY
        let font = option.font
        let insets = option.insets
        let height = font.lineHeight + insets.top + insets.bottom
        
        var x: CGFloat = marginX
        var y: CGFloat = marginY
        var line = 1
        
        for title in titles {
            var width = labelTextWidth(text: title, font: font, height: height)
            if width > areaWidth {
                width = areaWidth
            }
            
            if areaWidth - x < width {
                x = marginX
                y += height + marginY
                line += 1
            }
            
            let label = XTagLabel(
                frame: CGRect(x: x, y: y, width: width, height: height),
                cornerRadius: option.cornerRadius,
                insets: insets
            )
//            label.delegate = self
            
            label.text = title
            label.font = font
            label.textColor = option.titleColor
            label.backgroundColor = option.backgroundColor
            addSubview(label)
            
            x += width + marginX
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.selectTag))
            label.addGestureRecognizer(gesture)
        }
        
        frame.size = CGSize(
            width: containerWidth,
            height: CGFloat(line + 1) * marginY + CGFloat(line) * height
        )
    }
    
    func labelTextWidth(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNormalMagnitude, height: height))
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size.width + option.insets.left + option.insets.right
    }
    
    @objc func selectTag(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let label = sender.view as? UILabel {
                delegate?.selectTag(sender: label)
            }
        }
    }
}
