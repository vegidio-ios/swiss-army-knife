//
//  View+Ext.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-12-28.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import SwiftUI

public extension View {
    /// Convert the existing view to AnyView
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
