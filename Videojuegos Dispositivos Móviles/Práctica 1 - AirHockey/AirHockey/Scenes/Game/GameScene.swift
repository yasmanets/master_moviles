//
//  GameScene.swift
//  AirHockey
//
//  Created by Miguel Angel Lozano Ortega on 02/08/2019.
//  Copyright © 2019 Miguel Angel Lozano Ortega. All rights reserved.
//

import SpriteKit
import GameplayKit

// TODO [D04] Implementa el protocolo `SKPhysicsContactDelegate`
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Referencias a nodos de la escena
    private var paddleBottom : SKSpriteNode?
    private var paddleTop : SKSpriteNode?
    private var puck : SKSpriteNode?
    private var scoreboardBottom : SKLabelNode?
    private var scoreboardTop : SKLabelNode?

    // MARK: Marcadores de los jugadores
    private var scoreBottom : Int = 0
    private var scoreTop : Int = 0
    private let maxScore = 9

    // MARK: Colores de los jugadores
    private let colorTop = #colorLiteral(red: 1, green: 0.2156862766, blue: 0.3725490272, alpha: 1)
    private let colorBotton = #colorLiteral(red: 0.3727632761, green: 0.3591359258, blue: 0.8980184197, alpha: 1)
    
    // MARK: Categorias de los objetos fisicos
    private let paddleCategoryMask : UInt32 = 0b0001
    private let puckCategoryMask : UInt32 = 0b0010
    private let limitsCategoryMask : UInt32 = 0b0100
    private let midfieldCategoryMask : UInt32 = 0b1000

    // MARK: Efectos de sonido
    // TODO [D02] Crear acciones para reproducir "goal.wav" y "hit.wav"
    private let actionSoundGoal = SKAction.playSoundFileNamed("goal.wav", waitForCompletion: false)
    private let actionSoundHit = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false)

    // MARK: Mapa de asociacion de touches con palas
    private var activeTouches : [UITouch : SKNode] = [:]
    
    
    // MARK: - Inicializacion de la escena
    
    override func didMove(to view: SKView) {
        
        // TODO [B04] Obten las referencias a los nodos de la escena
        self.paddleTop = childNode(withName: "paddleTop") as? SKSpriteNode
        self.paddleBottom = childNode(withName: "paddleBottom") as? SKSpriteNode
        self.puck = childNode(withName: "puck") as? SKSpriteNode
        self.scoreboardTop = childNode(withName: "score_top") as? SKLabelNode
        self.scoreboardBottom = childNode(withName: "score_bottom") as? SKLabelNode
        
        // TODO [D05] Establece esta clase como el contact delegate del mundo fisico de la escena
        self.physicsWorld.contactDelegate = self
        
        self.createSceneLimits()
        self.updateScore()
    }
    
    func createSceneLimits() {
        // TODO [C03] Define los limites del escenario como un cuerpo físico con forma edge loop de las dimensiones de la escena
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // TODO [C11] Define los limites del escenario dejando los huecos de las porterias. Puedes utilizar dos cuerpos que definan cada uno de los laterales del escenario a partir de un path, y combinarlos en un unico cuerpo compuesto.
        
        // Lado derecho del tablero
        let bottomRight = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        let topRight = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        let goalWidth = self.frame.width / 2
        let goalBottomRight = CGPoint(x: self.frame.origin.x + (self.frame.width + goalWidth) / 2, y: self.frame.minY)
        let goalTopRight = CGPoint(x: self.frame.origin.x + (self.frame.width + goalWidth) / 2, y: self.frame.maxY)
        let pathRight = CGMutablePath()
        pathRight.addLines(between: [goalTopRight, topRight, bottomRight, goalBottomRight])
        let bodyRight = SKPhysicsBody(edgeChainFrom: pathRight)
        
        // Lado izquierdo del tablero
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY)
        let topLeft = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        let goalBottomLeft = CGPoint(x: self.frame.origin.x + (self.frame.width - goalWidth) / 2, y: self.frame.minY)
        let goalTopLeft = CGPoint(x: self.frame.origin.x + (self.frame.width - goalWidth) / 2, y: self.frame.maxY)
        let pathLeft = CGMutablePath()
        pathLeft.addLines(between: [goalTopLeft, topLeft, bottomLeft, goalBottomLeft])
        let bodyLeft = SKPhysicsBody(edgeChainFrom: pathLeft)

        // Cuerpo físico de la escena
        self.physicsBody = SKPhysicsBody(bodies: [bodyLeft, bodyRight])
        self.physicsBody?.isDynamic = false
        
        // TODO [C12] Dibuja las dos porterias (rectangulos) y la linea de medio campo mediante nodos SKShapeNode
        let goalSideSize = goalTopRight.x - goalTopLeft.x
        // Portería superior
        let goalTopRect = SKShapeNode(rect: CGRect(x: goalTopLeft.x, y: self.frame.maxY - (goalSideSize / 2), width: goalSideSize, height: goalSideSize))
        goalTopRect.strokeColor = self.colorTop
        goalTopRect.zPosition = 0
        
        //Portería inferior
        let goalBottomRect = SKShapeNode(rect: CGRect(x: goalBottomLeft.x, y: self.frame.minY - (goalSideSize / 2), width: goalSideSize, height: goalSideSize))
        goalBottomRect.strokeColor = self.colorBotton
        goalBottomRect.zPosition = 0
        
        // Medio del campo
        let middleLine = CGMutablePath()
        middleLine.addLines(between: [CGPoint(x: self.frame.minX, y: 0), CGPoint(x: self.frame.maxX, y: 0)])
        let middleNode = SKShapeNode()
        middleNode.path = middleLine
        middleNode.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        middleNode.zPosition = 0
        
        self.scene?.addChild(goalTopRect)
        self.scene?.addChild(goalBottomRect)
        self.scene?.addChild(middleNode)
        
        // TODO [C13] Define limites fisicos para cada uno de los dos campos de juego, y asocialos a nodos de la escena.
        let bottomLimit = SKPhysicsBody(edgeLoopFrom: CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height / 2))
        let topLimit = SKPhysicsBody(edgeLoopFrom: CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: self.frame.height - (self.frame.height / 2)))
        goalBottomRect.physicsBody = bottomLimit
        goalTopRect.physicsBody = topLimit
        
        // TODO [C14] Asigna los cuerpos fisicos de limites de la escena y de cada campo su correspondiente categoria (categoryBitMask). En caso de cuerpos compuestos, solo es necesaria asociarla al cuerpo "padre"
        goalBottomRect.physicsBody?.categoryBitMask = self.limitsCategoryMask
        goalTopRect.physicsBody?.categoryBitMask = self.limitsCategoryMask
        middleNode.physicsBody?.categoryBitMask = self.midfieldCategoryMask
        
    }

    // MARK: - Metodos del ciclo del juego
    
    override func update(_ currentTime: TimeInterval) {
        // TODO [D01] Comprobamos si alguno de los jugadores ha metido gol (si la posición y del disco es superior a frame.maxY o inferior a frame.minY)
        //  - Incrementa la puntuacion del jugador correspondiente
        //  - Define el punto de regeneracion del disco (en la mitad del campo del jugador contrario)
        //  - Llama a `goal` indicando los datos del marcador que debe resaltar, el texto a mostrar en pantalla en caso de ganar la partida, su color, y el punto de regeneracion del disco.
        if ((self.puck?.position.y)! > self.frame.maxY || (self.puck?.position.y)! < self.frame.minY) {
            if ((self.puck?.position.y)! > self.frame.maxY) {
                let spawnPos = CGPoint(x: self.frame.midX, y: self.frame.origin.y + self.frame.size.height * 0.75)
                self.scoreBottom += 1
                goal(score: self.scoreBottom, marcador: self.scoreboardBottom!, textoWin: "BLUE WINS!", colorTexto: self.colorBotton, spawnPos: spawnPos)
            }
            else {
                let spawnPos = CGPoint(x: self.frame.midX, y: self.frame.origin.y + self.frame.size.height * 0.25)
                self.scoreTop += 1
                goal(score: self.scoreTop, marcador: self.scoreboardTop!, textoWin: "RED WINS!", colorTexto: self.colorTop, spawnPos: spawnPos)
            }
        }
    }

    func updateScore() {
        // TODO [B05] Poner como texto de las etiquetas scoreboardTop y scoreboardBottom los valores scoreTop y scoreBottom respectivamente
        self.scoreboardTop?.text = String(self.scoreTop)
        self.scoreboardBottom?.text = String(self.scoreBottom)
    }
    
    func resetPuck(pos : CGPoint) {
        // TODO [D08]
        //  - Situa el disco "puck" en pos
        self.puck?.position = pos
        //  - Escalalo a 4.0
        self.puck?.run(SKAction.scale(to: 4.0, duration: 0))
        //  - Pon la velocidad lineal y angular de su cuerpo físico a 0
        self.puck?.physicsBody?.angularDamping = 0
        self.puck?.physicsBody?.linearDamping = 0
        //  - Ejecuta una acción que lo escale a 1.0 durante 0.25s
        self.puck?.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
    
    func goToTitle() {
        // TODO [D10] Cargamos la escena `MenuScene`, con modo aspectFill, y la presentamos mediante ua transicion de tipo `flipHorizontal` que dure 0.25s.
        if let scene = SKScene(fileNamed: "MenuScene"),
           let view = self.view
        {
            view.presentScene(scene, transition: SKTransition.flipHorizontal(withDuration: 0.25))
        }
    }

    func goal(score: Int, marcador: SKLabelNode, textoWin : String, colorTexto : UIColor, spawnPos: CGPoint) {
        // TODO [D03] Reproducir sobre la escena la acción `actionSoundGoal`
        self.run(actionSoundGoal)
        updateScore()
                
        // TODO [D07]
        //  - Crear una acción que repita 3 veces: escalar a 1.2 durante 0.1s, escalar a 1.0 durante 0.01s
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.01)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        let scaleRepeat = SKAction.repeat(scaleSequence, count: 3)
        marcador.run(scaleRepeat, withKey: "scaleAction")
        //  - Llamar a resetPuck proporcionando la posiciom de respawn
        self.resetPuck(pos: spawnPos)
                
        
        // TODO [D09]
        //  - Comprobamos si el score ha alcanzado maxScore, en tal caso la partida ha terminado
        //  - Si la partida ha terminado, no mostraremos la accion del marcador ni resetearemos el disco, en su lugar:
        //      - Obtenemos de la escena la etiqueta "//label_wins", ponemos como color de fuente el colorTexto recibido, como texto el textoWin recibido, y hacemos que se muestre (propiedad isHidden)
        //      - Eliminamos el disco de la escena (eliminandolo de su nodo padre) y lo ponemos a nil
        //      - Ejecutamos una accion que repita 3 veces: escalar a 1.2 durante 0.5s, escalar a 1.0 durante 0.5s, y tras las 3 repeticiones, que ejecute goToTitle().
        if (score == self.maxScore) {
            marcador.removeAction(forKey: "scaleAction")
            self.puck?.removeFromParent()

            let label = childNode(withName: "label_wins") as? SKLabelNode
            label?.color = colorTexto
            label?.text = textoWin
            label?.isHidden = false
            
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            let repeatSequence = SKAction.repeat(scaleSequence, count: 3)
            label?.run(repeatSequence, completion: {
                self.goToTitle()
            })
        }
    }
    
    
    // MARK: - Eventos de la pantalla tactil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(withTouch: t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(withTouch: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(withTouch: t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(withTouch: t) }
    }
    
    func touchDown(withTouch t : UITouch) {
        // TODO [C05]
        //  - Obten las coordenadas de t en la escena
        //  - Comprueba si hay algun nodo en dichas coordenadas
        //  - Si hay un nodo, y es paddleTop o paddleBottom, asocia a dicho nodo mediante el diccionario self.activeTouches.
        let coordinates = t.location(in: self.scene!)
        let node = atPoint(coordinates)
        if (node.isEqual(to: self.paddleTop!) || node.isEqual(to: self.paddleBottom!)) {
            self.activeTouches[t] = createDragNode(linkedTo: node)
        }
        
        // TODO [C09] En lugar de asociar en self.activeTouches el nodo encontrado a t, llama a createDragNode(linkedTo:) para crear un nuevo nodo conectado a la pala, y asocia dicho nodo al touch
        
    }
    
    func touchMoved(withTouch t : UITouch) {
        // TODO [C06]
        //  - Obten las coordenadas de t en la escena
        //  - Comprueba si hay algun nodo vinculado a t en self.activeTouches
        //  - Si es asi, mueve el nodo a la posicion de t
        let coordinates = t.location(in: self.scene!)
        if let node = self.activeTouches[t] {
            node.position = coordinates
        }
        
    }
    
    func touchUp(withTouch t : UITouch) {
        // TODO [C07]
        //  - Elimina la entrada t del diccionario self.activeTouches.
        //self.activeTouches.removeValue(forKey: t)
        
        // TODO [C10] Comprueba si hay algun nodo vinculado a t, y en tal caso eliminalo de la escena
        if let node = self.activeTouches[t] {
            node.removeFromParent()
            self.activeTouches.removeValue(forKey: t)
        }
    }
    
    func createDragNode(linkedTo paddle: SKNode) -> SKNode {
        // TODO [C08]
        //  - Crea un nodo de tipo forma circular con radio `20`, situado en la posición del nodo paddle, añadelo a la escena.
        let node = SKShapeNode(circleOfRadius: 20.0)
        node.position = paddle.position
        self.scene?.addChild(node)
        //  - Asocia a dicho nodo un cuerpo físico estático, y desactiva su propiedad `isUserInteractionEnabled`
        node.physicsBody = SKPhysicsBody(edgeLoopFrom: node.frame)
        node.isUserInteractionEnabled = false
        //  - Crea una conexión de tipo `SKPhysicsJointSpring` que conecte el nodo creado con paddle, con frequency 100.0 y damping 10.0.
        let springJoin = SKPhysicsJointSpring.joint(withBodyA: paddle.physicsBody!, bodyB: node.physicsBody!, anchorA: paddle.position, anchorB: node.position)
        springJoin.frequency = 100.0
        springJoin.damping = 10.0
        //  - Agrega la conexión al `physicsWorld` de la escena.
        self.physicsWorld.add(springJoin)
        
        //  - Devuelve el nodo que hemos creado
        return node
    }
    
    
    // MARK: - Metodos de SKPhysicsContactDelegate
    
    // TODO [D06] Define el método didBegin(:). En caso de que alguno de los cuerpos que intervienen en el contacto sea el disco (' puck'), reproduce el audio `actionSoundHit`
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name == "puck" || contact.bodyB.node?.name == "puck") {
            self.run(actionSoundHit)
        }
    }

}
