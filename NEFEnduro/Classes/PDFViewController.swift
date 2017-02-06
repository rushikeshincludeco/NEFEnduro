//
//  PDFViewController.swift
//  NEFEnduro
//
//  Created by Include tech on 06/02/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import UXMPDFKit
import TransitionTreasury
import TransitionAnimation

class PDFViewController: UIViewController, NavgationTransitionable {

    @IBOutlet var collectionView:PDFSinglePageViewer!
    /// Transiton delegate
    var tr_pushTransition: TRNavgationTransitionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentURL = Bundle.main.url(forResource: "NECC NEF ENDURO - RuleBook 2017", withExtension: "pdf")!
        let document = try! PDFDocument(filePath: documentURL.path, password: "")
        
        self.collectionView.document = document
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = "Rules & Regulation"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
