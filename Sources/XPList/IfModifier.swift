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

public struct If<Y: ViewModifier, N: ViewModifier>: ViewModifier {
    
    private let isTrue: Bool
    private let yes: () -> Y
    private let no: () -> N
    
    public init(_ isTrue: Bool, _ yes: @escaping @autoclosure () -> Y, _ no: @escaping @autoclosure () -> N) {
        self.isTrue = isTrue
        self.yes = yes
        self.no = no
    }
    
    public func body(content: Content) -> some View {
        if self.isTrue {
            guard Y.self != Never.self else { return AnyView(content) }
            return AnyView(content.modifier(self.yes()))
        } else {
            guard N.self != Never.self else { return AnyView(content) }
            return AnyView(content.modifier(self.no()))
        }
    }
}

public func IfMac<Y: ViewModifier, N: ViewModifier>(and isTrue: Bool, _ y: Y, _ n: N) -> If<Y, N> {
    #if os(macOS)
    return If(isTrue, y, n)
    #else
    return If(false, y, n)
    #endif
}

public func IfMac<Y: ViewModifier>(_ y: Y) -> If<Y, Never> {
    #if os(macOS)
    return If(true, y, fatalError())
    #else
    return If(false, y, fatalError())
    #endif
}

public func IfiOS<Y: ViewModifier, N: ViewModifier>(and isTrue: Bool, _ y: Y, _ n: N) -> If<Y, N> {
    #if os(iOS)
    return If(isTrue, y, n)
    #else
    return If(false, y, n)
    #endif
}

public func IfiOS<Y: ViewModifier>(_ y: Y) -> If<Y, Never> {
    #if os(iOS)
    return If(true, y, { () -> Never in fatalError() }())
    #else
    return If(false, y, { () -> Never in fatalError() }())
    #endif
}

extension Never: ViewModifier {}
