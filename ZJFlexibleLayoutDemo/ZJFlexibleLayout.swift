//
//  ZJFlexibleLayout.swift
//  
//
//  Created by 张智杰 on 2016/12/9.


import UIKit
let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = kScreenSize.width
let kScreenHeight = kScreenSize.height
//用来储存每一列的坐标
typealias ColHeight = (index:Int,cellHeight:CGFloat)

struct HeightSaver {
    //每个section的高度：返回最大值
    var sectionHeight: CGFloat{
        if let max = rowHeights.max(by: {$0.cellHeight<$1.cellHeight}){
            return max.cellHeight
        }
        return 0
    }
    var rowHeights: [ColHeight]
}

protocol ZJFlexibleLayoutDataSource: class{
    //控制对应section的瀑布流列数
    func numberOfCols(at section: Int) -> Int
    //控制每个cell的尺寸，实际上就是获取宽高比
    func sizeOfItemAtIndexPath(at indexPath : IndexPath) -> CGSize
    //控制瀑布流cell的间距
    func spaceOfCells(at section: Int) -> CGFloat
    //边距
    func sideMargin(at section: Int) -> CGFloat
    //每个section的header尺寸
    func sizeOfHeader(at section: Int) -> CGSize
    //每个cell的额外高度
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat
}

extension ZJFlexibleLayoutDataSource{
    func spaceOfCells(at section: Int) -> CGFloat{
        return 0
    }
    
    func sideMargin(at section: Int) -> CGFloat{
        return 0
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
        if let max = colHeights.last?.sectionHeight{
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
                    let preSectionH = section==0 ? 0 : colHeights[max(section-1,0)].sectionHeight
                    let headerSize = delegate.sizeOfHeader(at: section)
                    let headerX = (kScreenWidth - headerSize.width)/2
                    let headerH = headerSize.height
                    
                    //拼接header 的layoutAttributes
                    let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                    headerAttributes.frame = CGRect(x: headerX, y: preSectionH, width: headerSize.width, height: headerSize.height)
                    layoutHeaderViewInfo.append(headerAttributes)
                    
                    //每个section开始计算height清零
                    var rowSavers:[ColHeight] = []
                    for index in 0..<delegate.numberOfCols(at: section){
                        rowSavers.append((index,preSectionH+headerH))
                    }
                    colHeights.append(HeightSaver(rowHeights: rowSavers))
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
            let sideMargin = delegate.sideMargin(at: indexPath.section)
            let space = delegate.spaceOfCells(at: indexPath.section)
            let colNum = CGFloat(delegate.numberOfCols(at: indexPath.section))
            let spaceNum = CGFloat(delegate.numberOfCols(at: indexPath.section)-1)
            let realCellWidth = (kScreenWidth - sideMargin*2 - space*spaceNum)/colNum
            let itemSize = delegate.sizeOfItemAtIndexPath(at: indexPath)
            var originX : CGFloat = delegate.sideMargin(at: indexPath.section)
            var originY : CGFloat = delegate.sideMargin(at: indexPath.section)
            var cellHeight : CGFloat = 0.0
            
            //根据图片宽高计算cell高度
            if itemSize.width > 0
            {
                cellHeight = realCellWidth * itemSize.height / itemSize.width
            }
            //控制cell高度：最大480，最小100
//            cellHeight = max(kArtWaterfallMinImageHeight, cellHeight)
//            cellHeight = min(kArtWaterfallMaxImageHeight, cellHeight)
            
            cellHeight += delegate.heightOfAdditionalContent(at: indexPath)
            
            //找到最小高度
            if var min = colHeights[indexPath.section].rowHeights.min(by: {$0.cellHeight<$1.cellHeight}){
                originX = sideMargin + realCellWidth*CGFloat(min.index) + space*CGFloat(min.index)
                originY = min.cellHeight
                min.cellHeight += cellHeight
                
                colHeights[indexPath.section].rowHeights.remove(at: min.index)
                colHeights[indexPath.section].rowHeights.insert(min, at: min.index)
            }
            
            return CGRect(x: originX, y: originY, width: realCellWidth, height: cellHeight)
        }
        return CGRect.zero
    }
    
    func layoutInit() {
        colHeights.removeAll()
        layoutInfo.removeAll()
        layoutHeaderViewInfo.removeAll()
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

