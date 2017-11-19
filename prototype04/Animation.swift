//
//  Animation.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/05/14.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

//画面遷移時、Disolveでアニメーション遷移する
//利用ファイル
//registerPhoto→Preview
//Preview→Location

import UIKit

class Animation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewCotnroller = transitionContext.viewController(forKey: .from)
        let toViewCotnroller = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        let fromView = fromViewCotnroller?.view
        let toView = toViewCotnroller?.view
        
        fromView?.frame = transitionContext.initialFrame(for: fromViewCotnroller!)
        toView?.frame = transitionContext.finalFrame(for: toViewCotnroller!)
        
        fromView?.alpha = 1.0
        toView?.alpha = 0.0
        
        containerView.addSubview(toView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: { () -> Void in
            fromView?.alpha = 0.0
            toView?.alpha = 1.0
        }, completion: { (BOOL) -> Void in
            let wasCanceled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCanceled)
        })
        
    }
}
