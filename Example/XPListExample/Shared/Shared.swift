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

struct Toolbar2: ViewModifier {
    let shrink: () -> Void
    let grow: () -> Void
    func body(content: Content) -> some View {
        content
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
                #endif
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: self.shrink, label: { Text("🐞 Shrink") })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: self.grow, label: { Text("Grow") })
                }
            }
    }
}

struct Open<Element: Identifiable & Hashable>: ViewModifier {
    @Binding var open: Set<Element>?
    func body(content: Content) -> some View {
        content
            .alert(item: self.$open) { selection in
                Alert(title: Text("\(selection.count) Item(s)"),
                      message: Text(selection.reduce("", { $0 + "\n" + String(describing: $1) })),
                      dismissButton: .cancel())
            }
    }
}

// Crappy example. Do not do this in real code
extension Set: Identifiable where Element: Identifiable {
    public var id: Element.ID {
        return self.first!.id
    }
}

protocol Growable {
    mutating func grow()
    mutating func shrink()
    mutating func load()
}

struct Item: Identifiable, Hashable {
    var id: Int
    init(_ id: Int) {
        self.id = id
    }
}

class Observer<Collection: RandomAccessCollection & Growable>: ObservableObject, Growable {
    
    private(set) var data: Collection
    
    init(_ collection: Collection) {
        self.data = collection
    }
    
    func grow() {
        self.objectWillChange.send()
        self.data.grow()
    }
    
    func shrink() {
        self.objectWillChange.send()
        self.data.shrink()
    }
    
    func load() {
        self.objectWillChange.send()
        self.data.load()
    }
}

class ReferenceCollection: RandomAccessCollection {
    
    typealias Index = Int
    typealias Element = Item
    
    var startIndex: Index = 0
    var endIndex: Index = 0
    
    subscript(position: Index) -> Element {
        guard position < self.endIndex else { fatalError("Index Out of Bounds") }
        return Item(position)
    }
}

struct ValueCollection: RandomAccessCollection {
    
    typealias Index = Int
    typealias Element = Item
    
    var startIndex: Index = 0
    var endIndex: Index = 0
    
    subscript(position: Index) -> Element {
        guard position < self.endIndex else { fatalError("Index Out of Bounds") }
        return Item(position)
    }
}

extension ReferenceCollection: Growable {
    func grow() {
        self.endIndex += 1
    }
    func shrink() {
        guard self.startIndex < self.endIndex else { return }
        self.endIndex -= 1
    }
    func load() {
        self.endIndex = 10
    }
}

extension ValueCollection: Growable {    
    mutating func grow() {
        self.endIndex += 1
    }
    mutating func shrink() {
        guard self.startIndex < self.endIndex else { return }
        self.endIndex -= 1
    }
    mutating func load() {
        self.endIndex = 10
    }
}
