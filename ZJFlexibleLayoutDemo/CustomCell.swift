//
//  CustomCell.swift
//  ZJFlexibleLayoutDemo
//
//  Created by 张智杰 on 2016/12/9.
//  Copyright © 2016年 ZhijieZhang. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
