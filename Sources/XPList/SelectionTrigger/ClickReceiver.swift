//
//  Created by Jeffrey Bergier on 2021/02/01.
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

internal struct ClickReceiver: ViewModifier {
    public typealias Action = () -> Void
    private let clickCount: Int
    private let modifiers: EventModifiers
    private let startAction: Action
    private let finishAction: Action
    
    /// Responds to clicks/taps with modifier keys
    /// - Parameters:
    ///   - clickCount: number of clicks required to fire
    ///   - modifiers: keyboard modifiers that need to be held down to fire
    ///   - start: ocurs on mouseDown. Use for highlighting
    ///   - finish: occurs on mouseUp. Use for triggering main action
    internal init(clickCount: Int = 2,
                  modifiers: EventModifiers = [],
                  start: @escaping Action = {},
                  finish: @escaping Action = {})
    {
        self.clickCount = clickCount
        self.modifiers = modifiers
        self.startAction = start
        self.finishAction = finish
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            _ClickReceiver(clickCount: self.clickCount,
                           modifiers: self.modifiers,
                           startAction: self.startAction,
                           finishAction: self.finishAction)
        }
    }
}
