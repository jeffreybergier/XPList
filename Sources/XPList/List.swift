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
    public struct List<Data: RandomAccessCollection, Row: View, Menu: View>: View
                       where Data.Element: Identifiable & Hashable
    {
     
        public typealias ContextMenu = XPL.ContextMenu<Set<Data.Element>, Menu>
        public typealias OpenAction = (Data.Element) -> Void
        
        private let data: Data
        private let content: (Data.Element) -> Row
        private let openAction: OpenAction?
        private let menuContent: ContextMenu.Builder?
        
        @Binding private var selection: Set<Data.Element>
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.XPL_LightConfiguration) private var lightConfig
        @Environment(\.XPL_DarkConfiguration) private var darkConfig
        private var currentConfig: XPL.Configuration {
            return self.colorScheme.isLight
                ? self.lightConfig
                : self.darkConfig
        }

        public var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(self.data) { item in
                        ZStack(alignment: .bottom) {
                            XPL.RowBackground()
                            XPL.RowSeparator()
                            HStack(spacing: self.currentConfig.insets.leading) {
                                XPL.Accessory()
                                self.content(item)
                            }
                            .padding(self.currentConfig.insets)
                        }
                        .environment(\.XPL_isSelected, self.selection.contains(item))
                        .modifier(XPL.OpenTrigger { self.openAction?(item) })
                        .modifier(XPL.SelectionTrigger(item: item, selection: self.$selection))
                        .modifier(ContextMenu(self.selection.union(Set([item])), self.menuContent))
                    }
                }
            }
            .modifier(XPL.EditMode())
        }
        
        public init(_ data: Data,
                    selection: Binding<Set<Data.Element>>? = nil,
                    openAction: OpenAction? = nil,
                    @ViewBuilder menu: @escaping ContextMenu.Builder,
                    @ViewBuilder content: @escaping (Data.Element) -> Row)
        {
            self.data = data
            self.content = content
            self.openAction = openAction
            self.menuContent = menu
            _selection = selection ?? Binding.constant([])
        }
        
        public init(_ data: Data,
                    selection: Binding<Set<Data.Element>>? = nil,
                    openAction: OpenAction? = nil,
                    @ViewBuilder content: @escaping (Data.Element) -> Row)
                    where Menu == Never
        {
            self.data = data
            self.content = content
            self.openAction = openAction
            self.menuContent = nil
            _selection = selection ?? Binding.constant([])
        }
    }
}

#if DEBUG
struct Preview_Menu_Open: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static var previews: some View {
        XPL.List(data, selection: $selection)
        { open in
            print("Open")
        } menu: { selection in
            Text(String(describing: selection))
            Text("Menu Item 2")
        } content: { item in
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

struct Preview_NoMenu_NoOpen_NoSelection: PreviewProvider {
    static let data = XPL.Collection()
    static var previews: some View {
        XPL.List(data) { item in
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

struct Preview_Custom_Appearance_Light: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static let light = XPL.Configuration(insets: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                                         separator: Color.green,
                                         selectedRowBackground: Color.blue,
                                         deselectedRowBackground: Color.orange,
                                         selectedAccessory: Image(systemName: "trash.slash.fill"),
                                         deselectedAccessory: Image(systemName: "highlighter"))
    static var previews: some View {
        XPL.List(data, selection: self.$selection) { item in
            HStack {
                Text("Item: ")
                Text("\(item.id)")
                Spacer()
                Image(systemName: "dot.arrowtriangles.up.right.down.left.circle")
            }
        }
        .environment(\.XPL_LightConfiguration, self.light)
        .previewLayout(.sizeThatFits)
        .frame(width: 320, height: 200)
    }
}

struct Preview_Custom_Appearance_Dark: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static let dark = XPL.Configuration(insets: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                                         separator: Color.white,
                                         selectedRowBackground: Color.red,
                                         deselectedRowBackground: Color.black,
                                         selectedAccessory: Image(systemName: "highlighter"),
                                         deselectedAccessory: Image(systemName: "trash.slash.fill"))
    static var previews: some View {
        XPL.List(data, selection: self.$selection) { item in
            HStack {
                Text("Item: ")
                Text("\(item.id)")
                Spacer()
                Image(systemName: "dot.arrowtriangles.up.right.down.left.circle")
            }
        }
        .environment(\.XPL_DarkConfiguration, self.dark)
        .previewLayout(.sizeThatFits)
        .frame(width: 320, height: 200)
    }
}

#if os(iOS)
struct Preview_EditMode: PreviewProvider {
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
