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

extension XPL1 {
    public struct List<Data: RandomAccessCollection,
                       Row: View,
                       Menu: ViewModifier>: View
                 where Data.Element: Identifiable & Hashable
    {
     
        public typealias Selection = Set<Data.Element>
        public typealias OpenAction = (Selection) -> Void
        public typealias MenuBuilder = (Selection) -> Menu
        
        private let data: Data
        private let content: (Data.Element) -> Row
        private let openAction: OpenAction?
        private let menuModifier: MenuBuilder?

        @Binding private var selection: Selection
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.XPL_Configuration) private var config

        public var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(self.data) { item in
                        ZStack(alignment: .bottom) {
                            XPL1.RowBackground()
                            XPL1.RowSeparator()
                            HStack(spacing: self.config.cellPadding.leading) {
                                XPL1.Accessory()
                                self.content(item)
                            }
                            .padding(self.config.cellPadding)
                        }
                        .modifier(ForegroundColor())
                        .modifier(ClickModifier1(open: { self.open(item) },
                                                 singleSelect: { self.singleSelect(item) },
                                                 commandSelect: { self.commandSelect(item) },
                                                 shiftSelect: { self.shiftSelect(item) }))
                        .modifier(If.some(self.menuModifier?(self.menu(item))))
                        .environment(\.XPL_isSelected, self.selection.contains(item))
                    }
                }
            }
            .modifier(OnChange(of: \.XPL_isEditMode, action: { _ in self.selection.removeAll() }))
            .modifier(EditMode())
        }
        
        /// Complex logic for context menu selection
        /// If there is no selection, return the item as the only selection
        /// If there is a selection and the user right-clicked on one of the select items
        /// then return the selection
        /// If there is a selection and the user right-clicked on a non-selected item
        /// only return the item as a selection
        private func menu(_ item: Data.Element) -> Selection {
            guard self.selection.isEmpty == false else { return [item] }
            if self.selection.contains(item) {
                return self.selection
            } else {
                return [item]
            }
        }
        
        /// Complex logic applies to macOS.
        /// If they double click on a row that is selected (and other rows are selected)
        /// then it should open all the selected rows.
        /// If they double click on a row that is not selected but other rows are selected
        /// then the selection is cleared and only the double clicked item is opened
        /// On iOS, only the item that is tapped is opened, no matter the selection
        private func open(_ item: Data.Element) {
            guard let openAction = self.openAction else { return }
            #if os(macOS)
            if self.selection.contains(item) {
                openAction(self.selection)
            } else {
                self.selection = [item]
                openAction([item])
            }
            #else
            openAction([item])
            #endif
        }
        
        public func singleSelect(_ item: Data.Element) {
            #if os(macOS)
            guard self.selection.contains(item) == false else { return }
            self.selection = [item]
            #else
            self.commandSelect(item)
            #endif
        }
        
        public func commandSelect(_ item: Data.Element) {
            if self.selection.contains(item) {
                self.selection.remove(item)
            } else {
                self.selection.insert(item)
            }
        }
        
        public func shiftSelect(_ item: Data.Element) {
            NSLog("Shift Selection Not Implemented")
        }
        
        public init(data: Data,
                    selection: Binding<Selection>? = nil,
                    open: OpenAction? = nil,
                    menu: @escaping MenuBuilder,
                    @ViewBuilder content: @escaping (Data.Element) -> Row)
        {
            #if DEBUG
            if Mirror(reflecting: data).displayStyle == .class {
                NSLog("WARNING: SwiftUI crashes when using a data source that is a class instead of a struct: FB8977767")
            }
            #endif
            self.data = data
            self.content = content
            self.openAction = open
            self.menuModifier = menu
            _selection = selection ?? Binding.constant([])
        }
        
        public init(data: Data,
                    selection: Binding<Selection>? = nil,
                    open: OpenAction? = nil,
                    @ViewBuilder content: @escaping (Data.Element) -> Row) where Menu == Never
        {
            #if DEBUG
            if Mirror(reflecting: data).displayStyle == .class {
                NSLog("WARNING: SwiftUI crashes when using a data source that is a class instead of a struct: FB8977767")
            }
            #endif
            self.data = data
            self.content = content
            self.openAction = open
            self.menuModifier = nil
            _selection = selection ?? Binding.constant([])
        }
    }
}

/*
#if DEBUG
struct Preview_Menu_Open: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static var previews: some View {
        XPL.List(data: data, selection: $selection)
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
        XPL.List(data: data) { item in
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

struct Preview_Custom_Appearance: PreviewProvider {
    static let data = XPL.Collection()
    @State static var selection: Set<XPL.Element> = [data[2], data[4]]
    static let config = XPL.Configuration(cellPadding: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                                          separatorPadding: .init(top: 0, leading: 30, bottom: 0, trailing: 30),
                                          separator: Color.green,
                                          selectedBackground: Color.blue,
                                          deselectedBackground: Color.orange,
                                          selectedForeground: Color.white,
                                          deselectedForeground: Color.black,
                                          accessoryAccent: Color.pink,
                                          selectedAccessory: Image(systemName: "trash.slash.fill"),
                                          deselectedAccessory: Image(systemName: "highlighter"))
    static var previews: some View {
        XPL.List(data: data, selection: self.$selection) { item in
            HStack {
                Text("Item: ")
                Text("\(item.id)")
                Spacer()
                Image(systemName: "dot.arrowtriangles.up.right.down.left.circle")
            }
        }
        .environment(\.XPL_Configuration, self.config)
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
        XPL.List(data: data, selection: $selection) { item in
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
*/
