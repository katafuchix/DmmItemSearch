//
//  DMMAPI.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import APIKit
import RxSwift
import SwiftyJSON

// MARK: - 書式指定子

/// 日付フォーマット指定子
///
let DmmDateTimeFormat = "yyyy/MM/dd HH:mm:ss"

// MARK: - Error定義

/// API層で発生するError型式
///
public enum DMMAPIError: Error {
    /// ページング処理を行おうとしたが、ページ番号等の情報が無い
    case noPageNumber
    /// 検索結果領域が見付からない
    case itemsNotExist
}

/// DMM APIの基本機能実装部
/// - note: DMM APIで必要とする共有機能はここに集める
/// - note: https://affiliate.dmm.com/api/
///
public struct DMMAPI {

    /// API version number.
    public enum Version: String {
        case v3
    }

    /// scheme指定
    static var scheme = "https"

    /// 接続先ホスト指定
    public static var host = "api.dmm.com"

    /// APIパスの生成処理
    /// - parameter version: バージョン指定子
    /// - returns: バージョン指定を元にしたAPIパス
    ///
    static func makePath(version: Version) -> String {
        return "/affiliate/\(version)"
    }
}


// MARK: - APIKit.Requstの雛形定義

/**
 * papafunny request protocol for APIKit.
 */
public protocol DMMRequest: Request {

    /// API version number.
    /// - note: 実装先でバージョンを再指定可能
    var version: DMMAPI.Version { get }

}


// MARK: デフォルト実装

extension DMMRequest {

    /// バージョン指定のデフォルト値
    public var version: DMMAPI.Version {
        return DMMAPI.Version.v3
    }

    /// The base URL.
    public var baseURL: URL {
        var compo = URLComponents()
        compo.scheme = DMMAPI.scheme
        compo.host = DMMAPI.host
        if let url = compo.url {
            return url
        }
        assertionFailure()
        return URL(string: "")!
    }

    /// Create and return RxSwift Observable object.
    public func asObservable() -> Observable<Response> {
        return Session.rx_sendRequest(self)
    }

    /// Generate API path string.
    /// - note: APIパスの生成処理
    ///
    func makePath(path: String) -> String {
        return DMMAPI.makePath(version: self.version) + path
    }

    /// APP ID, アフィリエイトid パラメータ作成用
    /// - note: authを必要とするAPI呼び出しでは、parametersでこれを用いる
    ///

    var parametersWithAppId: [String: Any] {
        return [
            "api_id":       Constants.api_id,
            "affiliate_id": Constants.affiliate_id,
            "hits":         Constants.hits,
            "output":       Constants.output
        ]
    }

}

extension DMMRequest where Response: DMMResponse {

    /// The parser object that states `Content-Type` to accept and parses response body.
    public var dataParser: DataParser { return DMMDataParser() }

    /// Date parsing format string.
    var dateFormat: String { return "yyyy-MM-dd'T'HH:mm:ss.SSSZ" }

    /// Build `Response` instance from raw response object.
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(
            {
                let f = DateFormatter()
                f.calendar = Calendar(identifier: .gregorian)
                f.locale = Locale(identifier: "en_US_POSIX")
                f.dateFormat = dateFormat
                return f
            }()
        )
        do {
            return try decoder.decode(Response.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }

}

// MARK: - APIKit.Responseの雛形定義

/**
 * papafunny API Response protocol.
 */
public protocol DMMResponse: Decodable {

    /// Response entity object type
    associatedtype Entity: Decodable

    /// Status Code from API.
    /// - note: status or object    ステータスコードはIntだったりStringだったりするので取得しない
    //var status: Int? { get }

    /// - note: result_count or object
    var result_count: Int? { get }

    /// - note: total_count or object
    //var total_count: Int? { get }

    /// - note: first_position or object
    //var first_position: Int? { get }

    /// Result object in response.
    /// - note: error_code or object
    var object: Entity? { get }
    
}

// MARK: - JSONパース処理

/**
 * Data parser class
 * - note: objectキー追加処理
 */
final class DMMDataParser: DataParser {

    /// Value for `Accept` header field of HTTP request.
    var contentType: String? { return "application/json" }

    /// Return `Any` that expresses structure of response such as JSON and XML.
    /// - Throws: `Error` when parser encountered invalid format data.
    func parse(data: Data) throws -> Any {
        let json = JSON(data)
        var dict = [String: Any]()
        let result = json.dictionaryValue.filter({ $0.key == "result" })
        dict["status"]          = result["result"]?["status"]
        dict["result_count"]    = result["result"]?["result_count"]
        dict["total_count"]     = result["result"]?["total_count"]
        dict["first_position"]  = result["result"]?["first_position"]
        // result以下を取り出す
        dict["object"]          = result["result"]
        // エラー
        dict["error"]           = result["result"]?["errors"]

        return try JSON(dict).rawData()
    }

}

