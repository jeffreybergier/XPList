//
//  CrappList.swift
//  Boom
//
//  Created by Jeffrey Bergier on 2021/01/22.
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
