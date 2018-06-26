//
//  ActressSearchViewController.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import MBProgressHUD
import APIKit

class ActressSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.separatorInset = .zero
        }
    }

    // MARK: - ViewModel

    let viewModel = ActressViewModel()

    // MARK: - rx

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.bind()
    }

    // MARK: - bind
    func bind() {
        // 検索バー
        self.searchBar.rx.text.asObservable()
            .map { $0 ?? "" }
            .bind(to: self.viewModel.keyword)
            .disposed(by: rx.disposeBag)

        // 検索ボタン
        self.searchBar.rx.searchButtonClicked.asDriver()
            .drive(onNext :{ [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.searchBar.showsCancelButton = false
                self?.viewModel.refresh()
                self?.fetch() })
            .disposed(by: rx.disposeBag)

        // キャンセルボタン
        self.searchBar.rx.cancelButtonClicked.asDriver()
            .drive(onNext :{ [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.searchBar.showsCancelButton = false
            }).disposed(by: rx.disposeBag)

        self.searchBar.rx.textDidBeginEditing.asDriver().drive(onNext: { [weak self] in
                self?.searchBar.showsCancelButton = true
            })
            .disposed(by: rx.disposeBag)

        // UITableViewCell Items
        self.viewModel.items.asObservable().bind(to:
                tableView.rx.items(cellIdentifier: "ActressTableViewCell", cellType: ActressTableViewCell.self))
                    {
                        index, model, cell in
                            cell.configure(model)
                    }
            .disposed(by: rx.disposeBag)

        // ページング
        self.tableView.rx.willDisplayCell.subscribe(onNext: { [weak self] (cell, indexPath) in
            if (self?.viewModel.isEndOfSections(indexPath))! {
                self?.fetch()
            }
        }).disposed(by: rx.disposeBag)

        // ローディング
        self.viewModel.isLoading.asDriver()
            .drive(MBProgressHUD.rx.isAnimating(view: self.view))
            .disposed(by: rx.disposeBag)

        /*
        // UITableViewCell Items
        // 入力結果でそのまま検索してすぐテーブルに表示する場合
        self.searchBar.rx.text.orEmpty.asObservable()
            .map { ActressesRequest(searchConditions: ["keyword": $0], page: 0) }
            .flatMap { request ->  Observable<[ActressEntity]> in
                return self.getActresses(request)
            }
            .bind(to: tableView.rx.items(cellIdentifier: "ActressTableViewCell", cellType: ActressTableViewCell.self))
                {
                    index, entity, cell in cell.configure(entity)
                }
          .disposed(by: rx.disposeBag)
        */
    }

    // データ取得
    private func fetch() {
        if self.viewModel.isLoading.value || self.viewModel.isFinishedPaging.value || self.viewModel.keyword.value.isEmpty { return }
        viewModel.fetch().subscribe(
            onError: {
                print($0.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
    
    // ActressesRequestを生成する クロージャでもOK
    func getActresses(_ request: ActressesRequest) -> Observable<[ActressEntity]> {
        return Observable.create( { observer in
            //print(try! req.buildURLRequest().asURLRequest().url ?? "")
            let task = Session.send(request) {
                switch $0 {
                case .success(let response):
                    // Entityのチェック
                    guard let entity = response.object else {
                        observer.on(.error(DMMAPIError.itemsNotExist))
                        return
                    }
                    observer.on(.next(entity.actress))
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
