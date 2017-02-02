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
import HFCardCollectionViewLayout

class CategoryTableViewController:  UICollectionViewController, HFCardCollectionViewLayoutDelegate, NavgationTransitionable {
    
    //Card Layout
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    /// Transiton delegate
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    var colorArray = [UIColor]()
    
    var shouldSetupBackgroundView = true
    var type:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.colorArray.insert(UIColor.red, at: 0)
        self.colorArray.insert(UIColor.blue, at: 1)
        self.colorArray.insert(UIColor.yellow, at: 2)

        navigationController?.isNavigationBarHidden = false
        self.collectionView?.register(ExampleCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        
        if let cardCollectionViewLayout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardCollectionViewLayout
        }
        
        view.backgroundColor = UIColor.red
        
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(self.popButtonTapped(button:)), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(40)
        }
    }

    // MARK: CollectionView
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canUnrevealCardAtIndex index: Int) -> Bool {
        if(self.colorArray.count == 1) {
            return false
        }
        return true
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(false)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ExampleCollectionViewCell
        cell.backgroundColor = self.colorArray[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempColor = self.colorArray[sourceIndexPath.item]
        self.colorArray.remove(at: sourceIndexPath.item)
        self.colorArray.insert(tempColor, at: destinationIndexPath.item)
    }
    
    func popButtonTapped(button : UIButton) -> Void {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
