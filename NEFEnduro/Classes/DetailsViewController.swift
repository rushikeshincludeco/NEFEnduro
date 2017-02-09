//
//  DetailsViewController.swift
//  NEFEnduro
//
//  Created by Include tech. on 08/02/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NavgationTransitionable {

    @IBOutlet weak var tableView: UITableView!
    var finalResult : [String : AnyObject] = [:]
    let labelText = UILabel()
    let labelDesc = UILabel()
    let labelSummary = UILabel()
    var tr_pushTransition: TRNavgationTransitionDelegate?


    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        view.addSubview(containerView)
        containerView.snp.makeConstraints{(make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.65)
        }
        
        let imageView = UIImageView()
        containerView.insertSubview(imageView, at: 0)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = containerView.frame
        imageView.clipsToBounds = true
        var image = UIImage()
        image = UIImage(named: "bgImage")!
        imageView.image = image
        imageView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(containerView)
        }
        
        labelText.font = UIFont(name: "ALoveofThunder", size: 18)
        labelText.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelText.numberOfLines = 0
        containerView.addSubview(labelText)
        labelText.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.height.equalTo(40)
            make.top.equalTo(containerView.snp.top).offset(65)
        }
        
        labelDesc.font = UIFont(name: "Roboto-Black", size: 15)
        labelDesc.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelDesc.numberOfLines = 0
        
        containerView.addSubview(labelDesc)

        labelDesc.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView).offset(5)
            make.height.equalTo(150)
            make.top.equalTo(labelText.snp.bottom)
        }
        
        
        labelSummary.font = UIFont(name: "Roboto-Black", size: 15)
        labelSummary.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelSummary.numberOfLines = 0
        containerView.addSubview(labelSummary)

        labelSummary.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(5)
            make.height.equalTo(50)
            make.top.equalTo(labelDesc.snp.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(containerView.snp.bottom)
        }

        labelText.text = finalResult["name"] as? String
        let str = finalResult["desc"] as? String
        labelDesc.text = str?.replacingOccurrences(of: ". ", with: ".\n")
        labelSummary.text = finalResult["summary"] as? String
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Back", for: .normal)
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn1.addTarget(self, action: #selector(DetailsViewController.backButtonPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)

    }
    
    func backButtonPressed(){
        
        _ = navigationController?.tr_popViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = finalResult["fees"] as? String
        } else {
            let prize = finalResult["prize"] as! [String]
            let str = prize[indexPath.row]
         
            cell.textLabel?.text =  "\(indexPath.row + 1) : ".appending(str)
        }
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;


        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        if (section == 0){
            return "Registration Fees"
        }
        if (section == 1){
            return "Prize"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
