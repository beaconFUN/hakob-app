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
        
        //亀田支所前(上り)にPinを表示
        let coordinate = CLLocationCoordinate2D(latitude: 41.81589633,longitude: 140.7539141)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated:true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(41.81589633,140.7539141)
        annotation.title = "亀田支所前"
        annotation.subtitle = "105系統（未来大経由）"
        self.mapView.addAnnotation(annotation)
        
        
        
        
        
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
