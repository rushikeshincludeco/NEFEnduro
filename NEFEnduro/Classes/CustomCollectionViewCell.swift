//
//  CustomCollectionViewCell.swift
//  NEF
//
//  Created by Include tech. on 13/01/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var topLabel = UILabel()
    var bottomImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        topLabel.font = UIFont(name: "ALoveofThunder", size: 30)
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.white
        contentView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        contentView.addSubview(bottomImage)
        bottomImage.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
