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

public struct OrModifier<Y: ViewModifier, N: ViewModifier>: ViewModifier {
    
    private let isTrue: Bool
    private let yes: Y
    private let no: N
    
    public init(_ isTrue: Bool, _ yes: Y, _ no: N) {
        self.isTrue = isTrue
        self.yes = yes
        self.no = no
    }
    
    public func body(content: Content) -> some View {
        if self.isTrue {
            return AnyView(content.modifier(self.yes))
        } else {
            return AnyView(content.modifier(self.no))
        }
    }
}

public struct IfModifier<Y: ViewModifier>: ViewModifier {
    
    static func isMac(_ yes: Y) -> IfModifier {
        #if os(macOS)
        return .init(true, yes)
        #else
        return .init(false, yes)
        #endif
    }
    
    static func isiOS(_ yes: Y) -> IfModifier {
        #if os(iOS)
        return .init(true, yes)
        #else
        return .init(false, yes)
        #endif
    }
    
    private let isTrue: Bool
    private let yes: Y
    
    public init(_ isTrue: Bool, _ yes: Y) {
        self.isTrue = isTrue
        self.yes = yes
    }
    
    public func body(content: Content) -> some View {
        if self.isTrue {
            return AnyView(content.modifier(self.yes))
        } else {
            return AnyView(content)
        }
    }
}
