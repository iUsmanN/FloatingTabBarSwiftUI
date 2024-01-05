//
//  Tabiew.swift
//  tabbar-experiment
//
//  Created by Usman Nazir on 05/01/2024.
//

import SwiftUI

/// A custom SwiftUI view that creates a floating tab view.
/// It takes a generic tab item conforming to `FloatingTabItemProtocol` and a generic content view.
///
/// - Parameters:
///   - T: The type of the tab item conforming to `FloatingTabItemProtocol`.
///   - Content: The type of the content view to be displayed in each tab.
public struct FloatingTabView<T: FloatingTabItemProtocol, Content: View>: View {
    /// The currently selected tab index.
    @State var selected: Int = 0

    /// The content view to be displayed.
    let content: Content

    /// The tab items conforming to `FloatingTabItemProtocol`.
    let tabs: T.Type

    /// Initializes a `FloatingTabView` with specified tab items and content.
    ///
    /// - Parameters:
    ///   - tabItems: The type of the tab items conforming to `FloatingTabItemProtocol`.
    ///   - content: A closure returning the content view to be displayed.
    public init(tabItems: T.Type, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.tabs = tabItems
    }

    /// The body of the `FloatingTabView`.
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selected) {
                content
            }

            ZStack {
                HStack {
                    ForEach(Array(tabs.cases().enumerated()), id: \.element) { index, item in
                        Button {
                            selected = index
                        } label: {
                            tabViewItem(item: item, active: (selected == index))
                                .padding(.horizontal, 2.5)
                                .shadow(color: item.tintColor, radius: (selected == index) ? 25 : 0)
                        }
                    }
                }
                .padding(15)
            }
            .frame(height: 70)
            .background(.regularMaterial)
            .cornerRadius(25)
        }
    }

    /// Returns a view for a single tab item.
    ///
    /// - Parameters:
    ///   - item: The tab item to be displayed.
    ///   - active: A Boolean value indicating whether the tab item is currently active.
    @ViewBuilder
    func tabViewItem(item: T, active: Bool) -> some View {
        VStack(spacing: 2) {
            Image(systemName: item.iconName)
                .renderingMode(.template)
                .frame(width: 20, height: 25)
            Text(item.title)
                .bold(active)
                .font(.system(size:  active ? 14 : 13))
        }
        .foregroundStyle(!active ? .primary : item.tintColor)
        .frame(width: 60)
        .cornerRadius(30)
    }
}
