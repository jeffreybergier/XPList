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

#if canImport(UIKit)
import UIKit
import SwiftUI

internal struct _ClickReceiver: UIViewRepresentable {
    let clickCount: Int
    let modifiers: EventModifiers
    let startAction: ClickReceiver.Action
    let finishAction: ClickReceiver.Action
    typealias UIViewType = __ClickReceiver
    func makeUIView(context: Context) -> __ClickReceiver {
        let view = __ClickReceiver()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func updateUIView(_ view: __ClickReceiver, context: Context) {
        view.clickCount = self.clickCount
        view.modifiers = self.modifiers
        view.startAction = self.startAction
        view.finishAction = self.finishAction
    }
}

internal class __ClickReceiver: UIView {
    var clickCount: Int = -1
    var modifiers: EventModifiers = []
    var startAction: ClickReceiver.Action = {}
    var finishAction: ClickReceiver.Action = {}
    
    override var canBecomeFirstResponder: Bool { return true }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        guard sender.modifierFlags == self.modifiers.nativeValue else {
            sender.state = .cancelled
            return
        }
        switch sender.state {
        case .began:
            // TODO: Fix that began is never called
            self.startAction()
        case .ended:
            self.finishAction()
        default:
            break
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let long = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        if self.clickCount > 1 {
            NSLog("ClickCount higher than 1 not working on iOS for some reason 🤷‍♀️")
        }
        long.numberOfTapsRequired = self.clickCount
        self.addGestureRecognizer(long)
    }
}

extension EventModifiers {
    fileprivate var nativeValue: UIKeyModifierFlags {
        var output: UIKeyModifierFlags = []
        if self.contains(.command) {
            output.insert(.command)
        }
        if self.contains(.control) {
            output.insert(.control)
        }
        if self.contains(.option) {
            output.insert(.alternate)
        }
        if self.contains(.shift) {
            output.insert(.shift)
        }
        if self.contains(.capsLock) {
            output.insert(.alphaShift)
        }
        if self.contains(.numericPad) {
            output.insert(.numericPad)
        }
        return output
    }
}

#endif
