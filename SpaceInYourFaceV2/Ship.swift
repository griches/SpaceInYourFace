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
    var movementDecceleration: CGFloat = 0.96
    var turningDecceleration: CGFloat = 0.85
    var shipSize: CGFloat = 100.0
    
    // Particles
    let particles = SKEmitterNode(fileNamed: "JetFire.sks")!
    let maxParticleBirthRate: CGFloat = 455
    
    /// Creates a ship with a player index and an image
    /// - Parameters:
    ///   - playerIndex: The player number, 0 based
    ///   - imageNamed: The image name of the ship to use
    init(playerIndex: Int, imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.playerIndex = playerIndex
        super.init(texture: texture, color: .clear, size: CGSize(width: shipSize, height: shipSize))
        
        particles.position = CGPoint(x: -(shipSize / 2), y: 0)
        let rotation: CGFloat = 90.0
        particles.zRotation = rotation.radians
        particles.particleBirthRate = 0
        
        addChild(particles)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the particle emitter to demonstrate how much thrust there is
    /// - Parameter value: A number in the range from 0 - 1. 0 will show no thrust, 1 will show full thrust
    private func engineThrust(value: CGFloat) {
        particles.particleBirthRate = maxParticleBirthRate * value
    }
    
    /// Handles the rotation of the ship, based on the previous controller input that has set the rotatingLeft or rotatingRight flags
    func handleRotate() {
        
        if isRotatingRight  {

            currentRotationSpeed -= rotationAcceleration
            if currentRotationSpeed <= -maxRotationSpeed {
                currentRotationSpeed = -maxRotationSpeed
            }
        }
        else if isRotatingLeft  {

            currentRotationSpeed += rotationAcceleration
            if currentRotationSpeed >= maxRotationSpeed {
                currentRotationSpeed = maxRotationSpeed
            }
        } else {
            currentRotationSpeed *= turningDecceleration
            if abs(currentRotationSpeed) < 0.1 {
                currentRotationSpeed = 0
            }
        }

        zRotation += currentRotationSpeed.radians
    }
    
    /// Handles the movement of the ship, based on the previous controller input that has set the isAccelerating flag
    func handleMove() {
        
        if isAccelerating {
            currentSpeed += speedAcceleration
            if currentSpeed > maxSpeed {
                currentSpeed = maxSpeed
            }
        }
        else {
            currentSpeed *= movementDecceleration
            if abs(currentSpeed) < 0.1 {
                currentSpeed = 0
            }
        }
        
        let speedX = cos(zRotation) * currentSpeed
        let speedY = sin(zRotation) * currentSpeed

        let currentX = position.x
        let currentY = position.y

        let newX = currentX + speedX
        let newY = currentY + speedY

        position = CGPoint(x: newX, y: newY)
        engineThrust(value: currentSpeed / maxSpeed)
        warpShipIfRequired()
    }
    
    
    /// Warp the ship to the other side of the screen if it goes off the edge
    private func warpShipIfRequired() {
        
        let halfShipSize = shipSize / 2
        
        // Warp X
        if position.x - halfShipSize < -shipSize * 2 {
            let newX = parent!.frame.width + halfShipSize
            position = CGPoint(x: newX, y: position.y)
        } else if position.x + halfShipSize > parent!.frame.width + (shipSize * 2) {
            let newX: CGFloat = 0 - halfShipSize
            position = CGPoint(x: newX, y: position.y)
        }
        
        // Warp Y
        if position.y - halfShipSize < -shipSize * 2 {
            let newY = parent!.frame.height + halfShipSize
            position = CGPoint(x: position.x, y: newY)
        } else if position.y + halfShipSize > parent!.frame.height + (shipSize * 2) {
            let newY: CGFloat = 0 - halfShipSize
            position = CGPoint(x: position.x, y: newY)
        }
    }
}
