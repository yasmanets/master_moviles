//
//  ViewController.swift
//  VideoPlayer_swift
//
//  Created by Master Móviles on 9/11/16.
//  Copyright © 2016 Master Móviles. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class ViewController: UIViewController {

    var moviePlayerLayer : AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Bundle.main.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func videoPlaybackDidFinish(_ notification: Notification) {
        self.moviePlayerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.moviePlayerLayer = nil
        
    }
    
    @IBAction func playVideo1(_ sender: UIButton) {
        let videoPath = Bundle.main.path(forResource: "video", ofType: "m4v")
        let videoURL = URL.init(fileURLWithPath: videoPath!)

        // TODO (a.1) Reproducir video movieUrl con AVPlayerViewController
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: videoURL as URL)
        controller.player = player
        self.present(controller, animated: true) {
            controller.player?.play()
        }
        
        // TODO (a.2) Hacer que no se muestre ningún control de reproducción de video,
        // para evitar que el usuario pueda pasar el vídeo.
        controller.showsPlaybackControls = false
        
        // TODO (a.3) Hacer que el tamaño del reproductor se ajuste al girar la pantalla.
        controller.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //TODO (a.4) Utilizando las propiedades del AVPlayerViewController estableceremos los siguientes comportamientos en la reproducción:
            // 1. Hacer que el reeproductor entre en modo pantalla completa al iniciar la reproducción.
            // 2. Hacer que el reproductor salga del modo pantalla completa cuando termine la reproducción
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = true
    }

    @IBAction func playVideo2(_ sender: UIButton) {
        let videoPath = Bundle.main.path(forResource: "video", ofType: "m4v")
        let videoURL = URL.init(fileURLWithPath: videoPath!)

        // TODO (b.1) Reproducir video con AVPlayer + AVPlayerLayer
        // 1. Crear reproductor en self.moviePlayer a partir de movieUrl
        let player = AVPlayer(url: videoURL)
        moviePlayerLayer = AVPlayerLayer(player: player)
        // 2. Ajustar tamaño de la vista del reproductor (self.moviePlayer.frame) al tamaño de la vista actual (self.view.bounds)
        moviePlayerLayer?.frame = self.view.bounds
        // 3. Añadir a self.view la vista del reproductor (self.moviePlayer.view) como subvista
        self.view!.layer.addSublayer(moviePlayerLayer!)
        // 4. Comenzar la reproducción
        player.play()
        
        // TODO (b.2) Escucha notificación de finalizacion de la reproduccion (NotificationCenter.default.addObserver)
        // y llamar en ese caso a videoPlaybackDidFinish: para cerrar el reproductor
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlaybackDidFinish(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        // TODO (b.4) Personalizar el reproductor para que tenga como fondo un color lightGray. Deberemos manipular las propiedades del AVPlayerLayer
        self.moviePlayerLayer?.backgroundColor = UIColor.gray.cgColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            // TODO (b.3) Hacer que el tamaño del reproductor de AVPlayerLayer para que se ajuste al girar la pantalla.
            self.moviePlayerLayer?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
    }

}
 
