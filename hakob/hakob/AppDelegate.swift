//
//  AppDelegate.swift
//  hakob
//
//  Created by 佐藤秀輔 on 2017/10/04.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!
    
    var userdefault: UserDefaults?
    
    var busBeacons: [busBeacon] = []
    
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    // 今回の検知対象は3つのUUID。(OS等のバージョンで検出可能な上限数は20個程度が目安)
    let UUIDList = [
        "01000000-0000-0000-0000-000000000000"
    ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupbeacon()
        // notification center (singleton)
        let center = UNUserNotificationCenter.current()
        
        // ------------------------------------
        // 前準備: ユーザに通知の許可を求める
        // ------------------------------------
        
        // request to notify for user
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowed")
            } else {
                print("Didn't allowed")
            }
        }

        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        removeUserDefaults()
        userdefault = UserDefaults()
        
        makeBeaconList()
        
        return true
    }
    
    func removeUserDefaults() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "hakob")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func setupbeacon(){
        
        // ロケーションマネージャの作成.
        myLocationManager = CLLocationManager()
        myLocationManager.allowsBackgroundLocationUpdates = true
        // デリゲートを自身に設定.
        myLocationManager.delegate = self
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.(1mごとに位置情報取得)
        myLocationManager.distanceFilter = 1
        
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        print("CLAuthorizedStatus: \(status.rawValue)");
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == .notDetermined) {
            // [認証手順1] まだ承認が得られていない場合は、認証ダイアログを表示.
            // [認証手順2] が呼び出される
            myLocationManager.requestAlwaysAuthorization()
        }
        // 配列をリセット
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
    }
    
    /*
     CoreLocationの利用許可が取れたらiBeaconの検出を開始する.
     */
    private func startMyMonitoring() {
        
        // UUIDListのUUIDを設定して、反応するようにする
        for i in 0 ..< UUIDList.count {
            
            // BeaconのUUIDを設定.
            let uuid: NSUUID! = NSUUID(uuidString: "\(UUIDList[i].lowercased())")
            
            // BeaconのIfentifierを設定.
            let identifierStr: String = "fabo\(i)"
            
            // リージョンを作成.
            myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
            
            // ディスプレイがOffでもイベントが通知されるように設定(trueにするとディスプレイがOnの時だけ反応).
            myBeaconRegion.notifyEntryStateOnDisplay = false
            
            // 入域通知の設定.
            myBeaconRegion.notifyOnEntry = true
            
            // 退域通知の設定.
            myBeaconRegion.notifyOnExit = true
            
            // [iBeacon 手順1] iBeaconのモニタリング開始([iBeacon 手順2]がDelegateで呼び出される).
            myLocationManager.startMonitoring(for: myBeaconRegion)
        }
    }
    
    /*
     [認証手順2] 認証のステータスがかわったら呼び出される.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示
        switch (status) {
        case .notDetermined:
            print("未認証の状態")
            break
        case .restricted:
            print("制限された状態")
            break
        case .denied:
            print("許可しない")
            break
        case .authorizedAlways:
            print("常に許可")
            // 許可がある場合はiBeacon検出を開始.
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
            print("このAppの使用中のみ許可")
            // 許可がある場合はiBeacon検出を開始.
            startMyMonitoring()
            break
        }
    }
    
    /*
     [iBeacon 手順2]  startMyMonitoring()内のでstartMonitoringForRegionが正常に開始されると呼び出される。
     */
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        print("[iBeacon 手順2] didStartMonitoringForRegion");
        
        // [iBeacon 手順3] この時点でビーコンがすでにRegion内に入っている可能性があるので、その問い合わせを行う
        // [iBeacon 手順4] がDelegateで呼び出される.
        manager.requestState(for: region);
    }
    
    /*
     [iBeacon 手順4] 現在リージョン内にiBeaconが存在するかどうかの通知を受け取る.
     */
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        print("[iBeacon 手順4] locationManager: didDetermineState \(state)")
        
        switch (state) {
            
        case .inside: // リージョン内にiBeaconが存在いる
            print("iBeaconが存在!");
            
            // [iBeacon 手順5] すでに入っている場合は、そのままiBeaconのRangingをスタートさせる。
            // [iBeacon 手順6] がDelegateで呼び出される.
            // iBeaconがなくなったら、Rangingを停止する
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
            
        case .outside:
            print("iBeaconが圏外!")
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
            break;
            
        case .unknown:
            print("iBeaconが圏外もしくは不明な状態!")
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
            break;
            
        }
    }
    
    /*
     [iBeacon 手順6] 現在取得しているiBeacon情報一覧が取得できる.
     iBeaconを検出していなくても1秒ごとに呼ばれる.
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        // 配列をリセット
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
        
        // 範囲内で検知されたビーコンはこのbeaconsにCLBeaconオブジェクトとして格納される
        // rangingが開始されると１秒毎に呼ばれるため、beaconがある場合のみ処理をするようにすること.
        if(beacons.count > 0){
            
            // STEP7: 発見したBeaconの数だけLoopをまわす
            for i in 0 ..< beacons.count {
                
                let beacon = beacons[i]
                
                let beaconUUID = beacon.proximityUUID;
                let minorID = beacon.minor;
                let majorID = beacon.major;
                let rssi = beacon.rssi;
                
                //print("UUID: \(beaconUUID.UUIDString) minorID: \(minorID) majorID: \(majorID)");
                
                var proximity = ""
                
                switch (beacon.proximity) {
                    
                case CLProximity.unknown :
                    print("Proximity: Unknown");
                    proximity = "Unknown"
                    break
                    
                case CLProximity.far:
                    print("Proximity: Far");
                    proximity = "Far"
                    break
                    
                case CLProximity.near:
                    print("Proximity: Near");
                    proximity = "Near"
                    break
                    
                case CLProximity.immediate:
                    print("Proximity: Immediate");
                    proximity = "Immediate"
                    break
                }
                
                beaconUuids.add(beaconUUID.uuidString)
                
                var myBeaconDetails = "Major: \(majorID) "
                myBeaconDetails += "Minor: \(minorID) "
                myBeaconDetails += "Proximity:\(proximity) "
                myBeaconDetails += "RSSI:\(rssi)"
                print(myBeaconDetails)
                beaconDetails.add(myBeaconDetails)
                
                if proximity == "Far" {
                    var currentBusStop: Bool = false
                    for bus in busBeacons {
                        //print(bus.busStopName)
                        print(userdefault?.string(forKey: "busstopName"))
                        if userdefault?.string(forKey: "busstopName") == bus.busStopName {
                            if Int(majorID) == bus.major && Int(minorID) == bus.minor {
                                NotificationManager.postLocalNotificationIfNeeded(message: "\(bus.busStopName!)", major: Int(majorID), minor: Int(minorID))
                                currentBusStop = true
                            }
                        }
                    }
                    if !currentBusStop && userdefault?.string(forKey: "busstopName") != nil {
                        NotificationManager.postLocalNotificationIfNeeded(message: "\(String(describing: userdefault?.string(forKey: "busstopName")))")
                    }
                }
                
            }
        }
        
    }
    
    /*
     [iBeacon イベント] iBeaconを検出した際に呼ばれる.
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: iBeaconが圏内に発見されました。");
        
        // Rangingを始める (Ranginghあ1秒ごとに呼ばれるので、検出中のiBeaconがなくなったら止める)
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        manager.startUpdatingLocation()
    }
    
    /*
     [iBeacon イベント] iBeaconを喪失した際に呼ばれる. 喪失後 30秒ぐらいあとに呼び出される.
     */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: iBeaconが圏外に喪失されました。");
        
        // 検出中のiBeaconが存在しないのなら、iBeaconのモニタリングを終了する.
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
    }

    func makeBeaconList(){
        if let path = Bundle.main.path(forResource: "BusStopBeaconList", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        print(dict)
                        let name = dict["stopName"] as! String
                        let major = dict["major"] as! String
                        let minor = dict["minor"] as! String
                        
                        let iBeacon = busBeacon(name: name, major: Int(major)!, minor: Int(minor)!)

                        busBeacons.append(iBeacon)
                    }
                }
            }
        }
    }
    
}

