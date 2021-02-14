//
//  TabBarController.swift
//  Instagram
//
//  Created by 豊田修平 on 2021/01/18.
//

//★ViewControllerを削除しているが、TabBarControllerを使うときはいつも削除するものか?共存もありえる?

import UIKit
import Firebase


class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //★ viewDidAppearは画面を表示するときに毎回実行される

        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理(LoginをIDに設定しているLoginViewControllerに飛ばす)
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            //★animated: true, completion: nilとはどういう事か。
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }

    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            
            //falseの場合は画面遷移しない。
            return false
            
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            //tureの場合はタブ切り替えを実施
            return true
        }
    }

}
