//
//  SelfGestureRecognizer.swift
//  Tinkoff Chat
//
//  Created by Андрей on 30.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SelfGestureRecognizer: UIGestureRecognizer {

    let emitterLayer = CAEmitterLayer()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        emitterLayer.emitterPosition = CGPoint(x: (touches.first?.location(in: view).x)!, y: (touches.first?.location(in: view).y)!)
        
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 0.25
        cell.velocity = 20
        cell.scale = 0.1
        
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = UIImage(named: "spark")!.cgImage
        
        emitterLayer.emitterCells = [cell]
        view?.layer.addSublayer(emitterLayer)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        emitterLayer.removeAllAnimations()
        emitterLayer.removeFromSuperlayer()
        emitterLayer.emitterCells = []
    }
}
