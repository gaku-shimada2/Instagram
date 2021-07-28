//
//  CommentData.swift
//  Instagram
//
//  Created by 島田岳 on R 3/07/27.
//

import Foundation
import Firebase

class CommentData: NSObject {
    var id: String
    var postData_id: String?
    var comment: String?
    var commentName: String?
    var date: Date?
 
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let commentDic = document.data()

        self.postData_id = commentDic["postData_id"] as? String

        self.comment = commentDic["comment"] as? String

        self.commentName = commentDic["commentName"] as? String
        
        let timestamp = commentDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()

    }
}
