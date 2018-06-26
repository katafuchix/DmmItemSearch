//
//  ActressCommunication.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import APIKit

/**
 * 女優検索 API request.
 */
public struct ActressesRequest: DMMRequest {

    /// 検索条件
    private var searchConditions: [String: Any]

    /// ページ番号
    private var page: Int

    public init(searchConditions: [String: Any], page: Int) {
        self.searchConditions = searchConditions
        self.page = page
    }

    // MARK: APIKit.Request

    public typealias Response = ActressesResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/ActressSearch")
    }

    public var parameters: Any? {
        var params = parametersWithAppId
        params["sort"] = "name"
        // ページング設定
        params["offset"] = self.page * Constants.hits + 1
        params["page"] = self.page
        // 検索条件をマージ
        params.merge(searchConditions) { $1 }
        return params
    }

}

/**
 * Actress Search API Response.
 */
public struct ActressesResponse: DMMResponse {

    public typealias Entity = ActressesResponse.ActressesEntity

    public let result_count: Int?
    public let total_count: String?
    public let first_position: String?

    public var object: ActressesResponse.ActressesEntity?

    // MARK: 応答本体
    public struct ActressesEntity: Codable, DMMPaging {
        public let actress: [ActressEntity]

        /// 検索開始位置
        public let  first_position: String
        /// 取得件数
        public let  result_count: Int
        /// トータル件数
        public let  total_count: String
    }

}
