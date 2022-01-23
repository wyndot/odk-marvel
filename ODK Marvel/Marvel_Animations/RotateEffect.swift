//
//  RotateEffect.swift
//  ODK Marvel
//
//  Created by wyndot on 1/23/22.
//

import SwiftUI

struct RotateEffect: GeometryEffect {
    var angle: CGFloat
    
    var animatableData: CGFloat {
        get { angle }
        set { angle = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let a = Angle(degrees: angle).radians
        
        let trans = CGAffineTransform(translationX: -size.width * 0.5, y: -size.height * 0.5)
        let rotate = CGAffineTransform(rotationAngle: a)
        let back = CGAffineTransform(translationX: size.width * 0.5, y: size.height * 0.5)
        return ProjectionTransform(trans.concatenating(rotate).concatenating(back))
    }
}

extension View {
    func rotate(angle: CGFloat) -> some View {
        return modifier(RotateEffect(angle: angle))
    }
}
