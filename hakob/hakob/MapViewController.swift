//
//  MapViewController.swift
//  hakob
//
//  Created by 北原康太 on 2017/10/06.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    

    
    //CLLocationManagerの入れ物を用意
    var myLocationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CLLocationManagerをインスタンス化
        myLocationManager = CLLocationManager()
        
        //位置情報使用許可のリクエストを表示するメソッドの呼び出し
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()

        mapView.userTrackingMode = .follow
        
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    //位置情報取得に失敗したときに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
