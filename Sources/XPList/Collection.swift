//
//  Created by Jeffrey Bergier on 2021/01/22.
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

import Combine

extension XPL {
    /// Single purpose element for testing the XPL.List
    internal struct Element: Identifiable, Hashable {
        var id: Int
        init(_ id: Int) {
            self.id = id
        }
    }
    
    /// Single purpose collection for testing the XPL.List
    internal class Collection: RandomAccessCollection, ObservableObject {
        
        typealias Index = Int
        typealias Element = XPL.Element
        
        var startIndex: Index = 0
        var endIndex: Index = 0
        
        func grow() {
            self.objectWillChange.send()
            self.endIndex += 1
        }
        func shrink() {
            guard self.endIndex > self.startIndex else { return }
            self.objectWillChange.send()
            self.endIndex -= 1
        }
        func load() {
            self.objectWillChange.send()
            self.endIndex = 10_000
        }
        
        subscript(index: Index) -> Element {
            guard index < self.endIndex else { fatalError("Index Out of Bounds") }
            return XPL.Element(index)
        }
    }
}
