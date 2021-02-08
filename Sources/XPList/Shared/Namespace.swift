//
//  Created by Jeffrey Bergier on 2021/01/22.
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

public enum XPL2 { }
public enum XPL1 { }

extension XPL1 {
    public struct SelectedKey: EnvironmentKey {
        public static let defaultValue: Bool = false
    }
    public struct EditModeKey: EnvironmentKey {
        public static let defaultValue: Bool = false
    }
    public struct ConfigurationKey: EnvironmentKey {
        public static let defaultValue: Configuration = .default
    }
    internal struct HighlightedKey: EnvironmentKey {
        public static let defaultValue: Bool = false
    }
}

extension EnvironmentValues {
    public var XPL_isSelected: Bool {
        get { self[XPL1.SelectedKey.self] }
        set { self[XPL1.SelectedKey.self] = newValue }
    }
    public var XPL_isEditMode: Bool {
        get { self[XPL1.EditModeKey.self] }
        set { self[XPL1.EditModeKey.self] = newValue }
    }
    public var XPL_Configuration: Configuration {
        get { self[XPL1.ConfigurationKey.self] }
        set { self[XPL1.ConfigurationKey.self] = newValue }
    }
    internal var XPL_isHighlighted: Bool {
        get { self[XPL1.HighlightedKey.self] }
        set { self[XPL1.HighlightedKey.self] = newValue }
    }
}

extension ColorScheme {
    internal var isLight: Bool {
        switch self {
        case .dark:
            return false
        case .light:
            fallthrough
        @unknown default:
            return true
        }
    }
}
