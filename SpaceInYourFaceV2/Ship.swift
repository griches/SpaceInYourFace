//
//  Ship.swift
//  SpaceInYourFaceV2
//
//  Created by devpair44 on 15/11/2019.
//  Copyright © 2019 Ford. All rights reserved.
//

import SpriteKit
import UIKit

class Ship: SKSpriteNode {

    let playerIndex: Int

    // Rotation
    var isRotatingLeft: Bool = false
    var isRotatingRight: Bool = false
    var maxRotationSpeed: CGFloat = 3
    var currentRotationSpeed: CGFloat = 0
    var rotationAcceleration: CGFloat = 0.16

    // Acceleration
    var isAccelerating: Bool = false
    var maxSpeed: CGFloat = 9
    var currentSpeed: CGFloat = 0
    var speedAcceleration: CGFloat = 0.16


    // General
    var decceleration: CGFloat = 0.85

    init(playerIndex: Int, imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.playerIndex = playerIndex
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
