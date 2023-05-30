//
//  SymbolVariantModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/30/23.
//

import SwiftUI

/// Makes symbols within the view show a particular variant.
///
/// ```html
/// <Image system-name="envelope.badge" modifiers={symbol_variant(@native, variant: :fill)} />
/// ```
///
/// ## Arguments
/// * ``variant``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SymbolVariantModifier: ViewModifier, Decodable {
    /// The variant to use for symbols.
    ///
    /// See ``LiveViewNative/SwiftUI/SymbolVariants`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let variant: SymbolVariants
    
    func body(content: Content) -> some View {
        content.symbolVariant(variant)
    }
}
