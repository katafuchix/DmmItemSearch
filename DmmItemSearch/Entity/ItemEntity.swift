//
//  ItemEntry.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

public struct ItemEntity: Codable, Equatable {

    public let service_code: String?
    public let service_name: String?
    public let floor_code: String?
    public let floor_name: String?
    public let category_name: String?
    public let content_id: String?
    public let product_id: String?
    public let title: String?
    public let volume: String?

    public let review: ReviewEntity?

    public let URL: String?
    public let affiliateURL: String?

    public let imageURL: ImageURLEntity?

    public let price: PricesEntity?

    public let date: String?

    public let iteminfo: ItemInfoEntity?

    public static func ==(lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        return lhs.product_id == rhs.product_id
    }
}
