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
import SwiftUI
import UIKit
import UIKit.UIGestureRecognizerSubclass

internal struct _ClickReceiver: UIViewRepresentable {
    let clickCount: Int
    let modifiers: EventModifiers
    let startAction: ClickReceiver.Action
    let finishAction: ClickReceiver.Action
    typealias UIViewType = UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(context.coordinator)
        return view
    }
    func updateUIView(_ view: UIView, context: Context) {
        let gr = context.coordinator
        gr.clickCount = self.clickCount
        gr.modifiers = self.modifiers
        gr.startAction = self.startAction
        gr.finishAction = self.finishAction
    }
    func makeCoordinator() -> HighlightTapGestureRecognizer {
        return HighlightTapGestureRecognizer()
    }
}

internal class HighlightTapGestureRecognizer: UIGestureRecognizer {
    internal var clickCount: Int = -1
    internal var modifiers: EventModifiers = []
    internal var startAction: ClickReceiver.Action = {}
    internal var finishAction: ClickReceiver.Action = {}
    
    override var state: UIGestureRecognizer.State {
        didSet {
            switch self.state {
            case .began:
                self.startAction()
            case .ended:
                self.finishAction()
            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard
            event.modifierFlags == self.modifiers.nativeValue,
            touches.first!.tapCount <= self.clickCount
        else {
            self.state = .failed
            return
        }
        guard touches.first!.tapCount == self.clickCount else { return }
        self.state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        guard
            event.modifierFlags == self.modifiers.nativeValue,
            touches.first!.tapCount == self.clickCount
        else {
            self.state = .failed
            return
        }
        self.state = .ended
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .failed
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
    
    override func shouldRequireFailure(of otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // make sure scrolling continues to work when using this gesture recognizer
        return otherGestureRecognizer is UIPanGestureRecognizer
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
        if self.contains(.function) {
            NSLog("EventModifiers.function not available on iOS")
        }
        if self.contains(.numericPad) {
            output.insert(.numericPad)
        }
        return output
    }
}

#endif
