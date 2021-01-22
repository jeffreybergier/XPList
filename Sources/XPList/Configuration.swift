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
        public var insets: EdgeInsets
        public var separator: Color
        public var selectedRowBackground: Color
        public var deselectedRowBackground: Color
        public var selectedAccessory: Image
        public var deselectedAccessory: Image
        
        public init(insets: EdgeInsets,
                    separator: Color,
                    selectedRowBackground: Color,
                    deselectedRowBackground: Color,
                    selectedAccessory: Image,
                    deselectedAccessory: Image)
        {
            self.insets = insets
            self.separator = separator
            self.selectedRowBackground = selectedRowBackground
            self.deselectedRowBackground = deselectedRowBackground
            self.selectedAccessory = selectedAccessory
            self.deselectedAccessory = deselectedAccessory
        }
        
        private static let defaultInsets = EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        private static let defaultSelectedAccessory = Image(systemName: "largecircle.fill.circle")
        private static let defaultDeselectedAccessory = Image(systemName: "circle")
        
        #if os(macOS)
        public static let `default`: Configuration = {
            .init(insets: defaultInsets,
                  separator: Color(NSColor.separatorColor),
                  selectedRowBackground: Color(NSColor.selectedContentBackgroundColor),
                  deselectedRowBackground: Color(NSColor.controlBackgroundColor),
                  selectedAccessory: defaultSelectedAccessory,
                  deselectedAccessory: defaultDeselectedAccessory)
        }()
        #else
        public static let `default`: Configuration = {
            .init(insets: defaultInsets,
                  separator: Color(UIColor.separator),
                  selectedRowBackground: Color(UIColor.tertiarySystemFill),
                  deselectedRowBackground: Color(UIColor.systemBackground),
                  selectedAccessory: defaultSelectedAccessory,
                  deselectedAccessory: defaultDeselectedAccessory)
        }()
        #endif
    }
}
