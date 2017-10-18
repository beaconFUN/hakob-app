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
    var delayTime = 5
    var stopTime = ["8:03", "8:09", "8:40", "9:14", "9:28", "10:11", "10:16", "10:34", "11:04", "11:11", "11:49", "12:12", "13:12", "13:20", "13:45", "14:58", "15:27", "16:10", "17:09", "17:34", "18:21", "18:54", "19:28", "20:35"]
    
    @IBOutlet weak var titleBusStop: UINavigationBar!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var busLine: UIButton!
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var delayTimeList: UITableView!
    @IBOutlet weak var getOnBusStop2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        destinationLabel.text = "目的地：" + destination[0]
        getOnBusStop.text = busStop[0]
        getOffBusStop.text = busStop[4]
        titleBusStop.accessibilityLabel = getOnBusStop.text
        getOnBusStop2.text = getOnBusStop.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/* ━━━━━━━━━━━━━━━━━━━━━━━セルの設定━━━━━━━━━━━━━━━━━━━━━━━━ */

    // セルの個数を指定するデリゲートメソッド(必須)
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return stopTime.count
    }
    
    // セルに値を設定するデータメソッド(必須)
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セルを作る
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier:
                "delayTime", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = stopTime[indexPath.row]
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
/*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print("セル番号：¥(indexPath.row)　セルの内容：¥(stopTime[indexPath.row])")
    }
*/

/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
