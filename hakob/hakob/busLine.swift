//
//  busLine.swift
//  hakob
//
//  Created by stb1015157 on 2017/10/11.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import MapKit

class busLine: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var busStops105 = [""]
        //["函館駅前5番のりば", "松風町(1)プレイガイド前", "松風町(2)セブンイレブン前", "新川町", "千歳町", "昭和橋", "堀川町", "千代台", "中央病院前", "五稜郭(1)シダックス前", "五稜郭公園入口", "警察署前警察署向かい", "田家入口", "医師会病院前", "富岡", "亀田支所前(1)至赤川", "函館地方気象台前", "赤川通", "赤川1丁目ライフプレステージ白ゆり美原前", "赤川入口", "低区貯水池", "浄水場下", "赤川小学校", "赤川3区", "赤川貯水池", "はこだて未来大学", "赤川4区", "下赤川", "赤川"]
    
    @IBOutlet weak var titleBusStop: UINavigationBar!
    @IBOutlet weak var busLine: UITableView!
    @IBOutlet weak var aaa: MKMapView!
    //@IBOutlet weak var busLineMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return busStops105.count
    }
    
    // セルに値を設定するデータメソッド(必須)
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セルを作る
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier:
                "busStops", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = busStops105[indexPath.row]
        return cell
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
