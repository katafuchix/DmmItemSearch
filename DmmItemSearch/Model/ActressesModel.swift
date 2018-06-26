//
//  ActressModel.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

/**
 * 女優検索モデルクラス
 *  本来ならプロパティ/メソッドでプロトコルを切る
 */
public class ActressesModel {

    private var pageStatus: DMMPageStatus? = nil

    func fetch(_ searchWord: String, _ page: Int) -> Observable<[ActressEntity]> {
        return Observable.create( { observer in
            let req = ActressesRequest(searchConditions: ["keyword": searchWord], page: page)
            //print(try! req.buildURLRequest().asURLRequest().url ?? "")
            let task = Session.send(req) { [weak self] in 
                switch $0 {
                case .success(let response):
                    // Entityのチェック
                    guard let entity = response.object else {
                        observer.on(.error(DMMAPIError.itemsNotExist))
                        return
                    }
                    // Entityからページング情報を保存
                    self?.pageStatus = DMMPageStatus(paging: entity)
                    observer.on(.next(entity.actress))
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })//.debug()
    }
}
