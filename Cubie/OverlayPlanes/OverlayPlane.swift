//
//  OverlayPlane.swift
//  Cubie
//
//  Created by Jordan.Dixon on 10/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class OverlayPlane: SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    var material: UIImage
    
    init(anchor: ARPlaneAnchor, material: UIImage = #imageLiteral(resourceName: "mesh")) {
        self.anchor = anchor
        self.material = material
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        guard let planeNode = self.childNodes.first else { return }
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
    }
    
    private func setup() {
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = self.material
        
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
        
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        // the node is added vertically so we need to rotate it by 90 degrees so it's horizontal
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0)
        
        self.addChildNode(planeNode)
    }
}
