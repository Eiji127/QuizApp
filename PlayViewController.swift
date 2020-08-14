//
//  PlayViewController.swift
//  Santaku
//
//  Created by 白数叡司 on 2020/08/10.
//  Copyright © 2020 AEG. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var 問題ラベル: UILabel!
    @IBOutlet weak var 残り時間ビュー: UIProgressView!
    @IBOutlet var 解答ボタン: [UIButton]!
    
    let 問題リスト = [
        ["「3番目」を表す英語は？", "third", "first", "fifth"],
        ["「come」の過去形は？", "came", "come", "comed"],
        ["「８月」を表す英語は？", "August", "October", "November"],
    ]
    var 問題番号 = 0
    var 残り時間 = 10
    var 正解数 = 0
    var タイマー : Timer?

    
    
    override func viewDidLoad() { //viewプロパティがメモリ上にロードされた時点で実行したい処理を書く
        super.viewDidLoad()
        出題()
    } //ここからはじまる
    
    func 番号リスト() -> [Int] { // 「->」返り値アロー
        var リスト = [1, 2, 3]
        for _ in 1...10 {
            let i1 = Int(arc4random() % 3)
            let i2 = Int(arc4random() % 3)
            if i1 != i2 {
                リスト.swapAt(i1, i2) //swapって何？
            }
        }
        return リスト
    } //返り値についてもっと詳しく！！
    
    @objc func タイマー関数 () {
        残り時間 -= 1
        残り時間ビュー.progress = Float(残り時間) / 10
        if 残り時間 == 0 {
            タイマー!.invalidate() //invalidate()って何？？
            問題番号 += 1
            出題()
        }
    }
    
    func 出題() {
        if 問題番号 >= 問題リスト.count { //「>=」以上
            let alert = UIAlertController(title: "終了", message: "\(正解数)問正解!",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let 問題データ = 問題リスト[問題番号]
        問題ラベル.text = 問題データ[0]
        
        let 番号 = 番号リスト()
        
        for i in 0...2 {
            解答ボタン[i].setTitle(問題データ[番号[i]], for: UIControl.State())
        }
        残り時間 = 10
        残り時間ビュー.progress = 1.0
        タイマー = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:
            #selector(タイマー関数), userInfo: nil, repeats: true)
    }
    
    @IBAction func 解答チェック(_ sender: UIButton) {
        タイマー!.invalidate()
        let 解答 = (sender as AnyObject).currentTitle
        let 問題データ = 問題リスト[問題番号]
        let 解答番号 = 問題データ.firstIndex(of: 解答!!)
        let alert = UIAlertController(title: "\(問題番号+1)問目", message: "", preferredStyle: .alert)
        if 解答番号 == +1{
            正解数 += 1
            alert.message = "正解！！"
        }else {
            alert.message = "はずれ！！"
        }
        let action = UIAlertAction(title: "OK", style: .default) {
            (_) in
            self.問題番号 += 1
            self.出題()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
