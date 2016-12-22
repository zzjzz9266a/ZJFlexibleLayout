//
//  ViewController.swift
//  ZJFlexibleLayoutDemo
//
//  Created by 张智杰 on 2016/12/9.
//  Copyright © 2016年 ZhijieZhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource = [[CGSize]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
        creatDataSource()
    }

    //生成随机尺寸
    func creatDataSource(){
        for index in 0..<4{
            var sectionData = [CGSize]()
            for _ in 0..<(index+1)*5{
                let width = CGFloat(arc4random_uniform(100) + 50)
                let height = CGFloat(arc4random_uniform(100) + 50)
                sectionData.append(CGSize(width: width, height: height))
            }
             dataSource.append(sectionData)
        }
    }
    
    func collectionViewInit(){
        let layout = ZJFlexibleLayout(delegate: self)
        
        //设置headerView
        let headerView = UILabel(frame: CGRect(x: 0, y: 10, width: kScreenWidth, height: 200))
        headerView.textAlignment = .center
        headerView.attributedText = NSAttributedString(string: "我是CollectionHeaderView", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white])
        headerView.backgroundColor = .green
        layout.collectionHeaderView = headerView
        
        collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CustomHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
}

extension ViewController: ZJFlexibleLayoutDataSource{
    
    func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGSize {
        return dataSource[indexPath.section][indexPath.item]
    }
    
    func numberOfCols(at section: Int) -> Int {
        return section+1
    }
    
    func spaceOfCells(at section: Int) -> CGFloat{
        return 12
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 15, right: 20)
    }
    
    func sizeOfHeader(at section: Int) -> CGSize{
        return CGSize(width: kScreenWidth, height: 100)
    }
    
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
}

extension ViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.label.text = "\(indexPath)"
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! CustomHeader
        header.label.text = "我是第\(indexPath.section)个sectionHeader"
        header.backgroundColor = .black
        return header
    }
}

extension UIColor{
    
    static func randomColor() -> UIColor{
        let color1:CGFloat = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let color2:CGFloat = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let color3:CGFloat = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        return UIColor(red: color1, green: color2, blue: color3, alpha: 1)
    }
}
