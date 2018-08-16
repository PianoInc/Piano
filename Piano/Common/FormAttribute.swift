//
//  FormAttribute.swift
//  Block
//
//  Created by Kevin Kim on 2018. 8. 8..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreGraphics

struct FormAttribute {
    
    public static var effectColor: Color = Color.red
    public static var textColor: Color = Color.darkText
    public static var punctuationColor: Color = Color.lightGray
    
    public static var defaultFont = Font.preferredFont(forTextStyle: .body)
    public static var numFont = Font(name: "Avenir Next", size: Font.preferredFont(forTextStyle: .body).pointSize)!
    
    public static var spaceKern: CGFloat = 10
    
    public static var unorderedKey = "*"
    public static var unorderedValue = "😀"
    
    public static var checklistKey = "-"
    public static var checklistOnValue = "👍"
    public static var checklistOffValue = "👎"
}
