
import Cocoa
import SceneKit
import SceneKit.ModelIO

class ViewController: NSViewController {
    
    var sceneView: SCNView {
        return self.view as! SCNView
    }
    
    func duplicateNode(_ node: SCNNode) -> SCNNode {
        let nodeCopy = node.copy() as? SCNNode ?? SCNNode()
        if let geometry = node.geometry?.copy() as? SCNGeometry {
            nodeCopy.geometry = geometry
            if let material = geometry.firstMaterial?.copy() as? SCNMaterial {
                nodeCopy.geometry?.firstMaterial = material
            }
        }
        return nodeCopy
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = NSColor.lightGray

        let assetURL = Bundle.main.url(forResource: "teapot", withExtension: "obj")!
        let asset = MDLAsset(url: assetURL)
        let teapotNode = SCNNode(mdlObject: asset.childObjects(of: MDLMesh.self).first!)
        scene.rootNode.addChildNode(teapotNode)
        
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        cameraNode.camera = camera
        sceneView.pointOfView = cameraNode
        camera.fieldOfView = 40
        sceneView.pointOfView?.position = SCNVector3(-6, 7, -8)
        sceneView.pointOfView?.look(at: SCNVector3(0, 0, 0))

        teapotNode.geometry?.firstMaterial?.diffuse.contents = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        teapotNode.geometry?.firstMaterial?.specular.contents = NSColor.white
        teapotNode.geometry?.firstMaterial?.shininess = 25
        teapotNode.geometry?.firstMaterial?.lightingModel = .phong
        
        let spin = SCNAction.repeatForever(SCNAction.rotate(by: 2 * .pi, around: SCNVector3(0, 1, 0), duration: 3.0))
        teapotNode.runAction(spin)

        let outlineNode = duplicateNode(teapotNode)
        scene.rootNode.addChildNode(outlineNode)

        let outlineProgram = SCNProgram()
        outlineProgram.vertexFunctionName = "outline_vertex"
        outlineProgram.fragmentFunctionName = "outline_fragment"
        outlineNode.geometry?.firstMaterial?.program = outlineProgram
        outlineNode.geometry?.firstMaterial?.cullMode = .front
    }
}
