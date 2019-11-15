//
//  GameScene.swift
//  SpaceInYourFaceV2
//
//  Created by devpair44 on 15/11/2019.
//  Copyright © 2019 Ford. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var ships = [Ship]()
    
    override func didMove(to view: SKView) {
        observeForGameControllers()
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)

        let ship0 = addShip(playerIndex: 0)
        ship0.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        addChild(ship0)
        ships.append(ship0)
    }

    func addShip(playerIndex: Int) -> Ship {
        let ship = Ship(playerIndex: playerIndex, imageNamed: "ship\(playerIndex)")
        return ship
    }

    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let ship = ships.first!

        // Rotate
        if ship.isRotatingRight  {

            ship.currentRotationSpeed -= ship.rotationAcceleration
            if ship.currentRotationSpeed <= -ship.maxRotationSpeed {
                ship.currentRotationSpeed = -ship.maxRotationSpeed
            }
        }
        else if ship.isRotatingLeft  {

            ship.currentRotationSpeed += ship.rotationAcceleration
            if ship.currentRotationSpeed >= ship.maxRotationSpeed {
                ship.currentRotationSpeed = ship.maxRotationSpeed
            }
        } else {
            ship.currentRotationSpeed *= ship.decceleration
            if abs(ship.currentRotationSpeed) < 0.1 {
                ship.currentRotationSpeed = 0
            }
        }

        // Move
        if ship.isAccelerating {
            ship.currentSpeed += ship.speedAcceleration
            if ship.currentSpeed > ship.maxSpeed {
                ship.currentSpeed = ship.maxSpeed
            }
        }
        else {
            ship.currentSpeed *= ship.decceleration
            if abs(ship.currentSpeed) < 0.1 {
                ship.currentSpeed = 0
            }
        }

        let speedX = cos(ship.zRotation) * ship.currentSpeed
        let speedY = sin(ship.zRotation) * ship.currentSpeed

        ship.zRotation += ship.currentRotationSpeed * .pi / 180

        let currentX = ship.position.x
        let currentY = ship.position.y

        let newX = currentX + speedX
        let newY = currentY + speedY

        ship.position = CGPoint(x: newX, y: newY)
    }
}

// Game Controller stuff
extension GameScene {

    func observeForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }

    @objc func connectControllers() {
        print("Controller connected ✅")

        if let controller = GCController.controllers().first {

            controller.extendedGamepad!.valueChangedHandler = { (gamepad: GCExtendedGamepad, element: GCControllerElement) in
                // Add movement in here for sprites of the controllers
                self.controllerInputDetected(gamepad: gamepad, element: element, index: 0)
            }
        }
    }

    @objc func disconnectControllers() {
        print("Controller disconnected ❌")
    }

    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {

        let ship = ships[index]

        if (gamepad.dpad == element)
        {
            let dpadValue = gamepad.dpad.xAxis.value

            if dpadValue == -1 {
                //Left
                ship.isRotatingLeft = true
                ship.isRotatingRight = false
            } else if dpadValue == 1 {
                //Right
                ship.isRotatingLeft = false
                ship.isRotatingRight = true
            } else {
                ship.isRotatingLeft = false
                ship.isRotatingRight = false
            }

//            player.rotationDirection = CGFloat(gamepad.dpad.xAxis.value)
//            if (gamepad.dpad.xAxis.value != 0)
//            {
//                player.isRotating = true
//            }
//            else if (gamepad.dpad.xAxis.value == 0)
//            {
//                player.isRotating = false
//            }
        }
        else if (gamepad.buttonA == element)
        {
            print("A")
            if (gamepad.buttonA.value != 0)
            {
                ship.isAccelerating = true
            }
            else if (gamepad.buttonA.value == 0)
            {
                ship.isAccelerating = false
            }
        }
    }
}

extension CGFloat {
    var radians: CGFloat {
        get {
            return self * .pi / 180
        }
    }
}
