import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

@main
struct ModifierGenerator: ParsableCommand {
    @Argument(
        help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface`",
        transform: { URL(filePath: $0) }
    )
    private var interface: URL

    // missing View-specific: resizable
    // missing: fullScreenCover

    static let extraModifierTypes: Set<String> = [
        "_StrokeModifier",
        "_ResizableModifier",
        "_RenderingModeModifier",
        "_SymbolRenderingModeModifier",
    ]

    static let denylist: Set<String> = [
        "environment",
        "environmentObject",
        "transformEnvironment",
        "preference",
        "onPreferenceChange",
        "transformPreference",
        "anchorPreference",
        "transformAnchorPreference",
        "onChange",
        "onReceive",

        "alignmentGuide",
        "layoutValue",

        "focusedObject",
        "focusedSceneObject",
        "focusedSceneValue",
        "focusedValue",
        
        "navigationDocument",
        
        "previewContext",
        "previewDevice",
        "previewInterfaceOrientation",
        "previewLayout",
        
        // fixme: missing types
        "accessibilityRotor",
        "toolbar",
        "accessibilityChartDescriptor",
        "accessibilityFocused",
        "accessibilityQuickAction",
        "alert",
        "containerRelativeFrame",
        "contextMenu",
        "controlGroupStyle",
        "copyable",
        "cuttable",
        "datePickerStyle",
        "defaultFocus",
        "digitalCrownRotation",
        "disclosureGroupStyle",
        "draggable",
        "dropDestination",
        "exportableToServices",
        "exportsItemProviders",
        "fileExporter",
        "fileImporter",
        "fileMover",
        "focused",
        "formStyle",
        "gaugeStyle",
        "gesture",
        "groupBoxStyle",
        "highPriorityGesture",
        "importableFromServices",
        "importsItemProviders",
        "indexViewStyle",
        "itemProvider",
        "labelStyle",
        "labeledContentStyle",
        "listStyle",
        "menuButtonStyle",
        "menuStyle",
        "navigationSplitViewStyle",
        "onCommand",
        "onContinuousHover",
        "onContinueUserActivity",
        "onCopyCommand",
        "onDrag",
        "onDrop",
        "onHover",
        "onKeyPress",
        "onOpenURL",
        "onPasteCommand",
        "onSubmit",
        "onTapGesture",
        "pageCommand",
        "pasteDestination",
        "pickerStyle",
        "presentationDetents",
        "presentedWindowStyle",
        "presentedWindowToolbarStyle",
        "progressViewStyle",
        "scrollPosition",
        "scrollTargetBehavior",
        "searchCompletion",
        "searchScopes",
        "sensoryFeedback",
        "simultaneousGesture",
        "symbolEffect",
        "tabViewStyle",
        "tableStyle",
        "textEditorStyle",
        "textSelection",
        "toggleStyle",
        "transaction",
        "userActivity",
        "allowedDynamicRange",
        "alternatingRowBackgrounds",
        "badgeProminence",
        "buttonRepeatBehavior",
        "colorEffect",
        "containerBackground",
        "contentMargins",
        "coordinateSpace",
        "dialogSeverity",
        "distortionEffect",
        "fileDialogBrowserOptions",
        "focusable",
        "layerEffect",
        "layoutDirectionBehavior",
        "listSectionSpacing",
        "menuActionDismissBehavior",
        "onMoveCommand",
        "ornament",
        "paletteSelectionEffect",
        "presentationBackgroundInteraction",
        "presentationCompactAdaptation",
        "presentationContentInteraction",
        "scrollBounceBehavior",
        "searchDictationBehavior",
        "springLoadingBehavior",
        "textScale",
        "toolbarTitleDisplayMode",
        "touchBar",
        "touchBarItemPresence",
        "typesettingLanguage",
        "listRowBackground",
        "tag",
        "fileDialogMessage",
        "typeSelectEquivalent",
        "fileExporterFilenameLabel",
        "dialogIcon",
        "hueRotation",
        "rotationEffect",
        "rotation3DEffect",
        "fileDialogDefaultDirectory",
        "gridCellUnsizedAxes",
        "redacted",
        "onCutCommand",
        "confirmationDialog",
        "onLongPressGesture",
        "onLongTouchGesture",
        "prefersDefaultFocus",
        "accessibilityElementModifier",
        "listRowSeparatorTint",
        "listSectionSeparator",
        "id",
        "blendMode",
        "menuOrder",
        "fontWidth",
        "listRowInsets",
        "menuIndicator",
        "safeAreaPadding",
        "headerProminence",
        "listRowSeparator",
        "tableColumnHeaders",
        "listSectionSeparator",
        "digitalCrownAccessory",
        "scrollContentBackground",
        "persistentSystemOverlays",
        "presentationDragIndicator",
        "fontDesign",
        "controlSize",
        "submitLabel",
        "toolbarRole",
        "defaultHoverEffect",
        "listRowHoverEffect",
        "preferredColorScheme",
        "focusScope",
        "hoverEffect",
        "listItemTint",
        "keyboardShortcut",
        "symbolVariant",
        "textContentType",
        "defaultAppStorage",
        "ignoresSafeArea",
        "buttonBorderShape",
        "contentTransition",
        "truncationMode",
        "projectionEffect",
        "gridColumnAlignment",
        "transformEffect",
        "scrollIndicators",
        "scrollDismissesKeyboard",
        "renameAction",
        "matchedGeometryEffect",
        "accessibilityRotorEntry",
        "accessibilityLinkedGroup",
        "handlesExternalEvents",
        "safeAreaInset",
        "swipeActions",
        "accessibilityLabeledPair",
        "badge",
        "fileDialogConfirmationLabel",
        "searchSuggestions",
        "scenePadding",
        "drawingGroup",
        "searchable",
        "underline",
        "strikethrough",
        "contentShape",
        "onCopyCommand",
        "accessibilityElement",
        "listSectionSeparatorTint",
        "popover",

        // fixme: variadic enum cases
        "toolbarBackground",
        "toolbarColorScheme",

        // fixme: labelled argument ordering
        "mask",
    ]

    func run() throws {
        let source = try String(contentsOf: interface, encoding: .utf8)
        let sourceFile = Parser.parse(source: source)
        
        let visitor = ModifierVisitor(viewMode: SyntaxTreeViewMode.all)
        visitor.walk(sourceFile)

        var output = #"""
        // File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`
        
        import SwiftUI
        import LiveViewNativeStylesheet


        """#

        var modifierList = [String]()

        for (modifier, signatures) in visitor.modifiers.sorted(by: { $0.key < $1.key }) {
            guard !modifier.starts(with: "_"),
                  !Self.denylist.contains(modifier),
                  !signatures.allSatisfy({ !isValid($0.0) })
            else {
                FileHandle.standardError.write(Data("`\(modifier)` will be skipped\n".utf8))
                continue
            }
            modifierList.append(modifier)
            let signatures = signatures
                // remove invalid function signatures (unsupported types/forms)
                .filter({ isValid($0.0) })
                .enumerated()
                .map(Signature.init)
                // remove duplicates
                .reduce(into: [Signature]()) { result, next in
                    func isDuplicate(_ lhs: Signature, _ rhs: Signature) -> Bool {
                        guard lhs.parameters.count == rhs.parameters.count
                        else { return false }
                        for (a, b) in zip(lhs.parameters, rhs.parameters) {
                            guard (a.type.as(MemberTypeSyntax.self)?.name.text ?? a.type.description) == (b.type.as(MemberTypeSyntax.self)?.name.text ?? b.type.description),
                                  a.firstName.text == b.firstName.text
                            else { return false }
                        }
                        return true
                    }
                    for previous in result {
                        if isDuplicate(previous, next) {
                            return
                        }
                    }
                    result.append(next)
                }
            
            let requiresContext = signatures.contains(where: {
                $0.parameters.contains(where: {
                    ["ViewReference", "TextReference", "AttributeReference"].contains(
                        $0.type.as(IdentifierTypeSyntax.self)?.name.text
                         ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
                    )
                })
            })
            
            output.append(#"""
            @ParseableExpression
            struct _\#(modifier)Modifier<R: RootRegistry>: ViewModifier {
                static var name: String { "\#(modifier)" }

                enum Value {
            \#(signatures.map(\.case).joined(separator: "\n"))
                }

                let value: Value

                \#(requiresContext ? "@ObservedElement private var element" : "")
                \#(requiresContext ? "@LiveContext<R> private var context" : "")
            
            \#(signatures.compactMap(\.properties).joined(separator: "\n"))

            \#(signatures.map(\.`init`).joined(separator: "\n"))

                func body(content __content: Content) -> some View {
                    switch value {
            \#(signatures.map(\.content).joined(separator: "\n"))
                    }
                }
            }

            """#)
        }

        output.append(#"""

        extension BuiltinRegistry {
            enum BuiltinModifier: ViewModifier, ParseableModifierValue {
                \#(modifierList.map({ "case \($0)(_\($0)Modifier<R>)" }).joined(separator: "\n"))
                \#(Self.extraModifierTypes.map({ "case \($0)(LiveViewNative.\($0))" }).joined(separator: "\n"))
                
                func body(content: Content) -> some View {
                    switch self {
                    \#(modifierList.map({
                        """
                        case let .\($0)(modifier):
                            content.modifier(modifier)
                        """
                    }).joined(separator: "\n"))
                    \#(Self.extraModifierTypes.map({
                        """
                        case let .\($0)(modifier):
                            content.modifier(modifier)
                        """
                    }).joined(separator: "\n"))
                    }
                }
                
                static func parser(in context: ParseableModifierContext) -> _ParserType {
                    .init(context: context)
                }

                struct _ParserType: Parser {
                    typealias Input = Substring.UTF8View
                    typealias Output = BuiltinModifier
                    
                    let context: ParseableModifierContext
                    
                    func parse(_ input: inout Substring.UTF8View) throws -> Output {
                        let parsers = [
                            \#(modifierList.map({ "_\($0)Modifier<R>.parser(in: context).map(Output.\($0)).eraseToAnyParser()," }).joined(separator: "\n"))
                            \#(Self.extraModifierTypes.map({ "LiveViewNative.\($0).parser(in: context).map(Output.\($0)).eraseToAnyParser()," }).joined(separator: "\n"))
                        ]
                        
                        return try OneOf {
                            for parser in parsers {
                                parser
                            }
                        }
                        .parse(&input)
                    }
                }
            }
        }
        """#)

        FileHandle.standardOutput.write(Data(output.utf8))
    }

    func isValid(_ signature: FunctionDeclSyntax) -> Bool {
        for parameter in signature.signature.parameterClause.parameters {
            // ViewBuilder closures with arguments cannot be used.
            if parameter.isViewBuilder
                && (parameter.type.as(FunctionTypeSyntax.self) ?? parameter.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self))?.parameters.count != 0
            {
                return false
            }
        }
        return true
    }
}