//
//  BackgroundModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/17/23.
//

import SwiftUI

/// Renders nested content within the background of an element.
///
/// Nested content is referenced by its namespace using the `content` argument. 
///
/// ```html
/// <HStack>
///   <Image system-name="heart.fill" modifiers={@native |> background(alignment: :center, content: :bg_content)}>
///     <Circle #bg_content />
///   </Image>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``alignment``
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    @ObservedElement private var element
    @LiveContext<R> private var context
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let alignment: Alignment
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let content: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.background(alignment: alignment) {
            context.buildChildren(of: element, forTemplate: self.content)
        }
    }

    enum CodingKeys: CodingKey {
        case alignment
        case content
    }
}
