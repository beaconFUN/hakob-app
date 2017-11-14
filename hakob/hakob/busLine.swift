//
//  busLine.swift
//  hakob
//
//  Created by stb1015157 on 2017/10/11.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import MapKit

class busLine: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var busStops105 = [""]
        //["函館駅前5番のりば", "松風町(1)プレイガイド前", "松風町(2)セブンイレブン前", "新川町", "千歳町", "昭和橋", "堀川町", "千代台", "中央病院前", "五稜郭(1)シダックス前", "五稜郭公園入口", "警察署前警察署向かい", "田家入口", "医師会病院前", "富岡", "亀田支所前(1)至赤川", "函館地方気象台前", "赤川通", "赤川1丁目ライフプレステージ白ゆり美原前", "赤川入口", "低区貯水池", "浄水場下", "赤川小学校", "赤川3区", "赤川貯水池", "はこだて未来大学", "赤川4区", "下赤川", "赤川"]
    
    @IBOutlet weak var busLine: UITableView!
    @IBOutlet weak var busStopMap: MKMapView!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    var destLocation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        busStopMap.delegate = self
        
        // 位置情報取得の許可状況を確認
        let status = CLLocationManager.authorizationStatus()
        
        // 許可が場合は確認ダイアログを表示
        if(status == CLAuthorizationStatus.notDetermined) {
            print("didChangeAuthorizationStatus:\(status)");
            self.locationManager.requestAlwaysAuthorization()
        }
        //位置情報の精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //位置情報取得間隔(m)
        locationManager.distanceFilter = 300
        locationManager.startUpdatingLocation()
        busStopMap.setCenter(busStopMap.userLocation.coordinate, animated: true)
        busStopMap.userTrackingMode = MKUserTrackingMode.follow
        userLocation = busStopMap.userLocation.coordinate
        
        busStopMap.addAnnotation(destLocation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /* ━━━━━━━━━━━━━━━━━━━━━━━セルの設定━━━━━━━━━━━━━━━━━━━━━━━━ */
    
    // セルの個数を指定するデリゲートメソッド(必須)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return busStops105.count
    }
    
    // セルに値を設定するデータメソッド(必須)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // セルを作る
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier:
                "busStops", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = busStops105[indexPath.row]
        return cell
    }

    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
        
        let userLocAnnotation: MKPointAnnotation = MKPointAnnotation()
        userLocAnnotation.coordinate = userLocation
        userLocAnnotation.title = "現在地"
        //busStopMap.addAnnotation(userLocAnnotation)
        // 現在地から目的地家の経路を検索
        getRoute()
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("locationManager error")
    }
    
    func getRoute()
    {
        // 現在地と目的地のMKPlacemarkを生成
        let fromPlacemark = MKPlacemark(coordinate:userLocation, addressDictionary:nil)
        let toPlacemark   = MKPlacemark(coordinate:destLocation.coordinate, addressDictionary:nil)
        
        // MKPlacemark から MKMapItem を生成
        let fromItem = MKMapItem(placemark:fromPlacemark)
        let toItem   = MKMapItem(placemark:toPlacemark)
        
        // MKMapItem をセットして MKDirectionsRequest を生成
        let request = MKDirectionsRequest()
        
        request.source = fromItem
        request.destination = toItem
        
        request.requestsAlternateRoutes = true // 単独の経路を検索
        request.transportType = MKDirectionsTransportType.walking
        
        let myDirections: MKDirections = MKDirections(request: request)
        myDirections.calculate { (response, error) in
            
            // NSErrorを受け取ったか、ルートがない場合.
            if error != nil || response!.routes.isEmpty {
                print(error)
                return
            }
            
            let route: MKRoute = response!.routes[0] as MKRoute
            print("目的地まで \(route.distance)km")
            print("所要時間 \(Int(route.expectedTravelTime/60))分")
            
            // mapViewにルートを描画.
            self.busStopMap.add(route.polyline)
        }

    }
    
    // 地図の表示範囲を計算
    func showUserAndDestinationOnMap()
    {
        // 現在地と目的地を含む矩形を計算
        let maxLat:Double = fmax(userLocation.latitude,  destLocation.coordinate.latitude)
        let maxLon:Double = fmax(userLocation.longitude, destLocation.coordinate.longitude)
        let minLat:Double = fmin(userLocation.latitude,  destLocation.coordinate.latitude)
        let minLon:Double = fmin(userLocation.longitude, destLocation.coordinate.longitude)
        
        // 地図表示するときの緯度、経度の幅を計算
        let mapMargin:Double = 1.5;  // 経路が入る幅(1.0)＋余白(0.5)
        let leastCoordSpan:Double = 0.005;    // 拡大表示したときの最大値
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin);
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLon - minLon) * mapMargin);
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(span_x, span_y);
        // 現在地を目的地の中心を計算
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) / 2, (maxLon + minLon) / 2);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span);
        
        busStopMap.setRegion(busStopMap.regionThatFits(region), animated:true);
    }
    
    // ルートの表示設定.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        
        // ルートの線の太さ.
        routeRenderer.lineWidth = 3.0
        
        // ルートの線の色.
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
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
