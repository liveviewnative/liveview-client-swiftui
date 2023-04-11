//
//  BoldModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

/// Makes any child ``Text`` elements bold.
///
/// The effect can be toggled with the [`is_active`](doc:BoldModifier/isActive) argument.
///
/// ```html
/// <Text modifiers={bold(@native)}>Hello, world!</Text>
/// <Text modifiers={bold(@native, is_active: false)}>Hello, world!</Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BoldModifier: ViewModifier, Decodable {
    /// Enables/disables the bold effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var isActive: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
    }

    func body(content: Content) -> some View {
        content.bold(isActive)
    }
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
    }
}
