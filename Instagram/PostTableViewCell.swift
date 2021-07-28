//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 島田岳 on R 3/07/28.
//

import UIKit
import FirebaseUI
import Firebase


class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    // 投稿データを格納する配列
    var commentArray: [CommentData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }

     // PostDataの内容をセルに表示
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
        
                
        let commentsRef = Firestore.firestore().collection(Const.CommentPath).whereField("postData_id", isEqualTo: postData.id).order(by: "date", descending: true)
        listener = commentsRef.addSnapshotListener() { (querySnapshot, error) in
                     if let error = error {
                         print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                         return
                     }
                     // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                     self.commentArray = querySnapshot!.documents.map { document in
                         print("DEBUG_PRINT: document取得 \(document.documentID)")
                         let commentData = CommentData(document: document)
                         print(commentData.id)
                         return commentData
                     }
            // コメントラベルの表示
            if self.commentArray.count != 0 {
            self.commentLabel.text = "\(self.commentArray[0].commentName!) : \(self.commentArray[0].comment!)"
            } else{
                self.commentLabel.text = "コメントはありません"
            }
        }

     }
 }
