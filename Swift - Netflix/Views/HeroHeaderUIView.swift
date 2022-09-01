//
//  HeroHeaderUIView.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import Alamofire

class HeroHeaderUIView: UIView {
  
    // 两种初始化方法
//    private var downloadButton: UIButton {
//        let button = UIButton()
//        button.setTitle("Download", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 5
//        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func onTap() {
        print("TapSucceed")
    }
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


//MARK: - 方法
extension HeroHeaderUIView {
    
    /// 渐变
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    /// headview - buttons 的 constraints
    private func applyConstraints() {
        
        playButton.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset((UIScreen.main.bounds.width - 240 - 40)/2)
            make.bottom.equalTo(self.snp.bottom).offset(-50)
            make.width.equalTo(120)
        }
        downloadButton.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-(UIScreen.main.bounds.width - 240 - 40)/2)
            make.bottom.equalTo(self.snp.bottom).offset(-50)
            make.width.equalTo(120)
        }
//        let playButtonConstraints = [
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (UIScreen.main.bounds.width - 240 - 40)/2),
//            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            playButton.widthAnchor.constraint(equalToConstant: 120)
//        ]
//        let downloadButtonConstraints = [
//            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(UIScreen.main.bounds.width - 240 - 40)/2),
//            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            downloadButton.widthAnchor.constraint(equalToConstant: 120)
//        ]
//        NSLayoutConstraint.activate(playButtonConstraints)
//        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    /// headview的image（异步+缓存）
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        heroImageView.kf.setImage(with: url)
    }
}
