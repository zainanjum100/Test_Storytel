//
//  ScrollViewExtensions.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 13/06/2021.
//

import UIKit
extension UIScrollView{
    func isEnded() -> Bool {
        return ((self.contentOffset.y + self.frame.size.height) > self.contentSize.height)
    }
}
