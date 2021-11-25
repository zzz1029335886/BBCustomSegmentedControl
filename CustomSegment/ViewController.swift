//
//  ViewController.swift
//  CustomSegment
//
//  Created by summer on 2021/11/25.
//

import UIKit

func rgba(_ r: CGFloat,
          _ g: CGFloat,
          _ b: CGFloat,
          _ alpha: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: alpha)
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let count = 1
        for index in count..<count + 1{
            print(index)
        }
        
        // Do any additional setup after loading the view.
        let control = BBCustomSegmentedControl.init(frame: .init(x: 20, y: 100, width: self.view.frame.width - 40, height: 40))
        self.view.addSubview(control)
        let segmentedControl = control
        let color = rgba(255, 166, 77, 1)
        let title0: ASAttributedString = "\("2月榜单")\n\("本月截至今日排名")"
        let title1: ASAttributedString = "\("1月榜单")\n\("查看上月邀请先锋")"
        
        segmentedControl.insertSegment(withTitle: title0.value, at: 0)
        segmentedControl.insertSegment(withTitle: title1.value, at: 1)
        
        segmentedControl.set(string: NSAttributedString.init(string: title0.value.string, attributes: [.foregroundColor: UIColor.white]), forState: .selected, index: 0)
        segmentedControl.set(string: NSAttributedString.init(string: title0.value.string, attributes: [.foregroundColor: UIColor.red]), forState: .normal, index: 0)

        segmentedControl.set(string: NSAttributedString.init(string: title0.value.string, attributes: [.foregroundColor: UIColor.white]), forState: .selected, index: 1)
        segmentedControl.set(string: NSAttributedString.init(string: title0.value.string, attributes: [.foregroundColor: UIColor.red]), forState: .normal, index: 1)

        segmentedControl.set(backgroundColor: .gray, forState: .normal)
        segmentedControl.set(backgroundColor: color, forState: .selected)
//
//        segmentedControl.set(titleColor: .white, forState: .selected)
//        segmentedControl.set(titleColor: color, forState: .normal)
    }
}
