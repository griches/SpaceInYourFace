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
    
    /// Creates a ship with an image and index, but does not add it to the screen
    /// - Parameter playerIndex: The player index to store for this ship, which can be used with the controller index to allow for each controller to control each ship
    func addShip(playerIndex: Int) -> Ship {
        let ship = Ship(playerIndex: playerIndex, imageNamed: "ship\(playerIndex)")
        return ship
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let ship = ships.first!

        ship.handleRotate()
        ship.handleMove()
    }
}

// MARK: Game Controller
extension GameScene {

    /// Sets up the NotificationCenter observers for the OS level connect and disconnect controller notifications
    func observeForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }

    /// Called by the notification `NSNotification.Name.GCControllerDidConnect`
    @objc func connectControllers() {
        print("Controller connected ✅")

        if let controller = GCController.controllers().first {

            controller.extendedGamepad!.valueChangedHandler = { (gamepad: GCExtendedGamepad, element: GCControllerElement) in
                // Add movement in here for sprites of the controllers
                self.controllerInputDetected(gamepad: gamepad, element: element, index: 0)
            }
        }
    }
    
    /// Called by the notification `NSNotification.Name.GCControllerDidDisconnect`
    @objc func disconnectControllers() {
        print("Controller disconnected ❌")
    }
    
    /// Called  when a value is changed on any connected controller. This is configured in `connectControllers`
    /// - Parameters:
    ///   - gamepad: The CGController that has had a value change
    ///   - element: The element, such as `.dpad` or `.buttonA`
    ///   - index: The index of the controller, which should correclate to the player number
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

// MARK: Extensions
extension CGFloat {
    
    /// An extension on CGFloat that takes a number that represents Degrees and converts it to Radians
    var radians: CGFloat {
        get {
            return self * .pi / 180
        }
    }
}
