//
//  TypeViewController.swift
//  NEFEnduro
//
//  Created by Include tech. on 06/02/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit

class TypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var type:String? = nil
    var finalResult : [[String:AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        readFromJson()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.topItem?.title = self.type

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalResult[0]["event"]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")

        cell.textLabel?.text = finalResult[indexPath.row]["kmdesc"] as? String

        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalDisplayViewController") as! FinalDisplayViewController
        vc.finalResult = finalResult[indexPath.row]

        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func readFromJson() {
        
        let fileName = "categories"
        let filePath = getFilePath(fileName: fileName)
        let data =  NSData(contentsOf: NSURL(fileURLWithPath: filePath!) as URL)
        do {
            let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String:AnyObject]
            finalResult = json![type!] as! [[String : AnyObject]]

        } catch {
            print ("error")
        }
    }
    
    func getFilePath(fileName: String) -> String? {
        return Bundle.main.path(forResource: fileName, ofType: "json")
    }
    
}
