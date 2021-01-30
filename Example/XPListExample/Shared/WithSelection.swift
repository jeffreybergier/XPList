//
//  Created by Jeffrey Bergier on 2021/01/26.
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

struct WithSelection: View {
    let title: String
    @StateObject var data = XPL.Collection()
    @State var selection = Set<XPL.Element>()
    @State var open: Set<XPL.Element>?
    var body: some View {
        XPL.List(data: self.data,
                 selection: self.$selection,
                 open: { self.open = $0 },
                 menu: { self.menu($0)})
        { element in
            HStack{
                Text("\(element.id)").font(.headline).frame(minHeight: 44)
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
        }
        .onAppear { self.data.load() }
        .modifier(Toolbar(data: self.data))
        .modifier(Open(open: self.$open))
        .navigationTitle(self.title)
        .animation(.linear(duration: 0.2))
    }
    
    @ViewBuilder private func menu(_ items: Set<XPL.Element>) -> some View {
        Text("\(items.count) item(s)")
        ForEach(Array(items)) {
            Text(String(describing: $0))
        }
    }
}
