//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 豊田修平 on 2021/01/30.
//

import UIKit
import FirebaseUI


class PostTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentBox: UITextField!
    @IBOutlet weak var commentList: UILabel!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentBox.delegate = self
      let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
        
        //testfieldshouldreturn
        // Initialization code
    }
    @objc func dismissKeyboard(){
         // キーボードを閉じる
         endEditing(true)
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentBox.resignFirstResponder()
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示。このファンクションはPostTableViewCellで呼び出される。
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"

        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        commentList.numberOfLines = 0
        var commentString = ""
        let commentALL = postData.comments

        for comment_i in commentALL{
            commentString += comment_i + "\n"
            
        }
        commentList.text = commentString
        
        /*
        //allCommentは最初は空である
        var allComment = ""
        //postData.commentsの中から要素をひとつずつ取り出すのを繰り返す、というのがcomment
        for comment in postData.comment{
        //comment + comment = allCommentである
        allComment += comment
        print(comment)
        print("a")
        //commentLabelに表示するのはallComment（commentを足していったもの）である
        self.commentList.text = allComment
        }*/

    }}
