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
    public struct OpenTrigger: ViewModifier {
        
        public typealias Action = () -> Void
                
        private let action: Action
        @Environment(\.XPL_isEditMode) private var isEditMode
        
        public init(action: @escaping Action) {
            self.action = action
        }
        
        public func body(content: Content) -> AnyView {
            #if os(macOS)
            let tapCount: Int = 2
            #else
            let tapCount: Int = 1
            #endif
            guard self.isEditMode == false else { return AnyView(content) }
            return AnyView(
                content
                    .onTapGesture(count: tapCount, perform: self.action)
            )
        }
    }
}
