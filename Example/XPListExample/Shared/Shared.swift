//
//  Created by Jeffrey Bergier on 2021/01/26.
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
