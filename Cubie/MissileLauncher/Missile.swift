//
//  Missile.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Missile: SCNNode {
    
    private var scene: SCNScene!
    
    init(scene: SCNScene) {
        super.init()
        
        self.scene = scene
        
        setup()
    }
    
    init(middileNode: SCNNode) {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        guard let missileNode = self.scene.rootNode.childNode(withName: "missile", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "smoke", recursively: true)
            else {
                fatalError("Nodes not found")
        }
        
        let smoke = SCNParticleSystem(named: "smoke.scnp", inDirectory: nil)!
        smokeNode.addParticleSystem(smoke)
        
        self.addChildNode(missileNode)
        self.addChildNode(smokeNode)
    }

    func launch(missileNode: SCNNode) {
        
        guard let fireNode = self.scene.rootNode.childNode(withName: "fire", recursively: true) else { return }
        
        missileNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        missileNode.physicsBody?.isAffectedByGravity = false
        missileNode.physicsBody?.damping = 0.0 // we don't want the air friction to affect the missile
        missileNode.physicsBody?.applyForce(SCNVector3(0, 600, 0), asImpulse: false)
        
        let fire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)!
        fireNode.addParticleSystem(fire)
        
        self.addChildNode(fireNode)
    }
}
