//
//  CreditCard.swift
//  CreditCardList
//
//  Created by do hee kim on 2022/04/04.
//

import Foundation

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool? //사용자가 카드를 선택했을 때 생성
}

struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
