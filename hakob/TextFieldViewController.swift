//
//  TextFieldViewController.swift
//  hakob
//
//  Created by Yuji Kojima on 2017/10/06.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController, UITextFieldDelegate {

    //バス停のリスト
    let busStopList = ["富岡", "亀田支所", "はこだて未来大学","はこだて未来大学"];
    //検索結果配列
    var searchResult = [""];
    
    //テキストフィールド
    @IBOutlet weak var textField: UITextField!
    
    
    
    //ボタン
    @IBAction func searchButton(_ sender: Any) {
//        textField.endEditing(true)
        
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        // TextFieldから文字を取得
        searchResult = [textField.text!]
        
        print("バス停リスト：\(searchResult)") //テスト
        let textfield:[String] = textField.text!.components(separatedBy: " ")
        
        
        for busstop in busStopList {
            if(textField.text == "") {
                //検索文字列が空の場合はすべてを表示する。
                searchResult = busStopList
                print("バス停リスト：\(searchResult)")
            } else if (busstop.contains(textField.text!)){//(busStopList.contains(textField.text!)){
                print("バス停リストの中に \(String(describing: textField.text)) を含む。 : \(busstop)")
                //検索文字列を含むデータを検索結果配列に追加する。
                searchResult.append(busstop)
            }
        }

        
    }

    //初期化メソッド
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    //警告受信メソッド
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //値渡し
    override func prerare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
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
