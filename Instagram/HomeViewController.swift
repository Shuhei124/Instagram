//
//  HomeViewController.swift
//  Instagram
//
//  Created by 豊田修平 on 2021/01/18.
//

import UIKit
import Firebase
//★?????
class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
        var postArray: [PostData] = []
        
        // Firestoreのリスナー(Firestoreのデータ更新の監視を行う)
        var listener: ListenerRegistration!

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self

            // カスタムセルを登録する
            let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "Cell")
            //★???カスタムセルをCellというIdentifierで登録。カスタムセルを登録には、UINib(nibName:bundle)を使ってxibファイルを読み込み、それをregister(_:forCellReuseIdentifier:)メソッドで登録します。???
            
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("DEBUG_PRINT: viewWillAppear")

            if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                    //データベースの参照場所と取得順序を指定したクエリを作成
                    
                    //addSnapshotListenerメソッドに指定したクロージャはドキュメント追加更新のたびに呼び出されます
                    listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        //★??クロージャ引数の querySnapshotに最新のデータが入っており、そのdocumentsプロパティにドキュメント（QueryDocumentSnapshot）の一覧が配列の形で入っている。このドキュメントをPostDataに変換し、postArrayの配列に格納します。mapメソッドは配列の要素を変換して新しい配列を作成するメソッドで、mapメソッドのクロージャの引数（document）で変換元の配列要素を受け取り、変換した要素をクロージャの戻り値（return postData）で返却することにより、配列を変換
                        
                        
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                    }
                }
            } else {
                // ログイン未(またはログアウト済み)
                if listener != nil {
                    // listener登録済みなら削除してpostArrayをクリアする
                    listener.remove()
                    listener = nil
                    postArray = []
                    tableView.reloadData()
                }
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postArray.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            cell.setPostData(postArray[indexPath.row])
            //setPostDataはPostTableViewCellで定義される
         
            // セル内のボタンのアクションをソースコードで設定する
            //addTarget(_:action:for:)メソッドが、青い線を引っ張ってActionを設定する代わり
            cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
            
            //コメントボタンが押された時
            cell.commentButton.addTarget(self, action:#selector(cmhandleButton(_:forEvent:)), for: .touchUpInside)
            
            
            return cell
        }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
        @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: likeボタンがタップされました。")

            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)

            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]

            // likesを更新する
            if let myid = Auth.auth().currentUser?.uid {
                // 更新データを作成する
                var updateValue: FieldValue
                if postData.isLiked {
                    // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                    updateValue = FieldValue.arrayRemove([myid])
                } else {
                    // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                    updateValue = FieldValue.arrayUnion([myid])
                }
                // likesに更新データを書き込む
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                postRef.updateData(["likes": updateValue])
            }
        }

    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func cmhandleButton(_ sender: UIButton, forEvent event: UIEvent){
            print("DEBUG_PRINT: commentボタンがタップされました。")

            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)

            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
            let cell = tableView.cellForRow(at:indexPath!)as! PostTableViewCell
            
        
            if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            
            let user = Auth.auth().currentUser
            if let displayName = user?.displayName, let comment = cell.commentBox.text {
                    var commentName = "\(displayName): \(comment)"
                    updateValue = FieldValue.arrayUnion([commentName])
                // コメントと投稿者をを書き込む
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                    postRef.updateData(["comments": updateValue])
                }

            
      
        }
    }
}
