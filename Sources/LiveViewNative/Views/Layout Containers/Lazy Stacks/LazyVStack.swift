//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

/// Vertical stack that creates Views lazily.
///
/// Lazy stacks behave similar to their non-lazy counterparts.
///
/// Use the ``pinnedViews`` attribute to pin section headers/footers when contained in a `ScrollView`.
///
/// ```html
/// <ScrollView axes="vertical">
///     <LazyVStack>
///         <%= for i <- 1..50 do %>
///             <Text id={i |> Integer.to_string} font="largeTitle"><%= i %></Text>
///         <% end %>
///     </LazyVStack>
/// </ScrollView>
/// ```
///
/// ## Attributes
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
///
/// ## See Also
/// ### Stacks
/// * ``VStack``
@_documentation(visibility: public)
@LiveElement
struct LazyVStack<Root: RootRegistry>: View {
    /// The horizontal alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/VerticalAlignment``.
    @_documentation(visibility: public)
    private var alignment: HorizontalAlignment = .center
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    @_documentation(visibility: public)
    private var spacing: CGFloat?
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews = []
    
    public var body: some View {
        SwiftUI.LazyVStack(
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            $liveElement.children()
        }
    }
}
