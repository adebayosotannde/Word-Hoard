//
//  PurchaseViewController.swift
//  Word Hoard
//
//  Created by Adebayo Sotannde on 11/15/22.
//

import UIKit
import Lottie


class PurchaseViewController: UIViewController
{
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var animationView: AnimationView?
    
    @IBOutlet weak var backgroundAnimation: AnimationView!
    

    @IBAction func exitButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        startLottieAnimation()
        navigationBar.shadowImage = UIImage()
        
    }
    
    fileprivate func startLottieAnimation()
    {
        animationView?.play()
        animationView?.backgroundColor = .clear
        animationView?.loopMode = .loop
        
        backgroundAnimation?.play()
       backgroundAnimation?.backgroundColor = .clear
        backgroundAnimation?.loopMode = .loop
        backgroundAnimation.animationSpeed = 0.5
        
        //backgroundAnimation.contentMode = .redraw
      
        
        
    }
}
