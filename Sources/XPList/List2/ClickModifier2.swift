//
//  ClickModifier.swift
//  XPListExample
//
//  Created by Jeffrey Bergier on 2021/03/07.
//

import SwiftUI

internal struct ClickModifier2: ViewModifier {
    
    internal typealias Action = () -> Void
    
    internal let open: Action
    @Environment(\.XPL_isEditMode) private var isEditMode
    
    func body(content: Content) -> some View {
        content
            .modifier(If.mac(ClickReceiver(clickCount: 2, finish: self.open)))
            .modifier(If.iOS(and: !self.isEditMode, ClickReceiver(clickCount: 1, finish: self.open)))
    }
}
