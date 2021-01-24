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
    public struct RowBackground: View {
        
        @Environment(\.XPL_isSelected) private var isSelected
        @Environment(\.XPL_isHighlighted) private var isHighlighted
        @Environment(\.XPL_isEditMode) private var isEditMode
        @Environment(\.XPL_Configuration) private var config
        
        public var body: some View {
            let `default` = self.config.deselectedBackground.animation(.linear(duration: 0.1))
            let modified = self.config.selectedBackground.animation(nil)
            if self.isHighlighted {
                return modified
            }
            #if os(iOS)
            guard self.isEditMode else { return `default` }
            #endif
            if self.isSelected {
                return modified
            }
            return `default`
        }
    }
}
