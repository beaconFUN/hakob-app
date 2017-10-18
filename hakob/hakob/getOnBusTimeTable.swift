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
/*
    var stopTime = ["8:03", "8:09", "8:40", "9:14", "9:28", "10:11", "10:16", "10:34", "11:04", "11:11", "11:49", "12:12", "13:12", "13:20", "13:45", "14:58", "15:27", "16:10", "17:09", "17:34", "18:21", "18:54", "19:28", "20:35"]
 */
    var stopTime = [(8*60+3), (8*60+9), (8*60+40), (9*60+14), (9*60+28), (10*60+11), (10*60+16), (10*60+34), (11*60+4), (11*60+11), (11*60+49), (12*60+12), (13*60+12), (13*60+20), (13*60+45), (14*60+58), (15*60+27), (16*60+10), (17*60+9), (17*60+34), (18*60+21), (18*60+54), (19*60+28), (20*60+35)]
    let now = NSDate()
    let cal = NSCalendar.current
    let comp = cal.components(
        [NSCalendar.Unit.Year, NSCalendar.Unit.Month, NSCalendar.Unit.Day,
         NSCalendar.Unit.Hour, NSCalendar.Unit.Minute, NSCalendar.Unit.Second], fromDate: now)
    
    @IBOutlet weak var titleBusStop: UINavigationBar!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var busLine: UIButton!
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var delayTimeList: UITableView!
    @IBOutlet weak var getOnBusStop2: UILabel!
    @IBOutlet weak var cellLabel1: UILabel!
    @IBOutlet weak var cellLabel2: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        destinationLabel.text = "目的地：" + destination[0]
        getOnBusStop.text = busStop[0]
        getOffBusStop.text = busStop[4]
        titleBusStop.accessibilityLabel = getOnBusStop.text
        getOnBusStop2.text = getOnBusStop.text!
        var delayTimes = [1]
        delayTimes[0] = now - stopTime[0]
        print(delayTimes[0])
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
        
        // Tagが1の部品にアクセス
        cellLabel1 = cell.viewWithTag(1) as! UILabel
        
        // Tagが2の部品にアクセス
        cellLabel2 = cell.viewWithTag(2) as! UILabel
        cellLabel2.text = "あと" + String(delayTime) + "分で到着"
        
        // セルに表示する値を設定する
/*
        cell.textLabel!.text = stopTime[indexPath.row]
 */
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
