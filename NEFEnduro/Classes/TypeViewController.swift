//
//  TypeViewController.swift
//  NEFEnduro
//
//  Created by Include tech. on 06/02/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class TypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NavgationTransitionable {
    
    @IBOutlet weak var tableView: UITableView!
    var type:String? = nil
    var finalResult : [AnyObject] = []
    var event : [AnyObject] = []
    var tr_pushTransition: TRNavgationTransitionDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        event = finalResult[0]["event"] as! [AnyObject]

        print(finalResult)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        tableView.tableFooterView = UIView()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Back", for: .normal)
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn1.addTarget(self, action: #selector(TypeViewController.backButtonPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)

    }
    
    func backButtonPressed(){
        _ = navigationController?.tr_popViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        event = finalResult[section]["event"] as! [AnyObject]

        return  event.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        event = finalResult[indexPath.section]["event"] as! [AnyObject]

        cell.textLabel?.text =  event[indexPath.row]["name"] as? String

        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return finalResult.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return finalResult[section]["kmdesc"] as? String
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        event = finalResult[indexPath.section]["event"] as! [AnyObject]

        vc.finalResult = event[indexPath.row] as! [String : AnyObject]

        navigationController?.isNavigationBarHidden = false
//        navigationController?.pushViewController(vc, animated: true)
        let updateTransition: TRPushTransitionMethod = .omni(keyView: cell)

        navigationController?.tr_pushViewController(vc, method:updateTransition, statusBarStyle: .lightContent, completion: {
            print("Pushed")
        })

        }
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
