//
//  ViewController.swift
//  NEFEnduro
//
//  Created by Include tech on 20/01/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import UIKit
import SnapKit
import iCarousel
import XCDYouTubeKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, iCarouselDelegate, iCarouselDataSource {

    let nefImageView = UIImageView()

    //Datasource
    let titleDict = ["Duo","Team","Solo"]
    let filterDict = ["duo","team","solo"]
    let imgDict = ["duoImage","teamImage","soloImage"]
    var type:String? = nil
    var animationController = AnimationController()
    
    var headerHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImageView = UIImageView(image: UIImage(named: "bgImage"))
        bgImageView.contentMode = .scaleAspectFill
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        collectionView.backgroundView = bgImageView
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Navigation Delegates
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let CategoryTableViewController = segue.destination as? CategoryTableViewController {
            
            animationController = CubeAnimationController()
            self.navigationController?.delegate = self;
            
            CategoryTableViewController.type = self.type!
            CategoryTableViewController.transitioningDelegate = self;
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let cubeAnimationController = CubeAnimationController()
        
        if operation == UINavigationControllerOperation.push  {
            cubeAnimationController.isPresenting = true
        } else {
            cubeAnimationController.isPresenting = false
        }
        return cubeAnimationController;
        
    }
    
    // MARK:- Collection View Data Source and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell 
        
        cell.topLabel.text = titleDict[indexPath.row]
        cell.bottomImage.image = UIImage(named: imgDict[indexPath.row])
        
        cell.bottomImage.layer.shadowOffset = CGSize(width: 0, height: 10)
        cell.bottomImage.layer.shadowColor = UIColor.black.cgColor
        cell.bottomImage.layer.shadowRadius = 4
        cell.bottomImage.layer.shadowOpacity = 0.75
        cell.bottomImage.layer.masksToBounds = false;
        cell.bottomImage.clipsToBounds = false;
        
        cell.tintColor = UIColor.blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath)
            
            let carouselView = iCarousel()
            carouselView.type = .linear
            carouselView.dataSource = self;
            carouselView.delegate = self;
            carouselView.isPagingEnabled = true
            headerView.addSubview(carouselView)
            carouselView.snp.makeConstraints({ (make) in
                make.left.right.top.bottom.equalTo(headerView)
            })
            return headerView
        
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath)
            
            let videoContainerView = UIView()
            videoContainerView.backgroundColor = UIColor.green
            footerView.addSubview(videoContainerView)
            videoContainerView.snp.makeConstraints({ (make) in
                make.left.right.bottom.top.equalTo(footerView)
            })
            
            let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: "0vd03koSsug")
            videoPlayerViewController.present(in: videoContainerView)
            videoPlayerViewController.moviePlayer.play()
            videoPlayerViewController.moviePlayer.scalingMode = .aspectFill
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        headerHeight = view.frame.height * 0.30
        return CGSize(width: UIScreen.main.bounds.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 291)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125);
    }
    
    
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.type = filterDict[indexPath.row]
        self.performSegue(withIdentifier: "toTableData", sender: self)
    }
    
    // MARK:- iCarousel Data Source and Delegate
    
    public func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        //Yet To be Decided
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.frame = containerView.frame
        imageView.clipsToBounds = true
        var image = UIImage()
        
        switch index {
        case 0:
            containerView.backgroundColor = UIColor.blue
            image =  UIImage(named: "carouselImage5")!
            break
        case 1:
            containerView.backgroundColor = UIColor.yellow
            image =  UIImage(named: "carouselImage2")!
            break
        case 2:
            containerView.backgroundColor = UIColor.purple
            image =  UIImage(named: "carouselImage3")!
            break
        case 3:
            containerView.backgroundColor = UIColor.purple
            image =  UIImage(named: "carouselImage4")!
            break
        case 3:
            containerView.backgroundColor = UIColor.purple
            image =  UIImage(named: "carouselImage1")!
            break
            
        default:
            break
        }
        imageView.image = image
        return containerView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        switch (option)
        {
        case .wrap:
            return 1
            
        default:
            return value
        }
    }

}

