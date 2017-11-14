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

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var getOnBusStop: UILabel!
    @IBOutlet weak var getOffBusStop: UILabel!
    @IBOutlet weak var OKButton: UIButton!
    
    var myLocationManager:CLLocationManager!
    var destLocation: MKPointAnnotation!

    //検索結果を入れる
    var nameResult = [""]
    //選択された乗車地と降車地を入れる
    var getOn:String?
    var getOff:String?
    
    //バス停名
    var name:[String] = ["はこだて未来大学","赤川貯水池", "赤川3区","赤川小学校","浄水場下","低区貯水池","赤川入口","赤川１丁目ライフプレステージ白ゆり美原前","赤川通","函館地方気象台前","亀田支所前"]
    //バス停緯度(下り)
    var latdown = [41.84023749,41.84237276,41.8384083,41.83527926,41.83045442,41.8266245,41.82451423,41.82262856,41.81975665,41.81728726,41.81415281,]
    //バス停経度(下り)
    var londown =
        [140.7670478,140.7714928,140.7691299,140.7675438,140.7646656,140.7622636,140.7606124,140.7594407,140.7569421,140.7549828,140.7537602]
    
    //バス停緯度(上り)
    var latup =
        [41.84028089,41.84251054,41.83864807,41.83466409,41.83068118,41.82801325,41.82470084,41.82234321,41.82028719,41.8185979,41.81589633]
    //バス停経度(上り)
    var lonup =
        [140.7670879,140.7713833,140.7691788,140.767124,140.7646591,140.762869,140.7604518,140.7588972,140.7570886,140.7557357,140.7539141]
    
    
    var busAnnotations: [MKAnnotation]! = []
    
    var logoImageView: UIImageView!
    var maskView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //CLLocationManagerをインスタンス化
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        mapView.delegate = self
        
        //imageView作成
        self.logoImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.maskView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.maskView.backgroundColor = UIColor.white
        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.logoImageView.image = UIImage(named: "launch")
        //viewに追加
        self.view.addSubview(self.maskView)
        self.maskView.addSubview(self.logoImageView)
        
        for i in 0..<11 {
            let Annotation = MKPointAnnotation()
            Annotation.coordinate = CLLocationCoordinate2DMake((latdown[i]+latup[i])/2, (londown[i]+lonup[i])/2)
            Annotation.title = name[i]
            
            self.busAnnotations.append(Annotation)
        }
        
        self.mapView.addAnnotations(busAnnotations)
        
        
        //位置情報使用許可のリクエストを表示するメソッドの呼び出し
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()
        
        mapView.userTrackingMode = .follow
        
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        //デリゲート先を自分に設定する。
        searchBar.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        
        self.OKButton.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 1.0, y: 1.0)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 5.5, y: 5.5)
                        self.logoImageView.alpha = 0
        }, completion: { (Bool) in
            self.maskView.removeFromSuperview()
        })
    }
    
    
    //位置情報取得に失敗したときに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //検索窓の設定
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.mapView.removeAnnotations(busAnnotations)
        searchBar.endEditing(true)
        busAnnotations.removeAll()
        
        for i in 0..<name.count {
            if(searchBar.text == "") {
                
            } else if (name[i].contains(searchBar.text!)) {
                nameResult.append(name[i])

                let Annotation = CustomAnnotation()
                Annotation.coordinate = CLLocationCoordinate2DMake((latup[i]+latdown[i])/2, (lonup[i]+londown[i])/2)
                Annotation.title = name[i]
                
                Annotation.busstopName = name[i]
                Annotation.subtitle = "おおよその位置"
                
                self.busAnnotations.append(Annotation)
            }
        }
        self.mapView.addAnnotations(busAnnotations)

    }
    //ピンにボタンをつける
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    //ボタンをタップした時の処理
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let actionSheet = UIAlertController(title: "タイトル", message: "設定したい方を選択してください", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "乗車地", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション１をタップした時の処理")
            //乗車地
            self.getOn = (view.annotation?.title)!
            self.getOnBusStop.text = self.getOn
            self.destLocation = view.annotation as! MKPointAnnotation
            print(view.annotation?.title)
            print(self.getOn!)
            
            if self.getOff != nil {
                self.OKButton.isHidden = false
            }
            
        })
        
        let action2 = UIAlertAction(title: "降車地", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション２をタップした時の処理")
            //降車地
            self.getOff = (view.annotation?.title)!
            self.getOffBusStop.text = self.getOff
            print(view.annotation?.title)
            print(self.getOff!)
            
            if self.getOn != nil {
                self.OKButton.isHidden = false
            }
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let TableVC = segue.destination as! getOnBusTimeTable
        
        TableVC.getOn = getOn
        TableVC.getOff = getOff
        TableVC.destLocation = self.destLocation
    }

    @IBAction func nextVC(_ sender: Any) {
        if(self.getOn != nil && self.getOff != nil){
            self.performSegue(withIdentifier: "TimeTableSegue", sender: nil)
        } else {
            //なんか中央に注意書き的なの表示予定
        }

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
