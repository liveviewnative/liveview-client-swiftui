//
//  TextEditor.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct TextEditor: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    @LiveBinding(attribute: "find-presented") private var isFindPresented = false
    
    @Event("phx-focus", type: "focus") var focusEvent
    @Event("phx-blur", type: "blur") var blurEvent
    @Attribute("find-disabled") private var findDisabled: Bool
    @Attribute("replace-disabled") private var replaceDisabled: Bool
    
    var body: some View {
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
            .applyAutocorrectionDisabled(disableAutocorrection)
            .applySubmitLabel(submitLabel)
#if os(iOS)
            .textInputAutocapitalization(autocapitalization)
            .applyKeyboardType(keyboard)
            .findNavigator(isPresented: $isFindPresented)
            .findDisabled(findDisabled)
            .replaceDisabled(replaceDisabled)
#endif
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
}

#endif
