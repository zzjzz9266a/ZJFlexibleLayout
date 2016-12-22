//
//  ZJFlexibleLayout.swift
//  
//
//  Created by 张智杰 on 2016/12/9.


import UIKit
//private
let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = kScreenSize.width
let kScreenHeight = kScreenSize.height

//用来储存每一列的坐标
typealias ColHeight = (index:Int,colHeight:CGFloat)

struct HeightSaver {
    //每个section的高度：返回最大值
    var sectionHeight: CGFloat{
        if let max = colHeights.max(by: {$0.colHeight<$1.colHeight}){
            return max.colHeight
        }
        return 0
    }
    var colHeights: [ColHeight]
}

protocol ZJFlexibleLayoutDataSource: class{
    //控制对应section的瀑布流列数
    func numberOfCols(at section: Int) -> Int
    //控制每个cell的尺寸，实际上就是获取宽高比
    func sizeOfItemAtIndexPath(at indexPath : IndexPath) -> CGSize
    //控制瀑布流cell的间距
    func spaceOfCells(at section: Int) -> CGFloat
    //边距
    func sectionInsets(at section: Int) -> UIEdgeInsets
    //每个section的header尺寸
    func sizeOfHeader(at section: Int) -> CGSize
    //每个cell的额外高度
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat
}

extension ZJFlexibleLayoutDataSource{
    func spaceOfCells(at section: Int) -> CGFloat{
        return 0
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.zero
    }
    
    func sizeOfHeader(at section: Int) -> CGSize{
        return CGSize.zero
    }
    
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
}

class ZJFlexibleLayout: UICollectionViewLayout {
    
    weak var dataSourceDelegate : ZJFlexibleLayoutDataSource?
    var collectionHeaderView: UIView?{
        willSet{
            collectionHeaderView?.removeFromSuperview()
        }
        didSet{
            collectionView?.reloadData()
        }
    }
    
    //暂存
    var layoutInfo: [UICollectionViewLayoutAttributes] = []
    var layoutHeaderViewInfo: [UICollectionViewLayoutAttributes] = []
    var colHeights:[HeightSaver] = []    //坐标寄存器
    
    override init() {
        super.init()
    }
    
    convenience init(delegate: ZJFlexibleLayoutDataSource){
        self.init()
        dataSourceDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var collectionViewContentSize : CGSize {
        if var max = colHeights.last?.sectionHeight{
            if let delegate = self.dataSourceDelegate{
                max += delegate.sectionInsets(at: colHeights.count-1).bottom
            }
            return CGSize(width: kScreenWidth, height: max)
        }
        return CGSize.zero
    }
    
    override func prepare() {
        //每次reloadData()后需要layout
        layoutInit()
        
        if let sectionNum = collectionView?.numberOfSections{
            for section in 0..<sectionNum{
                if let delegate = dataSourceDelegate{
                    //取(前一个section的Y坐标+当前section的高度)为当前section的初始坐标
                    let originH = collectionHeaderView?.bounds.size.height ?? 0
                    let preSectionH = section==0 ? originH : colHeights[section-1].sectionHeight
                    let preSectionInsetBottom = section==0 ? 0 : delegate.sectionInsets(at: section-1).bottom
                    let currentSectionHeaderY = preSectionH + preSectionInsetBottom - (section==0 ? 0 : delegate.spaceOfCells(at: section-1))
                    let headerSize = delegate.sizeOfHeader(at: section)
                    let headerX = (kScreenWidth - headerSize.width)/2
                    let headerH = headerSize.height
                    
                    //拼接header 的layoutAttributes
                    let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                    headerAttributes.frame = CGRect(x: headerX, y: currentSectionHeaderY, width: headerSize.width, height: headerSize.height)
                    layoutHeaderViewInfo.append(headerAttributes)
                    
                    //每个section开始计算height清零
                    var rowSavers:[ColHeight] = []
                    for index in 0..<delegate.numberOfCols(at: section){
                        //当前section中cell的初始Y：sectionY + sectionHeaderHeight + insetTop
                        let currentSectionY = currentSectionHeaderY + headerH + delegate.sectionInsets(at: section).top
                        rowSavers.append((index,currentSectionY))
                    }
                    colHeights.append(HeightSaver(colHeights: rowSavers))
                }
                
                //拼接cell的layoutAttributes
                if let itemNum = collectionView?.numberOfItems(inSection: section){
                    for item in 0..<itemNum{
                        let indexPath = IndexPath(item: item, section: section)
                        let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        itemAttributes.frame = frameForCellAtIndexPath(indexPath)
                        layoutInfo.append(itemAttributes)
                    }
                }
            }
        }
    }
    
    func frameForCellAtIndexPath(_ indexPath : IndexPath) -> CGRect {
        if let delegate = dataSourceDelegate {
            //计算cell宽度
            let sectionInsets = delegate.sectionInsets(at: indexPath.section)
            
            let space = delegate.spaceOfCells(at: indexPath.section)
            let colNum = CGFloat(delegate.numberOfCols(at: indexPath.section))
            let spaceNum = CGFloat(max(0, delegate.numberOfCols(at: indexPath.section)-1))
            let cellWidth = (kScreenWidth - sectionInsets.left - sectionInsets.right - space*spaceNum)/colNum
            
            let itemSize = delegate.sizeOfItemAtIndexPath(at: indexPath)
            var originX : CGFloat = 0.0
            var originY : CGFloat = 0.0
            var cellHeight : CGFloat = 0.0
            
            //根据图片宽高计算cell高度
            if itemSize.width > 0{
                cellHeight = cellWidth * itemSize.height / itemSize.width
            }
            
            cellHeight += delegate.heightOfAdditionalContent(at: indexPath)
            
            //找到最小高度
            if var min = colHeights[indexPath.section].colHeights.min(by: {$0.colHeight<$1.colHeight}){
                originX = sectionInsets.left + cellWidth*CGFloat(min.index) + space*CGFloat(min.index)
                originY = min.colHeight
                min.colHeight += cellHeight + space
                
                colHeights[indexPath.section].colHeights.remove(at: min.index)
                colHeights[indexPath.section].colHeights.insert(min, at: min.index)
            }
            
            return CGRect(x: originX, y: originY, width: cellWidth, height: cellHeight)
        }
        return CGRect.zero
    }
    
    func layoutInit() {
        colHeights.removeAll()
        layoutInfo.removeAll()
        layoutHeaderViewInfo.removeAll()
        
        //初始化headerView, Y为0
        guard let headerView = collectionHeaderView else {return}
        let headerWidth = headerView.bounds.size.width
        let headerX = (kScreenWidth - headerWidth)/2
        headerView.frame = CGRect(x: headerX, y: 0, width: headerWidth, height: headerView.bounds.size.height)
        collectionView?.addSubview(headerView)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.row >= layoutInfo.count {
            return nil
        }
        return layoutInfo[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result : [UICollectionViewLayoutAttributes] = []
        for index in 0..<layoutInfo.count {
            let itemAttribute = layoutInfo[index]
            if itemAttribute.frame.intersects(rect) {
                result.append(itemAttribute)
            }
        }
        for index in 0..<layoutHeaderViewInfo.count{
            let itemAttribute = layoutHeaderViewInfo[index]
            if itemAttribute.frame.intersects(rect) {
                result.append(itemAttribute)
            }
        }
        return result
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= layoutHeaderViewInfo.count {
            return nil
        }
        return layoutHeaderViewInfo[indexPath.section]
    }
    
}

