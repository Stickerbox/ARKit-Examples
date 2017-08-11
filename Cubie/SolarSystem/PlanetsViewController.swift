//
//  PlanetsViewController
//  Planets
//
//  Created by Jordan.Dixon on 10/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlanetsViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "The Solar System",
                                   subtitle: "A totally scientifically accurate representation of the solar system",
                                   instance: PlanetsViewController.self)
    
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        planets.forEach { scene.rootNode.addChildNode($0) }
    }
    
    private var planets: [SCNNode] {
        
        let sun = createSphereNode(radius: 2.0, material: #imageLiteral(resourceName: "sun"), atZ: 4)
        let mercury = createSphereNode(radius: 0.1, material: #imageLiteral(resourceName: "mercury"), atZ: 2)
        let venus = createSphereNode(radius: 0.3, material: #imageLiteral(resourceName: "venus"), atZ: 0)
        let earth = createSphereNode(radius: 0.3, material: #imageLiteral(resourceName: "earth"), atZ: -1)
        let mars = createSphereNode(radius: 0.3, material: #imageLiteral(resourceName: "mars"), atZ: -2)
        let jupiter = createSphereNode(radius: 1.5, material: #imageLiteral(resourceName: "jupiter"), atZ: -5)
        let saturn = createSphereNode(radius: 1.0, material: #imageLiteral(resourceName: "saturn"), atZ: -8.5)
        let neptune = createSphereNode(radius: 0.2, material: #imageLiteral(resourceName: "neptune"), atZ: -10)
        let pluto = createSphereNode(radius: 0.05, material: #imageLiteral(resourceName: "pluto"), atZ: -14)
        
        return [sun, mercury, venus, earth, mars, jupiter, saturn, neptune, pluto]
    }
    
    private func createSphereNode(radius: CGFloat, material: UIImage, atZ zPosition: Float) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = material
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0.5, 0.1, zPosition)
        
        return sphereNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}

