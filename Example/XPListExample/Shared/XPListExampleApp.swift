//
//  Created by Jeffrey Bergier on 2021/01/23.
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

@main
struct XPListExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Color.clear
                ContentView()
            }
        }
    }
}

struct ContentView: View {
    @StateObject var data = XPL.Collection()
    @State var selection = Set<XPL.Element>()
    var body: some View {
        XPL.List(self.data, selection: self.$selection)
        { boom in
            print(boom)
        } content: { boom in
            HStack{
                Text("\(boom.id)").font(.headline).frame(minHeight: 44)
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem {
                EditButton()
            }
            #endif
            ToolbarItem {
                Button("Grow") {
                    self.data.grow()
                }
            }
            ToolbarItem {
                Button("Shrink") {
                    // This causes a crash
                    self.data.shrink()
                }
            }
        }
    }
}
