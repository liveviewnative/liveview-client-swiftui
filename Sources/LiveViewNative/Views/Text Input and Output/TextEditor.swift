//
//  TextEditor.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI

/// A multi-line, long-form text editor.
///
/// ```html
/// <TextEditor value-binding="my_text" phx-focus="editor_focused" />
/// ```
///
/// ## Attributes
/// - ``findDisabled``
/// - ``replaceDisabled``
/// ## Events
/// - ``focusEvent``
/// - ``blurEvent``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct TextEditor: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    
    /// An event that fires when the text editor is focused.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-focus", type: "focus") var focusEvent
    /// An event that fires when the text editor is unfocused.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-blur", type: "blur") var blurEvent
    /// Whether find is disabled (defaults to false).
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("find-disabled") private var findDisabled: Bool
    /// Whether replace is disabled (defaults to false).
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("replace-disabled") private var replaceDisabled: Bool
    
    var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
#if os(iOS)
            .findDisabled(findDisabled)
            .replaceDisabled(replaceDisabled)
#endif
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
#endif
    }
}
