//
//  Created by Jeffrey Bergier on 2021/01/26.
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

struct Toolbar: ViewModifier {
    @ObservedObject var data: XPL.Collection
    func body(content: Content) -> some View {
        content
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
                #endif
                ToolbarItem(placement: .cancellationAction) {
                    Button("Shrink") {
                        // This causes a crash
                        self.data.shrink()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Grow") {
                        self.data.grow()
                    }
                }
            }
    }
}

struct Open: ViewModifier {
    @Binding var open: Set<XPL.Element>?
    func body(content: Content) -> some View {
        content
            .alert(item: self.$open) { selection in
                Alert(title: Text("\(selection.count) Item(s)"),
                      message: Text(selection.reduce("", { $0 + "\n" + String(describing: $1) })),
                      dismissButton: .cancel())
            }
    }
}
