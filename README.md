# ZJFlexibleLayout
基于UICollectionView的自定义瀑布流

#引
公司的项目中涉及到多列瀑布流、UITableView与sectionHeader的混合布局，之前的实现方式是以UITableView作为骨架，将带有瀑布流的UICollectionView封装到自定义的UITableViewCell中，但是出现的问题就是当cell中瀑布流的元素过多时，会出现明显的卡顿，而且布局复杂，层次较多，难以维护。故而重新自定义了collectionView的Layout，在仅有一个collectionView的情况下完成了上述的布局。


![这是我们项目.gif](http://upload-images.jianshu.io/upload_images/1324647-a16b3f63f74d4323.gif?imageMogr2/auto-orient/strip)

![这是Demo.gif](http://upload-images.jianshu.io/upload_images/1324647-7d01db4281ea499b.gif?imageMogr2/auto-orient/strip)

项目基于Swift3.0~~
#使用
闲话不多说，上代码：
1、首先定义一个collectionview，并设置layout的代理：
        
    let layout = ZJFlexibleLayout(delegate: self)
    collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: layout)

2、遵守对应的协议：

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
只要遵守这个协议，就可以控制瀑布流的每个参数，包括：
    
    cell尺寸：sizeOfItemAtIndexPath
    瀑布流列数：numberOfCols
    cell间距：spaceOfCells
    左右边距：sideMargin
    header尺寸：sizeOfHeader
    cell的额外高度：heightOfAdditionalContent

怎么样，简单吧？
欢迎大家关注我的[简书]()
