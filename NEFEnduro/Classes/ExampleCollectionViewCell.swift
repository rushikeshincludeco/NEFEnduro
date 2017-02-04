//
//  ExampleCollectionViewCell.swift
//  HFCardCollectionViewLayoutExample
//
//  Created by Hendrik Frahmann on 02.11.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import UIKit
import QuartzCore
import HFCardCollectionViewLayout

class ExampleCollectionViewCell: HFCardCollectionViewCell {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    @IBOutlet weak var buttonFlip: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelFees: UILabel!
    @IBOutlet weak var labelPrize: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelSummary: UILabel!

    var backView: UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonFlip?.isHidden = true
        self.tableView?.scrollsToTop = false
        
        labelText.font = UIFont(name: "ALoveofThunder", size: 18)
        self.labelText.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelText.numberOfLines = 0
        self.labelText.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(60)
            make.top.equalTo(contentView).offset(5)
        }
        
        self.buttonFlip.snp.makeConstraints { (make) in
            make.left.right.equalTo(labelText)
            make.height.width.equalTo(20)
            make.top.equalTo(self.labelText.snp.bottom).offset(10)
        }
        
        labelDesc.font = UIFont(name: "Roboto-Black", size: 15)
        self.labelDesc.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelDesc.numberOfLines = 0
        self.labelDesc.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(150)
            make.top.equalTo(buttonFlip.snp.bottom).offset(10)
        }
        
        labelType.font = UIFont(name: "Roboto-Black", size: 15)
        self.labelType.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelType.numberOfLines = 0
        self.labelType.snp.makeConstraints { (make) in
            make.left.right.equalTo(labelText)
            make.height.equalTo(30)
            make.top.equalTo(labelDesc.snp.bottom).offset(10)
        }
        
        labelFees.font = UIFont(name: "Roboto-Black", size: 15)
        self.labelFees.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelFees.numberOfLines = 0
        self.labelFees.snp.makeConstraints { (make) in
            make.left.right.equalTo(labelText)
            make.height.equalTo(30)
            make.top.equalTo(labelType.snp.bottom).offset(10)
        }
        
        labelPrize.font = UIFont(name: "Roboto-Black", size: 15)
        self.labelPrize.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelPrize.numberOfLines = 0
        self.labelPrize.snp.makeConstraints { (make) in
            make.left.right.equalTo(labelText)
            make.height.equalTo(100)
            make.top.equalTo(labelFees.snp.bottom).offset(10)
        }
        
        labelSummary.font = UIFont(name: "Roboto-Black", size: 15)
        self.labelSummary.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.labelSummary.numberOfLines = 0
        self.labelSummary.snp.makeConstraints { (make) in
            make.left.right.equalTo(labelText)
            make.height.equalTo(50)
            make.top.equalTo(labelPrize.snp.bottom).offset(10)
        }
    
    }
    
    func cardIsRevealed(_ isRevealed: Bool) {
        self.buttonFlip?.isHidden = !isRevealed
        self.tableView?.scrollsToTop = isRevealed
    }
    
    @IBAction func buttonFlipAction() {
        if let backView = self.backView {
            // Same Corner radius like the contentview of the HFCardCollectionViewCell
            backView.layer.cornerRadius = self.cornerRadius
            backView.layer.masksToBounds = true
            
            self.cardCollectionViewLayout?.flipRevealedCard(toView: backView)
        }
    }
}
