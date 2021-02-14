//
//  PostViewController.swift
//  Instagram
//
//  Created by 豊田修平 on 2021/01/18.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        // Do any additional setup after loading the view.
    }
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド??????難しい
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
                let imageData = image.jpegData(compressionQuality: 0.75)
                // 画像と投稿データの保存場所を定義する
                let postRef = Firestore.firestore().collection(Const.PostPath).document()
                //Firestoreの postsフォルダに新しい投稿データを保存するよう指定
        
        
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
                //imageRefは、Storageに保存する画像の保存場所を定義。Const.swiftで定義した ImagePathをchildメソッドの引数に指定し、さらにどの投稿に対応する画像か紐付けるために、.child(postRef.documentID + ".jpg")を指定することで、投稿データの documentIDを画像のファイル名に利用
        
                // HUDで投稿処理中の表示を開始
                SVProgressHUD.show()
                // Storageに画像をアップロードする
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        // 画像のアップロード失敗
                        print(error!)
                        SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                        // 投稿処理をキャンセルし、先頭画面に戻る
                        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                        return
                    }
                    // FireStoreに投稿データを保存する
                    let name = Auth.auth().currentUser?.displayName
                    let postDic = [
                        "name": name!,
                        "caption": self.textField.text!,
                        "date": FieldValue.serverTimestamp(),
                        ] as [String : Any]
                    postRef.setData(postDic)
                    //保存するデータを辞書の形にまとめて、setDataを実行するとFirestoreにデータを保存。
                    
                    // HUDで投稿完了を表示する
                    SVProgressHUD.showSuccess(withStatus: "投稿しました")
                    // 投稿処理が完了したので先頭画面に戻る
                   UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
