//
//  ItemsTableViewCell.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    var item: ItemEntity!
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func clear() {
        self.itemTitleLabel.text = ""
        self.itemTitleLabel.gestureRecognizers = []
        self.itemImageView.image = nil
        self.item = nil
        self.disposeBag = DisposeBag()
    }

    func configure(_ item:ItemDomainModel) {
        self.clear()

        self.item = item.item
        self.itemTitleLabel.text = self.item.title!

        if let smallImageURL = self.item.imageURL?.large {
            let url = URL(string: smallImageURL)!
            self.itemImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "no_image"), imageTransition: .crossDissolve(3))
        }
        self.itemImageView.contentMode = .top

        let textAttributes: [NSAttributedStringKey : Any] = [
            .font : UIFont(name:"HelveticaNeue-Bold",size:18.0) ?? UIFont.systemFont(ofSize: 18.0),
            .foregroundColor : UIColor.white,
            .strokeColor : UIColor.black,
            .strokeWidth : -1.0
        ]
        let text = NSAttributedString(string: self.item.title!, attributes: textAttributes)
        self.itemTitleLabel.attributedText = text

        let tapGesture = UITapGestureRecognizer()
        self.itemTitleLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
            if let url = self?.item.affiliateURL{
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)
    }
}
