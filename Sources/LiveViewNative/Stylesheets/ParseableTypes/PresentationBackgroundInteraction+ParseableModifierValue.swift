//
//  PresentationBackgroundInteraction+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension PresentationBackgroundInteraction: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                "automatic".utf8.map({ Self.automatic })
                "enabled".utf8.map({ Self.enabled })
                Enabled.parser(in: context).map({ Self.enabled(upThrough: $0.detent) })
                "disabled".utf8.map({ Self.disabled })
            }
        }
    }
    
    @ParseableExpression
    struct Enabled {
        static let name = "enabled"
        let detent: PresentationDetent
        
        init(upThrough detent: PresentationDetent) {
            self.detent = detent
        }
    }
}
