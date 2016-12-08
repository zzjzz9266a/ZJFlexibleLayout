//
//  CustomHeader.swift
//  ZJFlexibleLayoutDemo
//
//  Created by 张智杰 on 2016/12/9.
//  Copyright © 2016年 ZhijieZhang. All rights reserved.
//

import UIKit

class CustomHeader: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
