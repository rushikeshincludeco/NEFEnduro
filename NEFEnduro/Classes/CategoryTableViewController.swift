//
//  CategoryTableViewController.swift
//  NEFEnduro
//
//  Created by Include tech on 21/01/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import SnapKit
import TransitionTreasury
import TransitionAnimation

class CategoryTableViewController: UIViewController, NavgationTransitionable{
    
    /// Transiton delegate
    var tr_pushTransition: TRNavgationTransitionDelegate?

    var type:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        
        view.backgroundColor = UIColor.red
        
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("POP", for: .normal)
        button.addTarget(self, action: #selector(self.popButtonTapped(button:)), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(40)
        }
    }

    func popButtonTapped(button : UIButton) -> Void {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
