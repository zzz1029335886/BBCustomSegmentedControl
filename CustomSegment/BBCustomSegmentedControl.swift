//
//  BBCustomSegmentedControl.swift
//  BrainBank
//
//  Created by summer on 2021/11/25.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

protocol BBCustomSegmentedControlDelegate: AnyObject {
    func customSegmentedControl(_ control: BBCustomSegmentedControl, selected index: Int)
}

class BBCustomSegmentedControl: UIView {
    weak var delegate: BBCustomSegmentedControlDelegate?
    class Button: UIButton {
        override var isHighlighted: Bool{
            set{}get{return false}
        }
    }
    
    func colorToImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func insertSegment(withTitle title: String, at segment: Int) {
        self.titles.insert((title, nil), at: segment)
        setSubViews()
    }
    
    func insertSegment(withTitle string: NSAttributedString, at segment: Int) {
        self.titles.insert((nil, string), at: segment)
        setSubViews()
    }
    
    func set(string: NSAttributedString, forState state: UIControl.State, index: Int) {
        buttons[index].setAttributedTitle(string, for: state)
    }
    
    func set(backgroundColor: UIColor, forState state: UIControl.State) {
        let backgroundImage = colorToImage(color: backgroundColor)
        for button in buttons {
            button.setBackgroundImage(backgroundImage, for: state)
        }
    }
    
    func set(backgroundColor: UIColor, forState state: UIControl.State, index: Int) {
        let backgroundImage = colorToImage(color: backgroundColor)
        buttons[index].setBackgroundImage(backgroundImage, for: state)
    }
    
    func set(titleColor: UIColor, forState state: UIControl.State) {
        for button in buttons {
            if let string = button.attributedTitle(for: state) {
                let mutStr = NSMutableAttributedString.init(attributedString: string)
                mutStr.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: .init(location: 0, length: mutStr.length))
                button.setAttributedTitle(mutStr, for: state)
            }
            button.setTitleColor(titleColor, for: state)
        }
    }
    
    func set(titleColor: UIColor, forState state: UIControl.State, index: Int) {
        buttons[index].setTitleColor(titleColor, for: state)
    }
    
    var titles: [(String?, NSAttributedString?)] = []
    
    var buttons: [Button] = []
    var selectedIndex = 0{
        didSet{
            buttonClick(buttons[selectedIndex])
        }
    }
    
    func setSubViews() {
        buttons.createOrRemove(titles.count, inView: self)
        
        var index = 0

        titles.forEach {
            (title, string) in
            let button = buttons[index]
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            
            if let title = title{
                button.setTitle(title, for: .normal)
            }else if let string = string{
                button.setAttributedTitle(string, for: .normal)
            }
            if index == selectedIndex {
                button.isSelected = true
            }
            
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            button.tag = index
            index += 1
        }
        
    }
    
    @objc
    func buttonClick(_ button: UIButton){
        if button.tag == selectedIndex {
            return
        }
        let selectedButton = buttons[selectedIndex]
        selectedButton.isSelected = false
        button.isSelected = true
        selectedIndex = button.tag
        self.delegate?.customSegmentedControl(self, selected: selectedIndex)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width / CGFloat(buttons.count)
        let height = self.frame.height
        
        for button in buttons {
            let x = CGFloat(button.tag) * width
            button.frame = .init(x: x, y: 0, width: width, height: height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgview = self
        bgview.layer.borderWidth = 1
        bgview.layer.borderColor = UIColor.brown.cgColor
        bgview.layer.masksToBounds = true
        bgview.layer.cornerRadius = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
