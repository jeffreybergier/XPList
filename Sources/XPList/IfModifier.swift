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

internal enum Either<A, B> {
    case a(A), b(B)
}

internal struct If<A: ViewModifier, B: ViewModifier>: ViewModifier {
    private let value: Either<A, B>?
    internal init(_ value: Either<A, B>?) {
        self.value = value
    }
    internal init(_ isTrue: Bool, _ yes: A, _ no: B) {
        self.value = isTrue ? .a(yes) : .b(no)
    }
    internal func body(content: Content) -> some View {
        guard let value = self.value else { return AnyView(content) }
        switch value {
        case .a(let a):
            return AnyView(content.modifier(a))
        case .b(let b):
            return AnyView(content.modifier(b))
        }
    }
}

extension If {
    internal static func mac(and isTrue: Bool, _ yes: A, _ no: B) -> If<A, B> {
        #if os(macOS)
        return If(isTrue, yes, no)
        #else
        return If(nil)
        #endif
    }
    internal static func mac(_ yes: A) -> If<A, B> where B == Never {
        #if os(macOS)
        return If(.a(yes))
        #else
        return If(nil)
        #endif
    }
    internal static func iOS(and isTrue: Bool, _ yes: A, _ no: B) -> If<A, B> {
        #if os(iOS)
        return If(isTrue, yes, no)
        #else
        return If(nil)
        #endif
    }
    internal static func iOS(_ yes: A) -> If<A, B> {
        #if os(iOS)
        return If(.a(yes))
        #else
        return If(nil)
        #endif
    }
}

extension Never: ViewModifier {}
