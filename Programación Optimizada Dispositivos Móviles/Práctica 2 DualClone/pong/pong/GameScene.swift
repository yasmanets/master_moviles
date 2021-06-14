//
//  GameScene.swift
//  pong
//
//  Created by Yaser  on 4/5/21.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameScene: SKScene {
        
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var ball: SKSpriteNode?
    private var rival: SKSpriteNode?
    private var player: SKSpriteNode?
    private var leftWall: SKSpriteNode?
    private var rightWall: SKSpriteNode?
    
    private var topMarker: SKLabelNode?
    private var bottomMarker: SKLabelNode?
    private var info: SKLabelNode?
    
    private var startButton: SKLabelNode? = nil
    private var isStarted: Bool = false
    private var score = [Int]()
    
    private var isSent: Bool = false
    private let peerId = MCPeerID(displayName: UIDevice.current.name)
    private let SendDataServiceType = "send-pong"
    private var session: MCSession?
    private var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func didMove(to view: SKView) {
        
        self.ball = self.childNode(withName: "ball") as? SKSpriteNode
        self.rival = self.childNode(withName: "rival") as? SKSpriteNode
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        self.leftWall = self.childNode(withName: "leftWall") as? SKSpriteNode
        self.rightWall = self.childNode(withName: "rightWall") as? SKSpriteNode
        
        self.topMarker = self.childNode(withName: "topMarker") as? SKLabelNode
        self.bottomMarker = self.childNode(withName: "bottomMarker") as? SKLabelNode
        self.startButton = self.childNode(withName: "start") as? SKLabelNode
        self.info = self.childNode(withName: "info") as? SKLabelNode
        
        self.startButton?.text = "Iniciar conexión"
                
        self.ball?.isHidden = true
        self.rival?.isHidden = true
        self.player?.isHidden = true
        self.topMarker?.isHidden = true
        self.bottomMarker?.isHidden = true
        self.info?.isHidden = true
        
        self.session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        self.session?.delegate = self
    }
    
    func startGame(mode: String) {
        if self.session?.connectedPeers.count != 1 {
            showConnectionAlert()
        }
        else {
            if (mode == "notWaiting") {
                self.ball?.isHidden = false
                self.ball?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
                self.isSent = false
            }
            self.player?.isHidden = false
            self.topMarker?.isHidden = false
            self.bottomMarker?.isHidden = false
            self.startButton?.isHidden = true
            self.info?.isHidden = false
            
            self.score = [0,0]
            self.topMarker?.text = "\(score[1])"
            self.bottomMarker?.text = "\(score[0])"
        }
        
    }
    
    func showConnectionAlert(){
        let alertController = UIAlertController(title: "Conectar con otro dispositivo", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Establecer una sesión", style: .default, handler: startMultiPeer))
        alertController.addAction(UIAlertAction(title: "Unirse a una sesión", style: .default, handler: joinSession))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        let viewController: UIViewController = self.view?.window?.rootViewController as! GameViewController
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func startMultiPeer(action: UIAlertAction) {
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: self.SendDataServiceType, discoveryInfo: nil, session: self.session!)
        self.mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: self.SendDataServiceType, session: self.session!)
        mcBrowser.delegate = self
        
        let viewController: UIViewController = self.view?.window?.rootViewController as! GameViewController
        viewController.present(mcBrowser, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (self.startButton?.frame.contains(location) == true) {
                self.startGame(mode: "notWaiting")
            }
            self.player?.run(SKAction.moveTo(x: location.x, duration: 0.3))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            self.player?.run(SKAction.moveTo(x: location.x, duration: 0.3))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //self.rival?.run(SKAction.moveTo(x: (self.ball?.position.x)! + 5000, duration: 0.4))
        if ((self.ball?.position.y)! <= self.player!.position.y - 20) {
            addGoal(whoWons: self.rival!)
        }
        else if ((self.ball?.position.y)! >= self.frame.height - 10 && !self.isSent) {
            do {
                self.isSent = true
                let pointToSend: CGPoint = (self.ball?.position)!
                let pointData = NSCoder.string(for: pointToSend).data(using: .utf8)
                try self.session?.send(pointData! as Data, toPeers: self.session!.connectedPeers, with: .reliable)
                print("Se envía y isSent. \(isSent)")
            }
            catch let error as NSError {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                
                let viewController: UIViewController = self.view?.window?.rootViewController as! GameViewController
                viewController.present(alertController, animated: true)
            }
        }
    }
    
    func addGoal(whoWons: SKSpriteNode) {
        self.ball?.position = CGPoint.zero
        self.ball?.physicsBody?.velocity = CGVector.zero
        
        if whoWons == self.player {
            self.score[0] += 1
            self.ball?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        }
        else if whoWons == self.rival {
            self.score[1] += 1
            self.ball?.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
        }
        
        self.topMarker?.text = "\(score[1])"
        self.bottomMarker?.text = "\(score[0])"
    }
    
    private func checkDeviceLimits(point: CGPoint) -> CGPoint {
        var newPoint: CGPoint = point
        if point.x < self.frame.minX { newPoint.x = self.frame.minX }
        else if point.x > self.frame.maxY { newPoint.x = self.frame.maxX}
        //newPoint.y = self.frame.maxY
        return newPoint
    }
}

// MARK: - Extensiones necesarias de la clase
extension GameScene: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        OperationQueue.main.addOperation {
            self.info?.text = "Conectado a \(peerID.displayName)"
            self.startButton?.text = "Iniciar juego"
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.ball?.isHidden = false
        let point = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        let ballPoint = NSCoder.cgPoint(for: point! as String)
        self.ball?.position = self.checkDeviceLimits(point: ballPoint)
        self.ball?.physicsBody?.velocity = CGVector.zero
        self.ball?.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
        self.isSent = false
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension GameScene: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        self.startGame(mode: "waiting")
        self.startButton?.isHidden = true
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    
}
