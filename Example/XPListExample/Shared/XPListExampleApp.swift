//
//  Created by Jeffrey Bergier on 2021/01/23.
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

@main
struct XPListExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List() {
                    Section(header: Text("Bug: SwiftUI.List")) {
                        NavigationLink(destination: SwiftUIList("Reference Collection 🐞", ReferenceCollection()),
                                       label: { Text("Reference Collection 🐞") })
                        NavigationLink(destination: SwiftUIList("Value Collection", ValueCollection()),
                                       label: { Text("Value Collection") })
                    }
                    Section(header: Text("No Bug: List1: LazyVStack")) {
                        NavigationLink(destination: List1Demo("Reference Collection", ReferenceCollection()),
                                       label: { Text("Reference Collection") })
                        NavigationLink(destination: List1Demo("Value Collection", ValueCollection()),
                                       label: { Text("Value Collection") })
                    }
                    Section(header: Text("Demo: List1: LazyVStack")) {
                        NavigationLink(destination: List1Demo("Default Appearance", ValueCollection()),
                                       label: { Text("Default Appearance") })
                        NavigationLink(destination: List1Demo("Halloween Appearance", ValueCollection())
                                        .environment(\.XPL_Configuration, halloween),
                                       label: { Text("Halloween Appearance") })
                        NavigationLink(destination: List1Demo("Space Appearance", ValueCollection())
                                        .environment(\.XPL_Configuration, space),
                                       label: { Text("Space Appearance") })
                    }
                    Section(header: Text("Demo: List2: SwiftUI.List")) {
                        NavigationLink(destination: List2Demo("Default Appearance", ValueCollection()),
                                       label: { Text("Default Appearance") })
                        NavigationLink(destination: List2Demo("Reference Collection 🐞", ReferenceCollection()),
                                       label: { Text("Reference Collection 🐞") })
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
    }
}

fileprivate let halloween = Configuration(cellPadding: .init(top: 6, leading: 16, bottom: 6, trailing: 16),
                                          separatorPadding: .init(top: 0, leading: 16, bottom: 0, trailing: 0),
                                          separator: Color.orange,
                                          selectedBackground: Color.orange.opacity(0.3),
                                          deselectedBackground: Color.black,
                                          selectedForeground: Color.orange,
                                          deselectedForeground: Color.orange.opacity(0.5),
                                          accessoryAccent: Color.orange,
                                          selectedAccessory: Image(systemName: "ant.circle.fill"),
                                          deselectedAccessory: Image(systemName: "ant.circle"))

fileprivate let space = Configuration(cellPadding: .init(top: 20, leading: 40, bottom: 20, trailing: 40),
                                      separatorPadding: .init(top: 0, leading: 40, bottom: 0, trailing: 40),
                                      separator: Color.purple,
                                      selectedBackground: Color.purple.opacity(0.3),
                                      deselectedBackground: Color.black,
                                      selectedForeground: Color.purple,
                                      deselectedForeground: Color.purple.opacity(0.5),
                                      accessoryAccent: Color.purple,
                                      selectedAccessory: Image(systemName: "star.fill"),
                                      deselectedAccessory: Image(systemName: "moon.stars"))
