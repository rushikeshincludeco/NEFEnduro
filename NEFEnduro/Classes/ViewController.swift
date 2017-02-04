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
import TransitionTreasury
import TransitionAnimation
import HFCardCollectionViewLayout
import PDFReader


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NavgationTransitionable, iCarouselDelegate, iCarouselDataSource {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    let nefImageView = UIImageView()

    //Datasource
    let titleDict = ["Duo","Team","Solo","Map"]
    let filterDict = ["duo","team","solo",""]
    let imgDict = ["duoImage","teamImage","soloImage", ""]
    var type:String? = nil
    let videoPlayerViewController = XCDYouTubeVideoPlayerViewController()
    
    var headerHeight: CGFloat = 100
    var footerHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = view.frame.height * 0.35
        footerHeight = view.frame.height * 0.40

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
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.isScrollEnabled = false
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Couldn't set category!")
        }
        videoPlayerViewController.moviePlayer.play()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Collection View Data Source and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
            
            let rulesAndRegViewButton = UIButton()
            rulesAndRegViewButton.backgroundColor = UIColor.clear
            rulesAndRegViewButton.setTitle("Rules and Regulations", for: .normal)
            rulesAndRegViewButton.setTitleColor(UIColor.black, for: .normal)
            rulesAndRegViewButton.titleLabel?.font = UIFont(name: "ALoveofThunder", size: 16)
            rulesAndRegViewButton.addTarget(self, action: #selector(self.rulesAndRegAction(button:)), for: .touchUpInside)
            footerView.addSubview(rulesAndRegViewButton)
            rulesAndRegViewButton.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(footerView)
                make.height.equalTo(60)
            })
            
            let videoContainerView = UIView()
            videoContainerView.backgroundColor = UIColor.green
            footerView.addSubview(videoContainerView)
            videoContainerView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(footerView)
                make.top.equalTo(rulesAndRegViewButton.snp.bottom)
                make.bottom.equalTo(view)
            })
            
            videoPlayerViewController.videoIdentifier = "0vd03koSsug"
            videoPlayerViewController.present(in: videoContainerView)
            videoPlayerViewController.moviePlayer.play()
            videoPlayerViewController.moviePlayer.scalingMode = .fill
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.contentView.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let remainingHeight = view.frame.height - (headerHeight + footerHeight)
        if indexPath.row == 3 {
            return CGSize(width: self.view.frame.width, height: 20)
            
        } else {
            return CGSize(width: self.view.frame.width/3, height: remainingHeight);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            if indexPath.row != 3 {
                videoPlayerViewController.moviePlayer.stop()
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
                var layoutOptions = CardLayoutSetupOptions()
                vc.type = filterDict[indexPath.row]
                layoutOptions.numberOfCards  = 5
                vc.layoutOptions = layoutOptions

                let updateTransition: TRPushTransitionMethod = .omni(keyView: cell)
                navigationController?.tr_pushViewController(vc, method:updateTransition, statusBarStyle: .lightContent, completion: {
                    print("Pushed")
                })
            } else {
                videoPlayerViewController.moviePlayer.stop()
                
                let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                let updateTransition: TRPushTransitionMethod = .omni(keyView: cell)
                navigationController?.tr_pushViewController(mapViewController, method:updateTransition, statusBarStyle: .lightContent, completion: {
                    print("Pushed")
                })
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
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
    
    func rulesAndRegAction(button: UIButton) {
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RulesAndRegViewController") as! RulesAndRegViewController
        //        let updateTransition: TRPushTransitionMethod = .omni(keyView: button)
        //        navigationController?.tr_pushViewController(vc, method:updateTransition, statusBarStyle: .lightContent, completion: {
        //        })
        
        let documentURL = Bundle.main.url(forResource: "NECC NEF ENDURO - RuleBook 2017", withExtension: "pdf")!
        let document = PDFDocument(fileURL: documentURL)!
        let readerController = PDFViewController.createNew(with: document)
        navigationController?.pushViewController(readerController, animated: true)
        
    }
}

struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = 80
    var cardShouldExpandHeadHeight: Bool = true
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = 0
    var bottomNumberOfStackedCards: Int = 5
    var bottomStackedCardsShouldScale: Bool = true
    var bottomCardLookoutMargin: CGFloat = 10
    var bottomStackedCardsMaximumScale: CGFloat = 1.0
    var bottomStackedCardsMinimumScale: CGFloat = 0.94
    var spaceAtTopForBackgroundView: CGFloat = 0
    var spaceAtTopShouldSnap: Bool = true
    var spaceAtBottom: CGFloat = 0
    var scrollAreaTop: CGFloat = 120
    var scrollAreaBottom: CGFloat = 120
    var scrollShouldSnapCardHead: Bool = false
    var scrollStopCardsAtTop: Bool = true
    
    var numberOfCards: Int = 15
}
