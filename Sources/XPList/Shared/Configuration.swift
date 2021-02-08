//
//  Created by Jeffrey Bergier on 2021/01/22.
//
//  MIT License
//
//  Copyright (c) 2021 Jeffrey Bergier
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

public struct Configuration {
    public var cellPadding: EdgeInsets
    public var separatorPadding: EdgeInsets
    public var separator: Color
    public var selectedBackground: Color
    public var deselectedBackground: Color
    public var selectedForeground: Color
    public var deselectedForeground: Color
    /// Accessory not shown on macOS
    public var accessoryAccent: Color
    /// Accessory not shown on macOS
    public var selectedAccessory: Image
    /// Accessory not shown on macOS
    public var deselectedAccessory: Image
    
    /// To fully customize use this initializer.
    /// To partially customize start with `.default` and modify
    /// Install in XPL.List by using `.environment(\.XPL_Configuration, myConfig)`
    /// Dark and Light mode work automatically if using Dynamic Colors UI/NSColor
    public init(cellPadding: EdgeInsets,
                separatorPadding: EdgeInsets,
                separator: Color,
                selectedBackground: Color,
                deselectedBackground: Color,
                selectedForeground: Color,
                deselectedForeground: Color,
                accessoryAccent: Color,
                selectedAccessory: Image,
                deselectedAccessory: Image)
    {
        self.cellPadding = cellPadding
        self.separatorPadding = separatorPadding
        self.separator = separator
        self.selectedBackground = selectedBackground
        self.deselectedBackground = deselectedBackground
        self.selectedForeground = selectedForeground
        self.deselectedForeground = deselectedForeground
        self.accessoryAccent = accessoryAccent
        self.selectedAccessory = selectedAccessory
        self.deselectedAccessory = deselectedAccessory
    }
    
    private static let defaultPadding = EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 8)
    private static let defaultSelectedAccessory = Image(systemName: "largecircle.fill.circle")
    private static let defaultDeselectedAccessory = Image(systemName: "circle")
    
    #if os(macOS)
    public static let `default`: Configuration = {
        .init(cellPadding: defaultPadding,
              separatorPadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
              separator: Color(NSColor.separatorColor),
              selectedBackground: Color(NSColor.selectedContentBackgroundColor),
              deselectedBackground: Color(NSColor.controlBackgroundColor),
              selectedForeground: Color(NSColor.alternateSelectedControlTextColor),
              deselectedForeground: Color(NSColor.controlTextColor),
              accessoryAccent: Color(NSColor.controlAccentColor),
              selectedAccessory: defaultSelectedAccessory,
              deselectedAccessory: defaultDeselectedAccessory)
    }()
    #else
    public static let `default`: Configuration = {
        .init(cellPadding: defaultPadding,
              separatorPadding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0),
              separator: Color(UIColor.separator),
              selectedBackground: Color(UIColor.tertiarySystemFill),
              deselectedBackground: Color(UIColor.systemBackground),
              selectedForeground: Color(UIColor.label),
              deselectedForeground: Color(UIColor.label),
              accessoryAccent: Color.accentColor,
              selectedAccessory: defaultSelectedAccessory,
              deselectedAccessory: defaultDeselectedAccessory)
    }()
    #endif
}
