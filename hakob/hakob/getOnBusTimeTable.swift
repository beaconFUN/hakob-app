//
//  getOnBusTimeTable.swift
//  hakob
//
//  Created by stb1015157 on 2017/10/06.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import Foundation

class getOnBusTimeTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var destination = ["函館駅", "五稜郭", "亀田支所", "はこだて未来大学"]
    var busStop = ["函館駅前5番のりば", "五稜郭", "富岡", "亀田支所前", "はこだて未来大学"]
/*
    var stopTime = ["8:03", "8:09", "8:40", "9:14", "9:28", "10:11", "10:16", "10:34", "11:04", "11:11", "11:49", "12:12", "13:12", "13:20", "13:45", "14:58", "15:27", "16:10", "17:09", "17:34", "18:21", "18:54", "19:28", "20:35"]
 */
    let stopTime = [8*60+3, 8*60+9, 8*60+40, 9*60+14, 9*60+28, 10*60+11, 10*60+16, 10*60+34, 11*60+4, 11*60+11, 11*60+49, 12*60+12, 13*60+12, 13*60+20, 13*60+45, 14*60+58, 15*60+27, 16*60+10, 17*60+9, 17*60+34, 18*60+21, 18*60+54, 19*60+28, 20*60+35]
    var delayTime = [0]
    var cellNum = 0
    var num = 0
    
    
    @IBOutlet weak var titleBusStop: UINavigationBar!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var delayTimeList: UITableView!
    @IBOutlet weak var getOnBusStop2: UILabel!
    @IBOutlet weak var cellLabel1: UILabel!
    @IBOutlet weak var cellLabel2: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let now = Date()
        let cal: Calendar = Calendar(identifier: .gregorian)
        let cal_comp: DateComponents = cal.dateComponents([.hour, .minute], from:now)
        
        destinationLabel.text = "目的地：" + destination[0]
        getOnBusStop.text = busStop[0]
        getOffBusStop.text = busStop[4]
        titleBusStop.accessibilityLabel = getOnBusStop.text
        getOnBusStop2.text = getOnBusStop.text!
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
        delayTime = [Int](repeating: 0, count: stopTime.count)
        for i in 0 ..< stopTime.count {
        delayTime[i] = stopTime[i] - (cal_comp.hour!*60 + cal_comp.minute!)
        }
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
        num = cal_comp.hour!
        for i in 0 ..< delayTime.count {
            if delayTime[i] < 0 {
                cellNum += 1
            }
        }
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
        return stopTime.count - cellNum// stopTime.count
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
        /*
        // Tagが1の部品にアクセス
        cellLabel1 = cell.viewWithTag(1) as! UILabel
            cellLabel1.text = String(stopTime[indexPath.row]/60) + ":" + String(format: "%02d", stopTime[indexPath.row]%60)
        
        // Tagが2の部品にアクセス
        cellLabel2 = cell.viewWithTag(2) as! UILabel
        cellLabel2.text = "あと" + String(delayTime[indexPath.row]) + "分で到着"
         */
        // Tagが1の部品にアクセス
            cellLabel1 = cell.viewWithTag(1) as! UILabel
            cellLabel1.text = String(stopTime[cellNum]/60) + ":" + String(format: "%02d", stopTime[cellNum]%60)
            
        // Tagが2の部品にアクセス
            cellLabel2 = cell.viewWithTag(2) as! UILabel
            cellLabel2.text = "あと" + String(delayTime[cellNum]) + "分で到着"
        if (cellNum < 24) { cellNum+=1 }
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル番号：¥(indexPath.row)　セルの内容：¥(stopTime[indexPath.row])")
        performSegue(withIdentifier: "toBusLine", sender: indexPath.row)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }

/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var BusLine = segue.destination as! busLine
        BusLine.busStops105 = busStop
    }

}
