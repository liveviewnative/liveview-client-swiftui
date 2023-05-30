//
//  DraggableModifier.swift
//  
//
//  Created by murtza on 30/05/2023.
//

import SwiftUI

/// Activates this view as the source of a drag and drop operation.
///
/// ```html
/// <Text modifiers={draggable(@native, payload: "ABC", preview: :my_preview)}>
///     ABC
///     <Image system-name="heart.fill" template={:my_preview}>
/// </Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DraggableModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// A closure that returns a single instance or a value conforming to Transferable that represents the draggable data from this view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let payload: String
    
    /// A View to use as the source for the dragging preview, once the drag operation has begun. The preview is centered over the source view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let preview: String?
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.payload = try container.decode(String.self, forKey: .payload)
        self.preview = try container.decodeIfPresent(String.self, forKey: .preview)
    }
    
    func body(content: Content) -> some View {
        #if !os(watchOS)
        if let preview {
            content.draggable(
                payload,
                preview:
                    {
                    context.buildChildren(of: element, forTemplate: preview)
                            .environment(\.coordinatorEnvironment, coordinatorEnvironment)
                            .environment(\.anyLiveContextStorage, context.storage)
                    }
            )
        }else{
            content.draggable(payload)
        }
        #else
        content
        #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case payload
        case preview
    }
}

