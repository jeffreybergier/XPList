//
//  Created by Jeffrey Bergier on 2021/01/22.
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

extension XPL {
    public struct OpenTrigger: ViewModifier {
        
        public typealias Action = () -> Void
                
        private let action: Action
        @State private var isHighlighted = false
        @Environment(\.XPL_isEditMode) private var isEditMode
        
        public init(action: @escaping Action) {
            self.action = action
        }
        
        public func body(content: Content) -> some View {
            #if os(macOS)
            let tapCount: Int = 2
            #else
            let tapCount: Int = 1
            #endif
            guard self.isEditMode == false else { return AnyView(content) }
            return AnyView(
                content
                    .environment(\.XPL_isHighlighted, self.isHighlighted)
                    .gesture(TapGesture(count: tapCount).onEnded(self._action))
            )
        }
        
        private func _action() {
            self.action()
            self.isHighlighted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.isHighlighted = false
            }
        }
    }
}
