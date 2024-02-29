//
//  Button.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

/// `<Button>`, sends events when tapped.
///
/// Use the `phx-click` attribute to specify which event to fire on tap.
///
/// ```html
/// <Button phx-click="my_event" phx-value-extra="more info">Click Me!</Button>
/// ```
///
/// ```elixir
/// def handle_event("my_event", %{ "extra" => extra }, socket) do
///     {:noreply, assign(socket, value: extra)}
/// end
/// ```
/// 
/// ## Attributes
/// * ``role``
///
/// ## Events
/// * ``click``
@_documentation(visibility: public)
@_spi(LiveForm)
public struct Button<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    // used internaly by PhxSubmitButton
    private let action: (() -> Void)?
    
    /// Event triggered when tapped.
    @_documentation(visibility: public)
    @Event("phx-click", type: "click") private var click
    
    /// The semantic role of the button.
    ///
    /// Possible values:
    /// * `destructive`
    /// * `cancel`
    @_documentation(visibility: public)
    @Attribute("role") private var role: ButtonRole?
    
    @_spi(LiveForm) public init(action: (() -> Void)? = nil) {
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(role: role, action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .preference(key: _ProvidedBindingsKey.self, value: ["phx-click"])
    }
    
    private func handleClick() {
        if let action = action {
            action()
            return
        }
        click(value: element.buildPhxValuePayload()) {}
    }
}
