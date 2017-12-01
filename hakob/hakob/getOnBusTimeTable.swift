//
//  getOnBusTimeTable.swift
//  hakob
//
//  Created by stb1015157 on 2017/10/06.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class getOnBusTimeTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var busStop:[String] = []

    let stopTimeKameda105Nobori = [8*60+3, 8*60+9, 8*60+40, 9*60+14, 9*60+28, 10*60+11, 10*60+16, 10*60+34, 11*60+4, 11*60+11, 11*60+49, 12*60+12, 13*60+12, 13*60+20, 13*60+45, 14*60+58, 15*60+27, 16*60+10, 17*60+9, 17*60+34, 18*60+21, 18*60+54, 19*60+28, 20*60+35] // 亀田支所の105系統上りの時刻表
    let stopTimeKameda105Kudari = [8*60+15, 8*60+21, 8*60+52, 9*60+26, 9*60+40, 10*60+23, 10*60+28, 10*60+46, 11*60+16, 11*60+23, 12*60+1, 13*60+24,  13*60+32, 13*60+57, 15*60+10, 15*60+39, 16*60+22, 17*60+21, 18*60+46, 19*60+19, 19*60+53, 20*60+12, 20*60+55] // 亀田支所の105系統下りの時刻表

    var getOn: String?
    var getOff: String?
    
    var busStopsTime: [Int]? = []
    let timeFromKameda = [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12] // 亀田支所からそれ以降の各バス停までかかる時間 [気象台, 赤川通, 赤川1丁目, 赤川入口, 低区貯水池, 浄水場下, 赤川小学校, 赤川3区, 赤川貯水池, はこだて未来大学]
    var delayTime: [Int]? = []
    var cellNum = 0 // 現在時刻以前に来るバスの数
    var num = 0
    
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var delayTimeList: UITableView!
    @IBOutlet weak var cellLabel1: UILabel!
    @IBOutlet weak var cellLabel2: UILabel!
    
    var destLocation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━現在時刻をint型で取得━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
        let now = Date()
        let cal: Calendar = Calendar(identifier: .gregorian)
        let cal_comp: DateComponents = cal.dateComponents([.hour, .minute], from:now)
        
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━目的地、乗車地、降車地を設定━━━━━━━━━━━━━━━━━━━━━━━━━ */
        getOnBusStop.text = getOn
        getOffBusStop.text = getOff
        
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━亀田支所以降のバス停の時刻表━━━━━━━━━━━━━━━━━━━━━━━━━ */
        if busLineChk(geton: getOnBusStop.text!, getoff: getOffBusStop.text!) {
            // 上り
            switch getOnBusStop.text! {
            case busStop[0]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[0])
                }
            case busStop[1]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[1])
                }
            case busStop[2]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[2])
                }
            case busStop[3]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[3])
                }
            case busStop[4]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[4])
                }
            case busStop[5]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[5])
                }
            case busStop[6]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[6])
                }
            case busStop[7]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[7])
                }
            case busStop[8]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[8])
                }
            case busStop[9]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[9])
                }
            case busStop[10]:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i] + timeFromKameda[10])
                }
            default:
                for i in 0 ..< stopTimeKameda105Nobori.count {
                    busStopsTime?.append(stopTimeKameda105Nobori[i])
                }
            }
        } else {
            // 下り
            switch getOnBusStop.text! {
            case busStop[0]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[0])
                }
            case busStop[1]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[1])
                }
            case busStop[2]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[2])
                }
            case busStop[3]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[3])
                }
            case busStop[4]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[4])
                }
            case busStop[5]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[5])
                }
            case busStop[6]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[6])
                }
            case busStop[7]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[7])
                }
            case busStop[8]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[8])
                }
            case busStop[9]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[9])
                }
            case busStop[10]:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i]+timeFromKameda[10])
                }
            default:
                for i in 0 ..< stopTimeKameda105Kudari.count {
                    busStopsTime?.append(stopTimeKameda105Kudari[i])
                }
            }
        }
        
        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━あと何分で到着するか━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
        for i in 0 ..< busStopsTime!.count {
            delayTime?.append(((busStopsTime?[i])!) - (cal_comp.hour!*60 + cal_comp.minute!))
        }
        
        /* ━━━━━━━━━━━━━━━━━━━━━━━現在時刻以前に来るバスの数を数える━━━━━━━━━━━━━━━━━━━━━━ */
        // num = cal_comp.hour!
        for i in 0 ..< delayTime!.count {
            if (delayTime?[i])! < 0 {
                cellNum += 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━セルの設定━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    
    // セルの個数を指定するデリゲートメソッド(必須)
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        cellNum = 0
        for i in 0 ..< delayTime!.count {
            if delayTime![i] < 0 {
                cellNum += 1
            }
        }
        return busStopsTime!.count-cellNum
    }
    
    // セルに値を設定するデータメソッド(必須)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // セルを作る
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "delayTime", for: indexPath)
        
        SetCellItem(indexPath: indexPath, cell: cell, busStop: busStopsTime!, delay: delayTime!)
        
        return cell
    }
    
    private func SetCellItem(indexPath: IndexPath, cell: UITableViewCell, busStop: [Int], delay: [Int]){
        cellLabel1 = cell.viewWithTag(1) as! UILabel
        cellLabel1.text = "\(busStop[indexPath.row+cellNum]/60):\(String(format: "%02d", busStop[indexPath.row+cellNum]%60))"
        
        cellLabel2 = cell.viewWithTag(2) as! UILabel
        cellLabel2.text = "あと\(delay[indexPath.row+cellNum]/60)時間"+"\(delay[indexPath.row+cellNum]%60)分で到着"
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル番号：¥(indexPath.row)　セルの内容：¥(stopTimeKameda105Nobori[indexPath.row])")
        performSegue(withIdentifier: "toBusLine", sender: indexPath.row)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
    
    // MARK: 未来大へ向かうバスか下るバスか判定
    // true 未来大方面 : false 亀田支所方面
    private func busLineChk(geton: String, getoff: String) -> Bool {
        var stop1: Int
        var stop2: Int
        
        if (busStop.index(of: geton) != nil) && (busStop.index(of: getoff) != nil) {
            stop1 = busStop.index(of: geton)!
            stop2 = busStop.index(of: getoff)!
            
            if stop1 < stop2 {
                return true
            }
        }
        
        
        return false;
    }
    
    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var BusLine = segue.destination as! busLine
        BusLine.busStops105 = busStop
        BusLine.destLocation = self.destLocation
    }
    
}
