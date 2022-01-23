//
//  DropEffect.swift
//  ODK Marvel
//
//  Created by wyndot on 1/23/22.
//

import SwiftUI

struct DropEffect: GeometryEffect {
    var offset: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { CGSize.AnimatableData(offset.width, offset.height)}
        set { offset = CGSize(width: newValue.first, height: newValue.second)}
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
}

extension View {
    func drop(x: CGFloat, y: CGFloat) -> some View {
        return modifier(DropEffect(offset: CGSize(width: x, height: y)))
    }
    
    func drop(offset: CGSize) -> some View {
        return modifier(DropEffect(offset: offset))
    }
}
