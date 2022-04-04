//
//  KakaoChatTableViewCell.swift
//  Twitter_starter
//
//  Created by James Kim on 7/27/20.
//  Copyright © 2020 James Kim. All rights reserved.
//

import UIKit

class KakaoChatTableViewCell: UITableViewCell {
    /*
     TODO: senderImageView, nameLabel, lastMessageLabel, lastSentDateLabel를 만들어서 outlet으로 추가해주세요.
     */
    @IBOutlet var senderImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var lastSentDataLabel: UILabel!
    
    
    func configure(message: Message) {
        /*
         TODO: Cell이 생성되는 시점에서 메세지를 불러 렌더링해주세요
         
         예를들어..
         senderImageView.image = message.senderImage
         */
        senderImageView.image = message.senderImage
        senderImageView.layer.cornerRadius = CGFloat(8)
        
        nameLabel.text = message.senderName
        lastMessageLabel.text = message.lastMessage
        lastSentDataLabel.text = message.lastSentDate
    }
}
