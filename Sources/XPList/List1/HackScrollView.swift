//
//  Created by Jeffrey Bergier on 2021/02/13.
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

/// Fixes an issue where ScrollView doesn't scroll properly
/// when its embedded in a NavigationView with large title.
/// Also, this bug causes the large title to flicker.
/// This works by following the solution here
/// https://stackoverflow.com/a/65218077
internal struct __hack_ScrollView<Content: View>: View {
    
    internal typealias ContentBuilder = () -> Content
    private let contentBuilder: ContentBuilder
    
    internal var body: some View{
        GeometryReader { geo in
            ScrollView {
                self.contentBuilder()
                    .padding(self.insets(geo))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    /// - Parameter builder: Content should probably be `LazyVStack { ForEach { ... } }`
    internal init(@ViewBuilder _ builder: @escaping ContentBuilder) {
        self.contentBuilder = builder
    }
    
    private func insets(_ geo: GeometryProxy) -> EdgeInsets {
        .init(top: geo.safeAreaInsets.top,
              leading: geo.safeAreaInsets.leading,
              bottom: geo.safeAreaInsets.bottom,
              trailing: geo.safeAreaInsets.trailing)
    }
    
}
