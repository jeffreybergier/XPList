//
//  Created by Jeffrey Bergier on 2021/01/22.
//
//  Copyright © 2020 Saturday Apps.
//
//  This file is part of XPList.
//
//  Hipstapaper is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Hipstapaper is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Hipstapaper.  If not, see <http://www.gnu.org/licenses/>.
//

import SwiftUI

extension XPL {
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
}
