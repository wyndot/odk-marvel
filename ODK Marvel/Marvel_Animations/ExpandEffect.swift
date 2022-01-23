//
//  ExpandEffect.swift
//  ODK Marvel
//
//  Created by wyndot on 1/23/22.
//

import SwiftUI

struct ExpandEffect: GeometryEffect {
    var scale: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { CGSize.AnimatableData(scale.width, scale.height)}
        set { scale = CGSize(width: newValue.first, height: newValue.second)}
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let trans = CGAffineTransform(translationX: (1 - scale.width) *  size.width * 0.5, y: (1 - scale.height) * size.height * 0.5)
        let scale = CGAffineTransform(scaleX: scale.width, y: scale.height)
        return ProjectionTransform(scale.concatenating(trans))
    }
}

extension View {
    func expand(x: CGFloat, y: CGFloat) -> some View {
        return modifier(ExpandEffect(scale: CGSize(width: x, height: y)))
    }
    
    func expand(scale: CGSize) -> some View {
        return modifier(ExpandEffect(scale: scale))
    }
}
