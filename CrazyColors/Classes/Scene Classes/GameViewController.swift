//
//  GameViewController.swift
//  CrazyColors
//
//  Created by christoffer wahlman on 2018-03-11.
//  Copyright © 2018 CWApplications. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import Social

enum Colors {
    
    static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
    static let blue = UIColor.blue
    static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
    static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
    
}

enum Images {
    
    static let box = UIImage(named: "Box")!
    static let triangle = UIImage(named: "Triangle")!
    static let circle = UIImage(named: "Circle")!
    static let swirl = UIImage(named: "Spiral")!
    
}

class GameViewController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate {
    
    var scene: SKScene!
    
    var emitter = CAEmitterLayer()
    
    var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    
    var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
        Images.swirl
    ]
    
    var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
    @IBOutlet weak var adBannerView: GADBannerView!
    var testBanner: GADBannerView!;
    var gameScene: GamePlaySceneClass!
    var interstitialAD: GADInterstitial?

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenuScene(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false

        }
        interstitialAD = createAndLoadInterstitial()
        let bannerrequest = GADRequest()
        bannerrequest.testDevices = ["e69fd770b1a4f6d3aa71cf85ba549f89"]
        adBannerView.adUnitID = "ca-app-pub-1402220354446158/4226998787"
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        adBannerView.load(bannerrequest)
        self.view.isMultipleTouchEnabled = true;
        self.view.layer.addSublayer(emitter)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            for constraint in self.view.constraints {
                if constraint.identifier == "bannerHeight" {
                    constraint.constant = 500;
                }
            }
        }
    }
    public func stopEmitter(){
        emitter.birthRate = 0.0;
    }
    public func startEmitter(){
        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        emitter.emitterCells = generateEmitterCells()
         emitter.birthRate = 1.0;
        
    }
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            cells.append(cell)
        }
        return cells
    }
    func testShare(){
        // text to share
        let returnValue = UserDefaults.standard.integer(forKey: "CURRENTSCORE")
        let someText:String = "I just scored " + String(returnValue) + "! On Catch the Color! Can you beat it? Play at " + "https://itunes.apple.com/us/app/catch-the-colors/id1369256599?l=sv&ls=1&mt=8"
        
        let sharedObjects:[AnyObject] = ([someText] as AnyObject) as! [AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop,UIActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return colors[0].cgColor
        } else if i <= 8 {
            return colors[1].cgColor
        } else if i <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }

    public func showIntAd(){
        if (self.interstitialAD!.isReady){
            self.interstitialAD?.present(fromRootViewController: self)
            print("REKLAM SKA VISAS")
        }else {
            print("FEL MED REKLMAN")
        }
    }
    
    public func hideAd(){
        adBannerView.isHidden = true;
    }
    
    public func showAd(){
        adBannerView.isHidden = false;
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitaldidreceivead")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAD = createAndLoadInterstitial()
         print("REKLAM FUNKAR EJ ")
    }
    
    func createAndLoadInterstitial () -> GADInterstitial {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID,"e69fd770b1a4f6d3aa71cf85ba549f89"]
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1402220354446158/7509717067")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }

    func blurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
    }

    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
