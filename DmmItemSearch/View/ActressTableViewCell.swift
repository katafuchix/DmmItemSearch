//
//  ActressTableViewCell.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import AlamofireImage
import RxCocoa
import RxSwift

class ActressTableViewCell: UITableViewCell {

    @IBOutlet weak var actressImageView: UIImageView!
    @IBOutlet weak var actressNameLabel: UILabel!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var ppmButton: UIButton!
    @IBOutlet weak var monoButton: UIButton!
    @IBOutlet weak var rentalButton: UIButton!

    var disposeBag = DisposeBag()
    var actress: ActressEntity!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func clear() {
        self.actressImageView.image = nil
        self.actressImageView.gestureRecognizers = []
        self.actressNameLabel.text = ""
        self.actressNameLabel.gestureRecognizers = []
        self.actress = nil
        self.disposeBag = DisposeBag()
    }

    func configure(_ entity: ActressEntity){
        self.clear()

        self.actress = entity
        self.actressNameLabel.text = self.actress.name
        
        self.actressImageView.image = UIImage(named: "no_image")
        if let imageURL = entity.imageURL?.large {
            let url = URL(string: imageURL)!
            self.actressImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "no_image"), imageTransition: .crossDissolve(3))
        }

        let tapGesture = UITapGestureRecognizer()
        self.actressNameLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
            if let url = self?.actress.listURL?.digital {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)

        let tapImageGesture = UITapGestureRecognizer()
        self.actressImageView.addGestureRecognizer(tapImageGesture)
        tapImageGesture.rx.event.bind(onNext: { [weak self] recognizer in
            if let url = self?.actress.listURL?.digital {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)

        self.monthlyButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            if let url = self?.actress.listURL?.monthly {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)

        self.ppmButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            if let url = self?.actress.listURL?.ppm {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)

        self.monoButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            if let url = self?.actress.listURL?.mono {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)

        self.rentalButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            if let url = self?.actress.listURL?.rental {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            }
        }).disposed(by: self.disposeBag)
    }
}
