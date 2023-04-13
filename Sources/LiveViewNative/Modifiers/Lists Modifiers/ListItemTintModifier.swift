//
//  ListItemTintModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the tint for a list item.
///
/// Apply this modifier to child elements of a ``List`` to set their tint.
///
/// See ``LiveViewNative/SwiftUI/ListItemTint`` for more details on creating tints.
///
/// ```html
/// <List modifiers={list_item_tint(@native, tint: :monochrome)}>
///     <Label system-image="gear" id="gear">Default</Label>
///     <Label
///         modifiers={list_item_tint(@native, tint: :monochrome)}
///         system-image="square.lefthalf.filled" id="monochrome"
///     >
///         Monochrome
///     </Label>
///     <Label
///         modifiers={list_item_tint(@native, tint: {:fixed, :red})}
///         system-image="paintpalette.fill" id="fixed"
///     >
///         Fixed Red
///     </Label>
///     <Label
///         modifiers={list_item_tint(@native, tint: {:preferred, :red})}
///         system-image="swatchpalette.fill" id="preferred"
///     >
///         Preferred Red
///     </Label>
/// </List>
/// ```
///
/// ## Arguments
/// * ``tint``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ListItemTintModifier: ViewModifier, Decodable {
    /// The tint value.
    ///
    /// If `nil`, the default system is used.
    ///
    /// See ``LiveViewNative/SwiftUI/ListItemTint`` for more details on creating tints.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let tint: ListItemTint?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tint = try container.decodeIfPresent(ListItemTint.self, forKey: .tint)
    }

    func body(content: Content) -> some View {
        content.listItemTint(tint)
    }

    enum CodingKeys: String, CodingKey {
        case tint
    }
}
