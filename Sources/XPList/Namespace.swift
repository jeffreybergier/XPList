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

import SwiftUI

public enum XPL { }

extension XPL {
    public struct SelectedKey: EnvironmentKey {
        public static let defaultValue: Bool = false
    }
    public struct EditModeKey: EnvironmentKey {
        public static let defaultValue: Bool = false
    }
    public struct ConfigurationKey: EnvironmentKey {
        public static let defaultValue: XPL.Configuration = .default
    }
}

extension EnvironmentValues {
    public var XPL_isSelected: Bool {
        get { self[XPL.SelectedKey.self] }
        set { self[XPL.SelectedKey.self] = newValue }
    }
    public var XPL_isEditMode: Bool {
        get { self[XPL.EditModeKey.self] }
        set { self[XPL.EditModeKey.self] = newValue }
    }
    public var XPL_Configuration: XPL.Configuration {
        get { self[XPL.ConfigurationKey.self] }
        set { self[XPL.ConfigurationKey.self] = newValue }
    }
}

extension ColorScheme {
    var isLight: Bool {
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
