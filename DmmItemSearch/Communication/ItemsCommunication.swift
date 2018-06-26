//
//  Items.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import APIKit

/**
 * 商品検索 API request.
 */
public struct ItemsRequest: DMMRequest {

    /// 検索条件
    private var searchConditions: [String: Any]

    /// ページ番号
    private var page: Int

    public init(searchConditions: [String: Any], page: Int) {
        self.searchConditions = searchConditions
        self.page = page
    }

    // MARK: APIKit.Request

    public typealias Response = ItemsResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/ItemList")
    }

    public var parameters: Any? {
        var params = parametersWithAppId
        params["site"]      = "DMM.com"
        params["service"]   = "digital"
        params["floor"]     = "idol"
        params["sort"]      = "date"
        
        // ページング設定
        params["offset"] = self.page * Constants.hits + 1
        params["page"] = self.page
        // 検索条件をマージ
        params.merge(searchConditions) { $1 }
        return params
    }

}

/**
 * Item Search API Response.
 */
public struct ItemsResponse: DMMResponse {

    public typealias Entity = ItemsResponse.ItemsEntity

    public let result_count: Int?
    public let total_count: Int?
    public let first_position: Int?

    public var object: ItemsResponse.ItemsEntity?

    // MARK: 応答本体
    public struct ItemsEntity: Codable, DMMPaging {
        public let items: [ItemEntity]
        
        /// 検索開始位置
        public let  first_position: Int
        /// 取得件数
        public let  result_count: Int
        /// トータル件数
        public let  total_count: Int
    }

}
