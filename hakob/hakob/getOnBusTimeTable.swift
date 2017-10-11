//
//  getOnBusTimeTable.swift
//  hakob
//
//  Created by stb1015157 on 2017/10/06.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit

class getOnBusTimeTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var destination = ["函館駅", "五稜郭", "亀田支所", "はこだて未来大学"]
    var busStop = ["函館駅前5番のりば", "五稜郭", "富岡", "亀田支所前", "はこだて未来大学"]
    var delayTime = 0
    
    @IBOutlet weak var titleBusStop: UINavigationBar!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var busLine: UIButton!
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var getOnBusStop2: UILabel!
    @IBOutlet weak var delayTimeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        destinationLabel.text = destination[0]
        getOnBusStop.text = busStop[0]
        getOffBusStop.text = busStop[busStop.count]
        getOnBusStop2.text = getOnBusStop.text
        titleBusStop.accessibilityLabel = getOnBusStop.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セルを作る
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier:
                "listCell", for: indexPath)
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return 10
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
