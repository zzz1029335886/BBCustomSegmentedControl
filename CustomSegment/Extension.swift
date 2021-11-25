//
//  Extension.swift
//  CustomSegment
//
//  Created by summer on 2021/11/25.
//

import UIKit

extension Array where Element: UIView {
    
    mutating func createOrRemove(_ count: Int, inView: UIView){
        if count < self.count{
            for index in count..<self.count {
                self[index].removeFromSuperview()
            }
            self = Array(self[0..<count])
        }else{
            var array = self
            for _ in self.count..<count {
                let view = Element.init()
                inView.addSubview(view)
                array.append(view)
            }
            self = array
        }
    }
}
