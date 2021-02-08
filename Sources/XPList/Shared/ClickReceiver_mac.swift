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


#if canImport(AppKit)
import AppKit
import SwiftUI

internal struct _ClickReceiver: NSViewRepresentable {
    let clickCount: Int
    let modifiers: EventModifiers
    let startAction: ClickReceiver.Action
    let finishAction: ClickReceiver.Action
    func makeNSView(context: Context) -> __ClickReceiver {
        let view = __ClickReceiver()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func updateNSView(_ view: __ClickReceiver, context: Context) {
        view.clickCount = self.clickCount
        view.modifiers = self.modifiers
        view.startAction = self.startAction
        view.finishAction = self.finishAction
    }
}

internal class __ClickReceiver: NSView {
    var clickCount: Int = -1
    var modifiers: EventModifiers = []
    var startAction: ClickReceiver.Action = {}
    var finishAction: ClickReceiver.Action = {}
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func mouseDown(with event: NSEvent) {
        // If the event can't possibly ever meet our criteria, call super
        guard
            event.clickCount == self.clickCount,
            event.modifierFlags.intersection(.deviceIndependentFlagsMask) == self.modifiers.nativeValue
        else {
            super.mouseDown(with: event)
            return
        }
        self.startAction()
    }
    override func mouseUp(with event: NSEvent) {
        // If the event doesn't exactly matches our criteria, call super
        guard
            event.clickCount == self.clickCount,
            event.modifierFlags.intersection(.deviceIndependentFlagsMask) == self.modifiers.nativeValue
        else {
            super.mouseUp(with: event)
            return
        }
        self.finishAction()
    }
}

extension EventModifiers {
    fileprivate var nativeValue: NSEvent.ModifierFlags {
        var output: NSEvent.ModifierFlags = []
        if self.contains(.command) {
            output.insert(.command)
        }
        if self.contains(.control) {
            output.insert(.control)
        }
        if self.contains(.option) {
            output.insert(.option)
        }
        if self.contains(.shift) {
            output.insert(.shift)
        }
        if self.contains(.capsLock) {
            output.insert(.capsLock)
        }
        if self.contains(.function) {
            output.insert(.function)
        }
        if self.contains(.numericPad) {
            output.insert(.numericPad)
        }
        return output
    }
}
#endif
