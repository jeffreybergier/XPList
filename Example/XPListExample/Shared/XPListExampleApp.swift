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
    @State var isDefaultActive = true
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List() {
                    Section(header: Text("SwiftUI.List Bug Example")) {
                        NavigationLink(destination: SwiftUIList("Reference Collection 🐞", ReferenceCollection()),
                                       isActive: self.$isDefaultActive,
                                       label: { Text("Reference Collection 🐞") })
                        NavigationLink(destination: SwiftUIList("Value Collection", ValueCollection()),
                                       label: { Text("Value Collection") })
                    }
                    Section(header: Text("XPL.List Bug Example")) {
                        NavigationLink(destination: XPLList("Reference Collection", ReferenceCollection()),
                                       label: { Text("Reference Collection") })
                        NavigationLink(destination: XPLList("Value Collection", ValueCollection()),
                                       label: { Text("Value Collection") })
                    }
                    Section(header: Text("XPL.List Demo")) {
                        NavigationLink(destination: XPLList("Default Appearance", ValueCollection()),
                                       label: { Text("Default Appearance") })
                        NavigationLink(destination: XPLList("Halloween Appearance", ValueCollection())
                                        .environment(\.XPL_Configuration, halloween),
                                       label: { Text("Halloween Appearance") })
                        NavigationLink(destination: XPLList("Space Appearance", ValueCollection())
                                        .environment(\.XPL_Configuration, space),
                                       label: { Text("Space Appearance") })
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
    }
}

fileprivate let halloween = XPL.Configuration(cellPadding: .init(top: 6, leading: 16, bottom: 6, trailing: 16),
                                              separatorPadding: .init(top: 0, leading: 16, bottom: 0, trailing: 0),
                                              separator: Color.orange,
                                              selectedBackground: Color.orange.opacity(0.3),
                                              deselectedBackground: Color.black,
                                              selectedForeground: Color.orange,
                                              deselectedForeground: Color.orange.opacity(0.5),
                                              accessoryAccent: Color.orange,
                                              selectedAccessory: Image(systemName: "ant.circle.fill"),
                                              deselectedAccessory: Image(systemName: "ant.circle"))

fileprivate let space = XPL.Configuration(cellPadding: .init(top: 20, leading: 40, bottom: 20, trailing: 40),
                                              separatorPadding: .init(top: 0, leading: 40, bottom: 0, trailing: 40),
                                              separator: Color.purple,
                                              selectedBackground: Color.purple.opacity(0.3),
                                              deselectedBackground: Color.black,
                                              selectedForeground: Color.purple,
                                              deselectedForeground: Color.purple.opacity(0.5),
                                              accessoryAccent: Color.purple,
                                              selectedAccessory: Image(systemName: "star.fill"),
                                              deselectedAccessory: Image(systemName: "moon.stars"))
