//
//  AnyGesture+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyGesture: ParseableModifierValue where Value == Any {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            baseParser(in: context)
        } member: {
            Member.parser(in: context)
        }
        .map { (base, members) in
            return members.reduce(into: base) { result, member in
                result = member.apply(to: result)
            }
        }
    }
    
    enum Member: ParseableModifierValue {
        case sequenced(Sequenced)
        case simultaneously(Simultaneously)
        case onEnded(OnEnded)
        case exclusively(Exclusively)
        
        @ParseableExpression
        struct Sequenced {
            static let name = "sequenced"
            
            let other: AnyGesture<Any>
            
            init(before other: AnyGesture<Any>) {
                self.other = other
            }
        }
        
        @ParseableExpression
        struct Simultaneously {
            static let name = "simultaneously"
            
            let other: AnyGesture<Any>
            
            init(with other: AnyGesture<Any>) {
                self.other = other
            }
        }
        
        @ParseableExpression
        struct OnEnded {
            static let name = "onEnded"
            
            @Event var action: Event.EventHandler
            
            init(_ action: Event) {
                self._action = action
            }
        }
        
        @ParseableExpression
        struct Exclusively {
            static let name = "exclusively"
            
            let other: AnyGesture<Any>
            
            init(before other: AnyGesture<Any>) {
                self.other = other
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Sequenced.parser(in: context).map(Self.sequenced)
                Simultaneously.parser(in: context).map(Self.simultaneously)
                OnEnded.parser(in: context).map(Self.onEnded)
                Exclusively.parser(in: context).map(Self.exclusively)
            }
        }
        
        func apply(to gesture: AnyGesture<Any>) -> AnyGesture<Any> {
            switch self {
            case .sequenced(let sequenced):
                return AnyGesture<Any>(gesture.sequenced(before: sequenced.other).map({ $0 as Any }))
            case .simultaneously(let simultaneously):
                return AnyGesture<Any>(gesture.simultaneously(with: simultaneously.other).map({ $0 as Any }))
            case .onEnded(let onEnded):
                return AnyGesture<Any>(gesture.onEnded({ value in
                    Task {
                        await onEnded.action(value: value)
                    }
                }).map({ $0 as Any }))
            case .exclusively(let exclusively):
                return AnyGesture<Any>(gesture.exclusively(before: exclusively.other).map({ $0 as Any }))
            }
        }
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            #if !os(tvOS)
            Drag.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
            #endif
            LongPress.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
            #if os(iOS) || os(macOS)
            Magnify.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
            Rotate.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
            #endif
            #if !os(tvOS)
            SpatialTap.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
            #endif
            Tap.parser(in: context).map({ Self.init($0.value.map({ $0 as Any })) })
        }
    }
    
    #if !os(tvOS)
    @ParseableExpression
    struct Drag {
        static let name = "DragGesture"
        let value: DragGesture
        
        init(minimumDistance: CGFloat = 10, coordinateSpace: AnyCoordinateSpaceProtocol = .local) {
            self.value = .init(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace.coordinateSpace)
        }
    }
    #endif
    
    @ParseableExpression
    struct LongPress {
        static let name = "LongPressGesture"
        let value: LongPressGesture
        
        init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10) {
            self.value = .init(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        }
    }
    
    #if os(iOS) || os(macOS) || os(xrOS)
    @ParseableExpression
    struct Magnify {
        static let name = "MagnifyGesture"
        let value: AnyGesture<Any>
        
        init(minimumScaleDelta: CGFloat = 0.01) {
            if #available(iOS 17, macOS 14, *) {
                self.value = .init(MagnifyGesture.init(minimumScaleDelta: minimumScaleDelta).map({ $0 as Any }))
            } else {
                self.value = .init(MagnificationGesture.init(minimumScaleDelta: minimumScaleDelta).map({ $0 as Any }))
            }
        }
    }
    
    @ParseableExpression
    struct Rotate {
        static let name = "RotateGesture"
        let value: AnyGesture<Any>
        
        init(minimumAngleDelta: Angle = .degrees(1)) {
            if #available(iOS 17, macOS 14, *) {
                self.value = .init(RotateGesture.init(minimumAngleDelta: minimumAngleDelta).map({ $0 as Any }))
            } else {
                self.value = .init(RotationGesture.init(minimumAngleDelta: minimumAngleDelta).map({ $0 as Any }))
            }
        }
    }
    #endif
    
    #if !os(tvOS)
    @ParseableExpression
    struct SpatialTap {
        static let name = "SpatialTapGesture"
        let value: SpatialTapGesture
        
        init(count: Int = 1, coordinateSpace: AnyCoordinateSpaceProtocol = .local) {
            self.value = .init(count: count, coordinateSpace: coordinateSpace.coordinateSpace)
        }
    }
    #endif
    
    @ParseableExpression
    struct Tap {
        static let name = "TapGesture"
        let value: TapGesture
        
        init(count: Int = 1) {
            self.value = .init(count: count)
        }
    }
}

