//
//  GameViewController.swift
//  Asteroids
//
//  Created by Miguel Angel Lozano Ortega on 02/01/2020.
//  Copyright © 2020 Miguel Angel Lozano Ortega. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
import CoreMotion

// TODO [D01] Definir enumeración con los estados del juego
public enum GameState {
    case Title
    case Introduction
    case Playing
    case GameOver
}

// TODO [B07] Implementar protocolo SCNSceneRendererDelegate
// TODO [C06] Implementar protocolo SCNPhysicsContactDelegate
class GameViewController: UIViewController, UIGestureRecognizerDelegate, SCNSceneRendererDelegate, SCNPhysicsContactDelegate  {

    // TODO [D02] Definir campo `gameState` con el estado actual del juego
    var gameState: GameState = .Title
    
    // MARK: - Escena, limites de la pantalla y sistema de control de movimiento
    var scene : SCNScene?
    var limits : CGRect = CGRect.zero
    var motion : CMMotionManager = CMMotionManager()

    // MARK: Elementos del HUD
    var hud : SKScene?
    var marcadorAsteroides : SKLabelNode?

    // MARK: Capas de titulo y gameover
    var titleGroup : SCNNode?
    var gameOverGroup : SCNNode?
    var gameOverResultsText : SCNText?
    
    // MARK: Sistema de camara
    var cameraNode : SCNNode?
    var cameraEulerAngle : SCNVector3?

    // MARK: Layering del sistema de fisicas
    let categoryMaskShip = 0b001 // (1)
    let categoryMaskShot = 0b010 // (2)
    let categoryMaskAsteroid = 0b100 // (4)
    let categoryMaskStar = 0b101 // 5

    // MARK: Nodos de la nave, asteroides y explosion
    var ship : SCNNode?
    var asteroidModel : SCNNode?
    var starModel: SCNNode?
    var explosion : SCNParticleSystem?

    // MARK: Efectos de sonido
    var soundExplosion : SCNAudioSource?
    var soundStar: SCNAudioSource?

    // MARK: Propiedades del juego
    var numAsteroides : Int = 0
    var velocity : Float = 0.0

    // MARK: Control de tiempos
    let spawnInterval : Float = 0.25
    let spawnIntervalStar: Float = 10.0
    var timeToSpawn : TimeInterval = 1.0
    var timeToSpawnStar : TimeInterval = 10.0
    var previousUpdateTime : TimeInterval?

    // MARK: - Eventos de inicializacion de la vista
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scnView = self.view as! SCNView

        // Creamos la escena
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        self.scene = scene
              
        // TODO [B03] Obtener el nodo "camara" de la escena, y almacenar su orientación original (eulerAngles)
        self.cameraNode = self.scene?.rootNode.childNode(withName: "camera", recursively: true)!
        self.cameraEulerAngle = self.cameraNode?.eulerAngles

        // TODO [B04] Obtener el nodo con la nave "ship" a partir de la escena
        self.ship = self.scene?.rootNode.childNode(withName: "ship", recursively: true)!

        // TODO [C11] Inicializamos efecto de particulas
        self.explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil)

        // TODO [D08] Inicializa las referencias a las pantallas de titulo, gameover
        self.titleGroup = self.cameraNode?.childNode(withName: "titleGroup", recursively: true)
        self.gameOverGroup = self.cameraNode?.childNode(withName: "gameOverGroup", recursively: true)
        self.gameOverResultsText = self.gameOverGroup?.childNode(withName: "gameOverResultsText", recursively: true)?.geometry as? SCNText

        // Inicializa los asteroides
        setupAsteroids(forView: scnView)
        
        // Se inicializa las estrellas
        setupStars(forView: scnView)
        
        // Inicializa el audio
        setupAudio(inScene: scene)
        
        // Configura la vista y pone en marcha el ciclo del juego
        setupView(scnView, withScene: scene)
        
        // Pone en marcha las lecturas de sensores y pantalla tactil
        startTapRecognition(inView: scnView)
        startMotionUpdates()

        // TODO [C07] Asignar esta clase como contactDelegate del mundo físico de la escena.
        self.scene?.physicsWorld.contactDelegate = self
        
        // Muestra la capa de la pantalla de titulo
        showTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let scnView = self.view as! SCNView
        
        setupLimits(forView: scnView)
        setupHUD(inView: scnView)
    }
    
    // MARK: - Metodos para la inicializacion de componentes
        
    func setupAudio(inScene scene: SCNScene) {
        // TODO [C15] Reproducir musica de fondo "rolemusic_step_to_space.mp3" en bucle, con volumen 0.1, y desde el nodo raiz de la escena.
        let audioSource = SCNAudioSource(fileNamed: "rolemusic_step_to_space.mp3")
        audioSource?.volume = 0.1
        audioSource?.loops = true
        let audio = SCNAction.playAudio(audioSource!, waitForCompletion: true)
        scene.rootNode.runAction(audio)
        
        // TODO [C16] Precarga el efecto bomb.wav, con volumen 10.0, y asignalo al campo soundExplosion
        let bombSource = SCNAudioSource(fileNamed: "bomb.wav")
        bombSource?.volume = 10.0
        bombSource?.load()
        self.soundExplosion = bombSource
        
        //Se precarga el sonido de la estrella
        let starSource = SCNAudioSource(fileNamed: "star.mp3")
        starSource?.volume = 10.0
        starSource?.load()
        self.soundStar = starSource
    }
    
    func setupAsteroids(forView view: SCNView) {
        // TODO [C01] Precarga el modelo de asteroide "asteroid" de rock.scn, asignalo al campo asteroidModel, y preparalo para su visualización en view
        let asteroidScene = SCNScene(named: "art.scnassets/rock.scn")
        self.asteroidModel = asteroidScene?.rootNode.childNode(withName: "asteroid", recursively: false)
        view.prepare(self.asteroidModel!, shouldAbortBlock: nil)
    }
    
    func setupStars(forView view: SCNView) {
        let starScene = SCNScene(named: "art.scnassets/star.scn")
        self.starModel = starScene?.rootNode.childNode(withName: "star", recursively: false)
        view.prepare(self.starModel!, shouldAbortBlock: nil)
    }
        
    func setupView(_ view: SCNView, withScene scene: SCNScene) {
        view.scene = scene
        view.allowsCameraControl = false
        view.showsStatistics = true
        view.backgroundColor = UIColor.black
        
        // TODO [B08] Asignar esta clase como delegado del renderer de la escena, y activar la propiedad `isPlaying` de la vista
        view.delegate = self
        view.isPlaying = true
    }

    func setupLimits(forView view: SCNView) {
        // TODO [B06] Calcular y almacenar en `self.limits` el rectángulo que defina los límites de la zona "jugable" dentro del plano XZ de la escena, donde la nave, disparos y asteroides se puedan mover sin salirse de los límites de la pantalla.
        let projectedOrigin = view.projectPoint(SCNVector3Zero)
        let unprojectedLeft = view.unprojectPoint(SCNVector3Make(0, projectedOrigin.y, projectedOrigin.z))
        let halfWidth = CGFloat(abs(unprojectedLeft.x))
        self.limits = CGRect(x: -halfWidth, y: -150, width: halfWidth*2, height: self.view.frame.maxY)
    }
    
    func setupHUD(inView view: SCNView) {
        // TODO [C13]
        //  - Crea una SKScene del tamaño de la vista y asignala a la capa overlaySKScene de la vista
        //  - Crea un SKLabel con cadena "0 HITS" con fuente University, de tamaño 36 y color naranja
        //  - Situa la etiqueta en la parte superior de la pantalla, centrada en la horizontal, haciendo que todo el texto quede visible en pantalla
        let skScene = SKScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        view.overlaySKScene = skScene
        
        let label = SKLabelNode(text: "0 HITS")
        label.fontName = "University"
        label.fontSize = 36
        label.fontColor = UIColor.orange
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: Double(view.frame.width / 2), y: Double(view.frame.maxY - view.safeAreaInsets.top))
        skScene.addChild(label)
        
        
        //  - Asigna la etiqueta y la escena a los siguientes campos:
        self.marcadorAsteroides = label
        self.hud = skScene
        self.hud?.isHidden = true
    }

    // MARK: - Metodos para la inicializacion de los controles
    
    func startTapRecognition(inView view: SCNView) {
        // TODO [B01] Programar un UITapGestureRecognizer y agregarlo a la vista (view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func startMotionUpdates() {
        // TODO [B02] Implementar el control mediante Core Motion
        //  - Comprobar en self.motion is Device Motion esta disponible
        //  - Programar el intervalo de refreso de Device Motion updates en 1.0 / 60.0
        //  - Comenzamos la lectura de Device Motion updates
        //  - Hacemos que el ángulo de giro "roll" sea la velocidad (self.velocity) de nuestra nave
        //  - Orientamos la cámara utilizando pitch (eulerAngles.x) y roll (eurlerAngles.z)
        if (self.motion.isDeviceMotionAvailable) {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotion, error) -> Void in
                if let roll = deviceMotion?.attitude.roll,
                    let pitch = deviceMotion?.attitude.pitch {
                    self.velocity = Float(roll)
                    if let cameraNode = self.cameraNode,
                        let euler = self.cameraEulerAngle {
                        cameraNode.eulerAngles.z = euler.z - Float(roll) * 0.1
                        cameraNode.eulerAngles.x = euler.x - Float(pitch - 0.75) * 0.1
                    }
                }
            })
        }
    }
    
    // MARK: - Metodos para los eventos del juego
    
    func spawnAsteroid(pos: SCNVector3) {
        // TODO [C02] Clonar el asteroide "asteroidModel", y asignar las siguiente propiedades:
        //  - Agregar el nuevo asteroide a la escena (nodo raiz)
        //  - Situarlo en pos
        //  - Hacer que se mueva hasta (pos.x, 0, limits.maxY) en 3 segundos
        //  - Hacer que al mismo tiempo el asteroide rote sobre un eje aleatorio, 10 radianes, en 3 segundos
        //  - Tras llegar a su posicion final, debera ser eliminado de la escena.
        if let asteroid = self.asteroidModel?.clone() {
            self.scene?.rootNode.addChildNode(asteroid)
            asteroid.position = pos
            let moveAction = SCNAction.moveBy(x: CGFloat(pos.x), y: 0, z: limits.maxY, duration: 3)
            let rotateAction = SCNAction.rotate(by: 10.0, around: SCNVector3.getRandom(), duration: 3)
            let sequence = SCNAction.sequence([moveAction, rotateAction, SCNAction.removeFromParentNode()])
            asteroid.runAction(sequence)
        }
    }
    
    func spawnStar(pos: SCNVector3) {
        if let star = self.starModel?.clone() {
            self.scene?.rootNode.addChildNode(star)
            star.position = pos
            let moveAction = SCNAction.moveBy(x: CGFloat(pos.x), y: 0, z: limits.maxY, duration: 25)
            let rotateAction = SCNAction.rotate(by: 10.0, around: SCNVector3.getRandom(), duration: 3)
            let sequence = SCNAction.sequence([moveAction, rotateAction, SCNAction.removeFromParentNode()])
            star.runAction(sequence)
        }
    }
    
    func shot() {
        // TODO [B05]
        //  - Creamos una forma de tipo esfera (`SCNSphere`) con radio 1.0
        //  - Le asignamos en su `firstMaterial`, tanto `diffuse` como `emission`, en su propiedad `contents` el color (`UIColor`) con RGB (0.8, 0.7, 0.2)
        let bulletConfig = SCNSphere(radius: 1.0)
        bulletConfig.firstMaterial?.diffuse.contents = UIColor(red: 0.8, green:0.7, blue:0.2, alpha: 1.0)
        bulletConfig.firstMaterial?.emission.contents = UIColor(red: 0.8, green:0.7, blue:0.2, alpha: 1.0)
        
        //  - Creamos la bala como un nodo `SCNNode` con la geometría de esfera anterior, dandole nombre "bullet", y ubicandola en la misma posicion que la nave.
        //  - Agregamos el nodo a la escena
        //  - Definimos una accion que mueva la bala 150 unidades negativas en el eje Z, y tras ello elimine la bala de la escena
        //  - Ejecutamos la accion sobre la bala
        let bullet = SCNNode(geometry: bulletConfig)
        bullet.position = self.ship!.position
        self.scene?.rootNode.addChildNode(bullet)
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: -150.0, duration: 1)
        let sequence = SCNAction.sequence([moveAction, SCNAction.removeFromParentNode()])
        bullet.runAction(sequence)

        // TODO [C05] Crear cuerpo fisica en la bala, de tipo kinematic, esfera de radio 1, con categoria "categoryMaskShot"
        bullet.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 1.0)))
        bullet.name = "bullet"
        bullet.categoryBitMask = self.categoryMaskShot
        bullet.physicsBody?.collisionBitMask = 4
    }
    
    func destroyStar(star: SCNNode) {
        star.removeFromParentNode()
        
        let emptyNode = SCNNode()
        emptyNode.position = star.position
        self.scene?.rootNode.addChildNode(emptyNode)
        let soundAction = SCNAction.playAudio(self.soundStar!, waitForCompletion: true)
        let sequence = SCNAction.sequence([soundAction, SCNAction.removeFromParentNode()])
        emptyNode.runAction(sequence)
    }
    
    func destroyAsteroid(asteroid: SCNNode, withBullet bullet: SCNNode) {
        showExplosion(onNode: asteroid)
        
        // TODO [C09] Elimina el asteroide y la bala de la escena
        asteroid.removeFromParentNode()
        bullet.removeFromParentNode()
        
        // TODO [C14]
        //  - Incrementa el numero de asteroides destruidos (numAsteroides) y actualiza el texto del marcadorAsteroides con "X HITS"
        self.numAsteroides += 1
        self.marcadorAsteroides?.text = "\(numAsteroides) HITS"
        
    }
    
    func destroyShip(ship: SCNNode, withAsteroid asteroid: SCNNode) {
        showExplosion(onNode: ship)

        // TOdO [C10] Elimina el asteroide, y haz que la nave salga despedida hacia atrás mientras rota alrededor de su eje Y.
        asteroid.removeFromParentNode()
        let moveAction = SCNAction.moveBy(x: 0, y: 50.0, z: 50.0, duration: 1)
        let rotateAction = SCNAction.rotate(by: 6.3, around: SCNVector3(0, 1, 0), duration: 1)
        let actionsGroup = SCNAction.group([moveAction, rotateAction])
        ship.runAction(actionsGroup)
        
        // TODO [D13] Llamamos a showGameOver()
        self.showGameOver()
    }
    
    func showExplosion(onNode node: SCNNode) {
        // TODO [C12] Agreegar el efecto de particulas explode a la escena en la posicion de node
        let translationMatrix = SCNMatrix4MakeTranslation(node.position.x, node.position.y, node.position.z)
        self.scene?.addParticleSystem(self.explosion!, transform: translationMatrix)
        
        // TODO [C17] Reproduce el sonido soundExplosion en la posicion de node
        let emptyNode = SCNNode()
        emptyNode.position = node.position
        self.scene?.rootNode.addChildNode(emptyNode)
        let soundAction = SCNAction.playAudio(self.soundExplosion!, waitForCompletion: true)
        let sequence = SCNAction.sequence([soundAction, SCNAction.removeFromParentNode()])
        emptyNode.runAction(sequence)
    }
        
    // MARK: - Metodos para cambio de estado
    
    func showTitle() {
        // TODO [D09]
        //  - Cambiar el estado a `Title`
        //  - Mostrar `titleGroup`
        //  - Ocultar `gameOverGroup`
        //  - Ocultar el HUD
        //  - Ocultar la nave
        self.gameState = .Title
        self.titleGroup?.isHidden = false
        self.gameOverGroup?.isHidden = true
        self.hud?.isHidden = true
        self.ship?.isHidden = true
    }
    
    func showGameOver() {
        // TODO [D12]
        //  - Cambiar el estado a `GameOver`
        //  - Ocultar el HUD
        //  - Mostrar 'gameOverGroup'
        self.gameState = .GameOver
        self.hud?.isHidden = true
        self.gameOverGroup?.isHidden = false
        
        //  - Poner en `gameOverResultsText` el texto "X ASTEROIDS DESTROYED"
        self.gameOverResultsText?.string = "\(numAsteroides) ASTEROIDS DESTROYED"
        
        //  - Inicializar la posición de `gameOverGroup en (0, 0, 0)
        //  - Inicializar la opacidad de `gameOverGroup a 1
        //  - Ejecutamos una acción que mueva `gameOverGroup` a (0, 0, -200) en 2 segundos, con modificador de tiempo `easeOut`, y tras ello haga un fadeout del nodo en 0.5 segundos y llame a showTitle() para volver al titulo.
        self.gameOverGroup?.position = SCNVector3(0.0, 0.0, 0.0)
        self.gameOverGroup?.opacity = 1
        let moveAction = SCNAction.move(to: SCNVector3(0, 0, -100), duration: 2)
        moveAction.timingMode = .easeOut
        let fadeOut = SCNAction.fadeOut(duration: 0.5)
        let sequence = SCNAction.sequence([moveAction, fadeOut])
        self.gameOverGroup?.runAction(sequence, completionHandler: {
            self.showTitle()
        })
    }
    
    
    func startGame() {
        // TODO [D10]
        //  - Cambiar el estado a `Introduction`
        //  - Ocultar `titleGroup`
        //  - Mostrar el HUD
        //  - Mostrar la nave
        self.gameState = .Introduction
        self.titleGroup?.isHidden = true
        self.hud?.isHidden = false
        self.ship?.isHidden = false
        
        //  - Poner a '0' el contador de asteroides destruidos
        //  - Poner como cadena vacía el texto del marcador de asteroides destruidos
        self.numAsteroides = 0
        self.marcadorAsteroides?.text = "\(numAsteroides) HITS"
        self.gameOverResultsText?.string = ""
        
        //  - Inicializar la posición de la nave en (0, 50, 50)
        //  - Ejecutamos una acción que mueva la nave a la posición (0, 0, 0) en un segundo y tras esto pase a estado a `Playing`
        self.ship?.position = SCNVector3(0, 50, 50)
        let moveAction = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 1)
        self.ship?.runAction(moveAction, completionHandler: {
            self.gameState = .Playing
        })
    }
    
    // MARK: - Eventos de SCNSceneRendererDelegate (bucle del juego)
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // TODO [B09] Calcular el delta time tomando como referencia previousUpdateTime, y actualizar previousUpdateTimelet
        let deltaTime = time - (previousUpdateTime ?? time)
        previousUpdateTime = time
        
        
        // TODO [D03] Solo generamos asteroides y movemos la nave en estado "Playing"
        if (self.gameState == .Playing) {
            // TODO [C03] Spawn de asteroides
            //  - Descontamos el deltatime de timeToSpawn, y cuando este llegue a 0 generamos un nuevo asteroide y restablecemos el valor de timeToSpawn a spawnInterval.
            //  - El asteroide debe generarse en una posicion X aleatoria entre los limites de la escena (limits.minX y limits.maxX), Y=0, y Z=limits.minY
            self.timeToSpawn -= deltaTime
            if (self.timeToSpawn <= 0) {
                let posX = Float.getRandom(from: Float(limits.minX), to: Float(limits.maxX))
                //spawnAsteroid(pos: SCNVector3(posX, 0, Float(limits.minY)))
                self.timeToSpawn = Double(self.spawnInterval)
            }
            
            self.timeToSpawnStar -= deltaTime
            if (self.timeToSpawnStar <= 0) {
                let posX = Float.getRandom(from: Float(limits.minX), to: Float(limits.maxX))
                spawnStar(pos: SCNVector3(posX, 0, Float(limits.minY)))
                self.timeToSpawnStar = Double(self.spawnIntervalStar)
            }
            
            // TODO [B10] Mueve la nave lateralmente a partir de `velocity * 200` y el deltatime, evita que se salga de los limites de pantalla (`limits`) y gira la nave en el eje Z según el valor de `velocity`
            let newPosition = (self.ship?.position.x)! + (self.velocity * 200 * Float(deltaTime))
            if (newPosition >= Float(limits.minX) && newPosition <= Float(limits.maxX)) {
                self.ship?.position.x = newPosition
            }
            self.ship?.eulerAngles = SCNVector3(0, 0, -velocity)
        }
    }
    
    // MARK: - Eventos de SCNPhysicsContactDelegate
    
    // TODO [C08] Definir el método `physicsWorld(:, didBegin:)` para detectar los contactos entre asteroides y balas o asteroides y la nave, y llamar a destroyShip() o destroyAsteroid() segun corresponda
    func onContact(asteroid: SCNNode, toNode node: SCNNode) {
        if(node.name == "ship") {
            destroyShip(ship: node, withAsteroid: asteroid)
        } else if(node.name == "bullet") {
            destroyAsteroid(asteroid: asteroid, withBullet: node)
        }
    }
    
    func onContactStar(star: SCNNode, toNode node: SCNNode) {
        if(node.name == "ship") {
            destroyStar(star: star)
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if(contact.nodeA.name == "asteroid") {
            onContact(asteroid: contact.nodeA, toNode: contact.nodeB)
        } else if(contact.nodeB.name == "asteroid") {
            onContact(asteroid: contact.nodeB, toNode: contact.nodeA)
        } else if(contact.nodeA.name == "star") {
            onContactStar(star: contact.nodeA, toNode: contact.nodeB)
        } else if(contact.nodeB.name == "star") {
            onContactStar(star: contact.nodeB, toNode: contact.nodeA)
        }
    }
    
    
    // MARK: - Eventos de la pantalla tactil
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // TODO [D04] Disparamos solo si el estado es "Playing"
        if (gameState == .Playing) {
            shot()
        }
        // TODO [D11] Si el estado es "Title", llamamos a "startGame()"
        if (self.gameState == .Title) {
            self.startGame()
        }
    }
    
    // MARK: - Orientación del controlador
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
