//
//  LottieAnimation.swift
//  Fastgo
//
//  Created by vishwas on 1/10/26.
//

import Lottie
import SwiftUI

struct LottieAnimation : View {
    let animationName: String
    let loopMode: LottieLoopMode
    let onAnimationDidFinish: (() -> Void)?
    init(animationName: String, loopMode: LottieLoopMode = .loop, onAnimationDidFinish: (() -> Void)? = nil){
        self.animationName = animationName
        self.loopMode = loopMode
        self.onAnimationDidFinish = onAnimationDidFinish
    }
    
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
    LottieAnimation(animationName: "Loading")
}
