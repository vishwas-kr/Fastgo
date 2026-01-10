//
//  LottieAnimation.swift
//  Fastgo
//
//  Created by vishwas on 1/10/26.
//

import Lottie
import SwiftUI

struct LottieAnimation : View {
    let animationName : String = "Loading"
    let loopMode : LottieLoopMode = .loop
    let onAnimationDidFinish : (() -> Void)? = nil
    var body : some View {
        LottieView(animation: .named(animationName))
            .configure{ config in
                config.contentMode = .scaleAspectFit
                config.shouldRasterizeWhenIdle = true
            }
            .playbackMode(.playing(.toProgress(1, loopMode: loopMode)))
            .animationDidFinish{ completed in
                onAnimationDidFinish?()
            }
    }
}


#Preview{
    LottieAnimation()
}
