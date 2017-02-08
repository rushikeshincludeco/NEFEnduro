////
////  CategoryTableViewController.swift
////  NEFEnduro
////
////  Created by Include tech on 21/01/17.
////  Copyright © 2017 Include tech. All rights reserved.
////
//
//import UIKit
//import SnapKit
//import TransitionTreasury
//import TransitionAnimation
//import HFCardCollectionViewLayout
//
//class CategoryTableViewController:  UICollectionViewController, HFCardCollectionViewLayoutDelegate, NavgationTransitionable {
//    
//    //Card Layout
//    var cardCollectionViewLayout: HFCardCollectionViewLayout?
//    var layoutOptions = CardLayoutSetupOptions()
//
//
//    /// Transiton delegate
//    var tr_pushTransition: TRNavgationTransitionDelegate?
//    var shouldSetupBackgroundView = true
//    var type:String? = nil
//    var finalResult : [[String:AnyObject]] = []
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        readFromJson()
//        layoutOptions.cardHeadHeight = 300
//
//        if let cardCollectionViewLayout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
//            self.cardCollectionViewLayout = cardCollectionViewLayout
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setNavigationBarHidden(false, animated:false)
//    }
//    // MARK: CollectionView
//    
//    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canUnrevealCardAtIndex index: Int) -> Bool {
//        if(self.finalResult.count == 1) {
//            return false
//        }
//        return true
//    }
//    
//    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
//        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
//            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
//            cell.cardIsRevealed(true)
//        }
//    }
//    
//    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
//        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
//            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
//            cell.cardIsRevealed(false)
//        }
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.finalResult.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ExampleCollectionViewCell
//        cell.labelText?.text = String("Name: ")?.appending(finalResult[indexPath.row]["name"] as! String)
//        let desc = String("Description: ")?.appending(finalResult[indexPath.row]["desc"] as! String)
//        cell.labelDesc?.text = desc?.replacingOccurrences(of: ". ", with: ".\n")
//        cell.labelFees?.text = String("Fees: ")?.appending(finalResult[indexPath.row]["fees"] as! String)
//        cell.buttonFlip.addTarget(self, action: #selector(self.popButtonTapped(button:)), for: .touchUpInside)
//        let prize = String("Prize: ")?.appending(finalResult[indexPath.row]["prize"] as! String)
//        cell.labelPrize?.text = prize?.replacingOccurrences(of: "|", with: "\n")
//        cell.labelSummary?.text = String("Summary: ")?.appending(finalResult[indexPath.row]["summary"] as! String)
//        cell.labelType?.text = String("Type: ")?.appending(finalResult[indexPath.row]["type"] as! String)
//        cell.buttonFlip.addTarget(self, action: #selector(CategoryTableViewController.toMapView), for: .touchUpInside)
//        
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let tempResult = self.finalResult[sourceIndexPath.item]
//        self.finalResult.remove(at: sourceIndexPath.item)
//        self.finalResult.insert(tempResult, at: destinationIndexPath.item)
//    }
//    
//    func popButtonTapped(button : UIButton) -> Void {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func readFromJson() {
//        
//        let fileName = "categories"
//        let filePath = getFilePath(fileName: fileName)
//        let data =  NSData(contentsOf: NSURL(fileURLWithPath: filePath!) as URL)
//        do {
//            let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [[String:AnyObject]]
////            let resultPredicate = NSPredicate(format: "type contains[c] %@", type!)
//            let abc : [String : AnyObject] = json?[0][type!]!["70"] as! [String : AnyObject]
//            let mno = abc["event"]
//            let pqr : AnyObject = mno?.value(forKey: "prize") as! AnyObject
////            finalResult = json!.filter{resultPredicate.evaluate(with: $0)}
//        } catch {
//            print ("error")
//        }
//    }
//    
//    func getFilePath(fileName: String) -> String? {
//        return Bundle.main.path(forResource: fileName, ofType: "json")
//    }
//    
//    func toMapView() {
//        let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        navigationController?.pushViewController(mapViewController, animated: true)
//    }
//    
//}
