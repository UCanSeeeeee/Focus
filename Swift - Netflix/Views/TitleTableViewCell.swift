//
//  TitleTableViewCell.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit

class TitleTableViewCell: UITableViewCell {


    static let identifier = "TitleTableViewCell"
    
    private lazy var playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func onTap() {
        print("TapSucceed")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // 相辅相成
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

//MARK: - 自定义方法
extension TitleTableViewCell {
    // 改
    private func applyConstraints() {
        titlesPosterUIImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(titlesPosterUIImageView.snp.right).offset(20)
            make.right.equalTo(playTitleButton.snp.left).offset(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        playTitleButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(35)
        }
//        let titlesPosterUIImageViewConstraints = [
//            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
//        ]
//
//        let titleLabelConstraints = [
//            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -10),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//        ]
        
//        let playTitleButtonConstraints = [
//            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            playTitleButton.widthAnchor.constraint(equalToConstant: 35)
//        ]
        
//        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
//        NSLayoutConstraint.activate(titleLabelConstraints)
//        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    // 注册cell后传入数据
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlesPosterUIImageView.kf.setImage(with: url)
        titleLabel.text = model.titleName
    }
}
