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

public struct CrappyList<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable & Hashable {
    
    private let data: Data
    private let content: (Data.Element) -> RowContent
    @Binding private var selection: Set<Data.Element>
    @Environment(\.editMode) private var editMode

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(self.data) { item in
                    ZStack {
                        RowBackground()
                        VStack {
                            HStack {
                                if self.editMode?.wrappedValue.isEditing == true {
                                    SelectionCircle()
                                }
                                self.content(item)
                            }
                            Rectangle()
                                .foregroundColor(Color.gray)
                                .frame(maxHeight: 1)
                        }
                    }
                    .environment(\.isSelected, self.selection.contains(item))
                    .onTapGesture {
                        guard self.selection.remove(item) == nil else { return }
                        self.selection.insert(item)
                    }
                }
            }
        }
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

fileprivate struct SelectedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isSelected: Bool {
        get { self[SelectedKey.self] }
        set { self[SelectedKey.self] = newValue }
    }
}

fileprivate struct RowBackground: View {
    @Environment(\.isSelected) var isSelected
    var body: Color {
        if self.isSelected {
            return Color.blue
        } else {
            return Color.red
        }
    }
}

fileprivate struct SelectionCircle: View {
    @Environment(\.isSelected) var isSelected
    var body: Image {
        if self.isSelected {
            return Image(systemName: "circle.fill")
        } else {
            return Image(systemName: "circle")
        }
    }
}

#if DEBUG
struct List_Preview_1: PreviewProvider {
    static let data = XPLCollection()
    @State static var selection: Set<XPLElement> = [data[2], data[4]]
    static var previews: some View {
        CrappyList(data, selection: $selection) { item in
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
#endif
