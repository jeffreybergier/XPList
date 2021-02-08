//
//  Created by Jeffrey Bergier on 2021/01/31.
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

#if canImport(AppKit)
import AppKit

extension XPL2 {
    /// Double click to create action
    struct OpenTrigger: ViewModifier {
        typealias Action = () -> Void
        let open: Action
        func body(content: Content) -> some View {
            ZStack {
                content
                _ClickReceiver_old(action: self.open)
            }
        }
    }
}

fileprivate struct _ClickReceiver_old: NSViewRepresentable {
    let count: Int = 2
    let action: XPL2.OpenTrigger.Action
    typealias NSViewType = __ClickReceiver_old
    func makeNSView(context: Context) -> __ClickReceiver_old {
        let view = __ClickReceiver_old()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func updateNSView(_ view: __ClickReceiver_old, context: Context) {
        view.count = self.count
        view.action = self.action
    }
}

fileprivate class __ClickReceiver_old: NSView {
    var count: Int = -1
    var action: XPL2.OpenTrigger.Action?
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event) // always pass the event down the chain
        guard event.modifierFlags.isEmpty else { return }
        guard event.clickCount == self.count else { return }
        self.action?()
    }
}

#else
extension XPL2 {
    /// Single tap when not in edit mode to create action
    struct OpenTrigger: ViewModifier {
        typealias Action = () -> Void
        let open: Action
        @Environment(\.XPL_isEditMode) private var isEditMode
        public func body(content: Content) -> some View {
            guard self.isEditMode == false else { return AnyView(content) }
            return AnyView(Button(action: self.open) { content })
        }
    }
}
#endif
