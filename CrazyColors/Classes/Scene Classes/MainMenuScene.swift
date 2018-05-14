//
//  MainMenuScene.swift
//  CrazyColors
//
//  Created by christoffer wahlman on 2018-03-11.
//  Copyright © 2018 CWApplications. All rights reserved.
//

import SpriteKit
import StoreKit
import GoogleMobileAds


class MainMenuScene: SKScene, GADBannerViewDelegate {
   // var returnValue: [NSString]? = UserDefaults.standard.object(forKey: "HIGHSCORE") as? [NSString]
    private var itemController = ItemController();
    private var scoreLabel: SKLabelNode?
    private var backgroundMusic: SKAudioNode!
    private var clickSound: SKAudioNode!
    private var playButton: SKSpriteNode?
    private var rateButton: SKSpriteNode?
    private var bannerAd: GADBannerView?
    private var musicButton: SKSpriteNode?
    private var howtoplayButton: SKSpriteNode?
    private var musicOn = true;
   
    override func didMove(to view: SKView) {
        if let musicURL = Bundle.main.url(forResource: "backgroundmusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            print("backgroundsound activated")
            addChild(backgroundMusic)
            
        }
    
        let returnValueAudio = UserDefaults.standard.integer(forKey: "audio")
        if  returnValueAudio == 0 {
            backgroundMusic?.run(SKAction.changeVolume(to: Float(0),duration: 0));
            musicOn = false;
            musicButton?.texture = SKTexture(imageNamed:"audioOff.png")
        }else{
            backgroundMusic?.run(SKAction.changeVolume(to: Float(1.0),duration: 0));
            musicOn = true;
            musicButton?.texture = SKTexture(imageNamed:"audioOn.png")
        }
        
        if let clickURL = Bundle.main.url(forResource: "click3", withExtension: "wav") {
            clickSound = SKAudioNode(url: clickURL)
            clickSound.autoplayLooped = false;
            print("clicksound activated")
             addChild(clickSound)
            
        }
        initilizeGame();
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self);
            playButton?.texture = SKTexture(imageNamed:"red_button01.png")
            rateButton?.texture = SKTexture(imageNamed:"blue_button01.png")
            howtoplayButton?.texture = SKTexture(imageNamed:"green_button04.png")
            if atPoint(location).name == "Start" {
                
                if let scene = GamePlaySceneClass(fileNamed: "GamePlayScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene,transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
                }
            }else if atPoint(location).name == "HowToPlay" {
                if let scene = HowToPlaySceneClass(fileNamed: "HowToPlayScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene,transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
                }
            }else if atPoint(location).name == "Back" {
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene,transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
                }
            }else if atPoint(location).name == "Rate" {
                // Set the scale mode to scale to fit the window
                rateApp()

            }else if atPoint(location).name == "audioButton" {
                if(musicOn){
                    UserDefaults.standard.set(0, forKey: "audio")
                    backgroundMusic.run(SKAction.changeVolume(to: Float(0),duration: 0));
                    musicOn = false;
                    musicButton?.texture = SKTexture(imageNamed:"audioOff.png")
                }
            }else
                {
                    backgroundMusic.run(SKAction.changeVolume(to: Float(1.0),duration: 0));
                    musicOn = true;
                    musicButton?.texture = SKTexture(imageNamed:"audioOn.png")
                    UserDefaults.standard.set(1, forKey: "audio")
                }
                

            }
        }
        
        
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickSound.run(SKAction.play());
        
        for touch in touches {
            
            let location = touch.location(in: self);
            
            if atPoint(location).name == "Start" {
                      playButton?.texture = SKTexture(imageNamed:"red_button02.png")
            }
            else if atPoint(location).name == "Rate" {
                    rateButton?.texture = SKTexture(imageNamed:"blue_button05.png")
                
            }
            else if atPoint(location).name == "HowToPlay" {
                    howtoplayButton?.texture = SKTexture(imageNamed:"green_button05.png")
            }
    }
}

    
    override func update(_ currentTime: TimeInterval) {
        manageColorObject();
    }
    @objc func spawnItems(){
        
        self.scene?.addChild(itemController.spawnItems());
        
    }
    
    @objc func removeItems(){
        
        for child in children{
            if child.name == "Enemy1" || child.name == "Enemy2" || child.name == "Enemy3"  || child.name == "Enemy4"  || child.name == "Enemy5"  || child.name == "Enemy6"  || child.name == "Enemy7"  {
                if(child.position.y < -self.scene!.frame.height - 100){
                    child.removeFromParent()
                }
            }
        }
        
    }
    
    private func manageColorObject(){
        for child in children{
            if child.name == "Enemy1" || child.name == "Enemy2" || child.name == "Enemy3" || child.name == "Enemy4" || child.name == "Enemy5" || child.name == "Enemy6" || child.name == "Enemy7" {
                child.position.y -= 5;
            }
        }
        
    }
    private func rotateObject(){
        for child in children{
            if child.name == "Enemy1" || child.name == "Enemy2" || child.name == "Enemy3" || child.name == "Enemy4" || child.name == "Enemy5" || child.name == "Enemy6" || child.name == "Enemy7" {
                child.zRotation += 0.1
            }
        }
        
    }
    
    private func initilizeGame(){
        Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(MainMenuScene.spawnItems), userInfo: nil, repeats: true);
        
        Timer.scheduledTimer(timeInterval: TimeInterval(7), target: self, selector: #selector(MainMenuScene.removeItems), userInfo: nil, repeats: true)
        
        scoreLabel = childNode(withName: "highscorelabel") as? SKLabelNode;
        let returnValue = UserDefaults.standard.integer(forKey: "HIGHSCORE")
        scoreLabel?.text = "Highscore: " + String(returnValue);
        playButton = childNode(withName: "Start") as? SKSpriteNode
        rateButton = childNode(withName: "Rate") as? SKSpriteNode
        musicButton = childNode(withName: "audioButton") as? SKSpriteNode
        howtoplayButton = childNode(withName: "HowToPlay") as? SKSpriteNode
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAd"), object: nil)

    }

    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }

}
