//
//  PricesEntity.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

public struct PricesEntity: Codable, Equatable {
    public let price: String?
    public let deliveries: [DeliveryEntity]?
}
