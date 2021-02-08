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

struct XPLList<C: RandomAccessCollection & Growable>: View where C.Element: Hashable & Identifiable {
    
    let title: String
    @StateObject var data: Observer<C>
    @State private var selection: Set<C.Element> = []
    
    init(_ title: String, _ collection: C) {
        self.title = title
        _data = .init(wrappedValue: Observer(collection))
    }
        
    var body: some View {
        XPL1.List(data: self.data.data,
                 selection: self.$selection,
                 open: { self.open = $0 },
                 menu: { self.menu($0) })
        { item in
            HStack {
                Text(String(describing: item))
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
            .frame(minHeight: 44)
        }
        .onAppear { self.data.load() }
        .navigationTitle(self.title)
        .modifier(Toolbar2(shrink: self.data.shrink, grow: self.data.grow))
        .modifier(Open(open: self.$open))
    }
    
    /// MARK: Open and Menu
    @State private var open: Set<C.Element>?
    @ViewBuilder private func menu(_ items: Set<C.Element>) -> some View {
        Text("\(items.count) item(s)")
        ForEach(Array(items)) {
            Text(String(describing: $0))
        }
    }
}
