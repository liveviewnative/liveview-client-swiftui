//
//  DisclosureGroup.swift
//
//
//  Created by Carson Katri on 2/22/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct DisclosureGroup<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @LiveBinding(attribute: "is-expanded") private var isExpanded = false
    
    @Attribute("disclosure-group-style") private var style: DisclosureGroupStyle = .automatic

    public var body: some View {
        SwiftUI.DisclosureGroup(isExpanded: $isExpanded) {
            context.buildChildren(of: element, withTagName: "content", namespace: "DisclosureGroup", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "DisclosureGroup", includeDefaultSlot: false)
        }
        .applyDisclosureGroupStyle(style)
    }
}

fileprivate enum DisclosureGroupStyle: String, AttributeDecodable {
    case automatic
}

fileprivate extension View {
    @ViewBuilder
    func applyDisclosureGroupStyle(_ style: DisclosureGroupStyle) -> some View {
        switch style {
        case .automatic:
            self.disclosureGroupStyle(.automatic)
        }
    }
}
#endif
