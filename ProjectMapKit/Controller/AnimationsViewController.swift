//
//  AnimationsViewController.swift
//  
//
//  Created by Marcus Nilsson on 2020-03-13.
//

import UIKit

class AnimationsViewController: UIViewController {
    @IBOutlet weak var animationPin: UIImageView!
    @IBOutlet weak var animationTitle: UITextField!
    
    var animator: UIDynamicAnimator!
    var gravity: UIDynamicBehavior!
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides navigationbar
        self.navigationController?.isNavigationBarHidden = true
        //Start the animations
        animations()
    }
    func animations(){
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [animationPin])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [animationPin])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.animationTitle.transform = CGAffineTransform(translationX: 700, y: 0)
        }) { (_) in
            self.performSegue(withIdentifier: "toViewController", sender: Any?.self)
        }
    }
}
