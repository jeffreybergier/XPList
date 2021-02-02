//
//  Created by Jeffrey Bergier on 2021/02/02.
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

public struct ClickModifier: ViewModifier {
    
    public typealias Action = () -> Void
    
    @State private var isHighlighted = false
    @Environment(\.XPL_isEditMode) private var isEditMode
    
    private let open: Action
    private let singleSelect: Action
    private let commandSelect: Action
    private let shiftSelect: Action
    
    public init(open: @escaping Action,
                singleSelect: @escaping Action,
                commandSelect: @escaping Action,
                shiftSelect: @escaping Action)
    {
        self.open = open
        self.singleSelect = singleSelect
        self.commandSelect = commandSelect
        self.shiftSelect = shiftSelect
    }
    
    public func body(content: Content) -> some View {
        content
            .environment(\.XPL_isHighlighted, self.isHighlighted)
            .modifier(IfMac(ClickReceiver(clickCount: 1, modifiers: [.command], finish: self.commandSelect)))
            .modifier(IfMac(ClickReceiver(clickCount: 2, finish: self.open)))
            .modifier(IfMac(ClickReceiver(clickCount: 1, finish: self.singleSelect)))
            .modifier(IfMac(ClickReceiver(clickCount: 1, modifiers: [.shift], finish: self.shiftSelect)))
            .modifier(IfiOS(and: self.isEditMode,
                            ClickReceiver(clickCount: 1, finish: self.commandSelect),
                            ClickReceiver(clickCount: 1, start: self.highlight, finish: self.open)))
    }
    
    private func highlight() {
        self.isHighlighted = true
    }
}
