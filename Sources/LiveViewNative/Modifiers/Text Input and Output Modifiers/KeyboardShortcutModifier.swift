//
//  KeyboardShortcutModifier.swift
//  
//
//  Created by murtza on 18/05/2023.
//

import SwiftUI

/// Assigns a keyboard shortcut to the modified control.
///
/// ```html
/// <Button modifiers={keyboard_shortcut(@native, key: "+")}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "7")}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "s", modifiers: [:command])}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "s", modifiers: [:command, :shift])}>Click Me!</Button>
/// ```
///
/// ## Arguments
/// * ``key``
/// * ``modifiers``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 14.0, macOS 11.0, *)
struct KeyboardShortcutModifier: ViewModifier, Decodable {
    /// The key equivalent that the user presses in conjunction with any specified modifier keys to activate the shortcut.
    ///
    /// See ``LiveViewNative/SwiftUI/KeyEquivalent`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var key: KeyEquivalent
    /// The modifier keys that the user presses in conjunction with a key equivalent to activate the shortcut.
    ///
    /// See ``LiveViewNative/SwiftUI/EventModifiers`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let modifiers: EventModifiers

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .keyboardShortcut(key, modifiers: modifiers)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case modifiers
    }
}

extension KeyboardShortcutModifier {
    #if !os(iOS) && !os(macOS)
    typealias KeyEquivalent = Never
    #endif
}
