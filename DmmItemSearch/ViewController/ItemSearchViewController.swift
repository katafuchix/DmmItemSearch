//
//  ViewController.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import MBProgressHUD

class ItemSearchViewController: UIViewController {

    // MARK: - ViewModel

    let viewModel = ItemsViewModel()

    // MARK: - rx

    /// RxDataSource Object
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<ItemSectionDomainModel> = setupDataSources()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorInset = .zero
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        /*
        // インクリメンタルサーチを行う場合
        self.viewModel.keyword.asObservable()
            .subscribe(onNext: { [weak self] _ in self?.viewModel.refresh(); self?.fetch() })
            .disposed(by: rx.disposeBag)
        */
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
        self.viewModel.sectionItems.asObservable()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
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

        // UITableViewDelegateを使いたい場合はこうする
        //self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }

    // データ取得
    private func fetch() {
        if self.viewModel.isLoading.value || self.viewModel.isFinishedPaging.value || self.viewModel.keyword.value.isEmpty { return }
        viewModel.fetch().subscribe(
            onError: {
                print($0.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }

    // DataSource準備
    private func setupDataSources() -> RxTableViewSectionedReloadDataSource<ItemSectionDomainModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<ItemSectionDomainModel>(configureCell:
        { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsTableViewCell", for: indexPath) as! ItemsTableViewCell
            cell.configure(item)
            return cell
        })
        return dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
// MARK: - UITableViewDelegate
extension ItemSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
*/

