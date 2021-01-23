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
    public struct SelectionTrigger<Element: Hashable>: ViewModifier {
        
        private let item: Element
        @Binding private var selection: Set<Element>
        @Environment(\.XPL_isEditMode) private var isEditMode
                
        public init(item: Element, selection: Binding<Set<Element>>) {
            _selection = selection
            self.item = item
        }
        public func body(content: Content) -> AnyView {
            #if os(iOS)
            guard self.isEditMode else { return AnyView(content) }
            return AnyView(
                content
                    .gesture(TapGesture(count: 1).onEnded
                    {
                        guard self.selection.remove(self.item) == nil else { return }
                        self.selection.insert(self.item)
                    })
            )
            #else
            return AnyView(
                content
                    .gesture(
                        TapGesture(count: 1).modifiers(.shift).onEnded
                        { _ in
                            guard self.selection.remove(self.item) == nil else { return }
                            self.selection.insert(self.item)
                        }
                        .exclusively(before: TapGesture(count: 1).onEnded
                        { _ in
                            self.selection.removeAll()
                            self.selection.insert(self.item)
                        })
                    )
            )
            #endif
        }
    }
}
