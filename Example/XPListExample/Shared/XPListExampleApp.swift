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
                List(0 ..< 3) { idx in
                    switch idx {
                    case 0:
                        NavigationLink(destination: ContentView(title: "XPList Demo"),
                                       isActive: self.$isDefaultActive,
                                       label: { Text("Default") })
                    case 1:
                        NavigationLink("Halloween",
                                       destination: ContentView(title: "Halloween")
                                        .environment(\.XPL_Configuration, halloween))
                    case 2:
                        NavigationLink("Space",
                                       destination: ContentView(title: "Space")
                                        .environment(\.XPL_Configuration, space))
                    default:
                        fatalError()
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
    }
}

struct ContentView: View {
    let title: String
    @StateObject var data = XPL.Collection()
    @State var selection = Set<XPL.Element>()
    @State var openAlert: Set<XPL.Element>?
    var body: some View {
        XPL.List(self.data, selection: self.$selection)
        { open in
            self.openAlert = open
        } menu: { selection in
            Text("\(selection.count) item(s) context menu:")
            Text(selection.reduce("", { $0 + "\n" + String(describing: $1) }))
        } content: { boom in
            HStack{
                Text("\(boom.id)").font(.headline).frame(minHeight: 44)
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            }
        }
        .animation(.linear(duration: 0.2))
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .bottomBar) {
                EditButton()
            }
            #endif
            ToolbarItem(placement: .cancellationAction) {
                Button("Shrink") {
                    // This causes a crash
                    self.data.shrink()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Grow") {
                    self.data.grow()
                }
            }
        }
        .alert(item: self.$openAlert) { selection in
            Alert(title: Text("\(selection.count) Item(s)"),
                  message: Text(selection.reduce("", { $0 + "\n" + String(describing: $1) })),
                  dismissButton: .cancel())
        }
        .navigationTitle(self.title)
    }
}

// Crappy example. Do not do this in real code
extension Set: Identifiable where Element: Identifiable {
    public var id: Element.ID {
        return self.first!.id
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
