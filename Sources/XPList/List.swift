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
    public struct List<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable & Hashable {
        
        private let data: Data
        private let content: (Data.Element) -> RowContent
        
        @Binding private var selection: Set<Data.Element>

        public var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(self.data) { item in
                        ZStack {
                            XPL.RowBackground()
                            VStack {
                                HStack {
                                    XPL.SelectionCircle()
                                    self.content(item)
                                }
                                XPL.RowSeparator()
                            }
                        }
                        .environment(\.XPL_isSelected, self.selection.contains(item))
                        .onTapGesture {
                            guard self.selection.remove(item) == nil else { return }
                            self.selection.insert(item)
                        }
                    }
                }
            }
            .modifier(XPL.EditMode())
        }
        
        init(_ data: Data,
             selection: Binding<Set<Data.Element>>,
             @ViewBuilder content: @escaping (Data.Element) -> RowContent)
        {
            self.data = data
            self.content = content
            _selection = selection
        }
    }
}

#if DEBUG
struct List_Preview_1: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static var previews: some View {
        XPL.List(data, selection: $selection) { item in
            HStack {
                Text("Item: ")
                Text("\(item.id)")
                Spacer()
                Image(systemName: "dot.arrowtriangles.up.right.down.left.circle")
            }
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 320, height: 200)
    }
}

#if os(iOS)
struct List_Preview_2: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    @State static var editMode = EditMode.active
    static var previews: some View {
        XPL.List(data, selection: $selection) { item in
            HStack {
                Text("Item: ")
                Text("\(item.id)")
                Spacer()
                Image(systemName: "dot.arrowtriangles.up.right.down.left.circle")
            }
        }
        .environment(\.editMode, $editMode)
        .previewLayout(.sizeThatFits)
        .frame(width: 320, height: 200)
    }
}
#endif
#endif
