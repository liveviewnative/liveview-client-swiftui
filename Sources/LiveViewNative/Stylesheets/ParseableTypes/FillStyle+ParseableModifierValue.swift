//
//  FillStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension FillStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableFillStyle.parser(in: context).map({
            Self.init(eoFill: $0.eoFill, antialiased: $0.antialiased)
        })
    }
    
    @ParseableExpression
    struct ParseableFillStyle {
        static let name = "FillStyle"
        
        let eoFill: Bool
        let antialiased: Bool
        
        init(eoFill: Bool = false, antialiased: Bool = true) {
            self.eoFill = eoFill
            self.antialiased = antialiased
        }
    }
}
