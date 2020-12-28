//
//  LazyView.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-12-19.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import SwiftUI

/// Lazily initialize a view, allocation its dependencies when a view is presented for the first time. Useful with
/// NavigationLink.
public struct LazyView<Content: View>: View {
    private let build: () -> Content

    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    public var body: Content {
        build()
    }
}
