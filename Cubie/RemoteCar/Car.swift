//
//  Car.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import Foundation
import SceneKit

class Car: SCNNode {
    var carNode: SCNNode
    
    init(node: SCNNode) {
        self.carNode = node
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addChildNode(carNode)
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.categoryBitMask = BodyType.car.rawValue
        self.physicsBody?.angularVelocityFactor = SCNVector3(0, 0, 0)

        carNode.name = "Car"
    }
    
    func accelerate() {
        
        let force = simd_make_float4(-30, 0, -1.0, 0)
        
        let rotatedForce = simd_mul(self.carNode.presentation.simdTransform, force)
        
        let vectorForce = SCNVector3(rotatedForce.x, rotatedForce.y, rotatedForce.z)
        
        self.carNode.physicsBody?.applyForce(vectorForce, asImpulse: false)
        
    }
    
    func turnLeft() {
        // x, y, z, force
        carNode.physicsBody?.applyTorque(SCNVector4(0, 1, 0, -1.0), asImpulse: false)
    }
    
    func turnRight() {
        carNode.physicsBody?.applyTorque(SCNVector4(0, 1, 0, 1.0), asImpulse: false)
    }
}
