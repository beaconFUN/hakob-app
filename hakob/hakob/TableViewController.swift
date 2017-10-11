//
//  TableViewController.swift
//  hakob
//
//  Created by Yuji Kojima on 2017/10/11.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var resultList:[String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("バス停：\(resultList)")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを作る
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Table View Cell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
//        cell.textLabel!.text = "\(indexPath.row + 1)"
        cell.detailTextLabel!.text = "\(resultList[indexPath.row])"
        print(resultList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        // セルの数を設定
        return resultList.count
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
