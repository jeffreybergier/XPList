//
//  Created by Jeffrey Bergier on 2021/01/31.
//
//  Copyright © 2020 Saturday Apps.
//
//  This file is part of XPList.
//
//  Hipstapaper is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Hipstapaper is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Hipstapaper.  If not, see <http://www.gnu.org/licenses/>.
//

import SwiftUI

struct SwiftUIList<C: RandomAccessCollection & Growable>: View where C.Element: Hashable {
    
    let title: String
    @StateObject var data: Observer<C>
    @State private var selection: Set<C.Element> = []
    
    init(_ title: String, _ collection: C) {
        self.title = title
        _data = .init(wrappedValue: Observer(collection))
    }
        
    var body: some View {
        List(self.data.data, id: \.self, selection: self.$selection) { item in
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
    }
}
