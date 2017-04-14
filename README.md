# 引
公司的项目中涉及到多列瀑布流、UITableView与sectionHeader的混合布局，之前的实现方式是以UITableView作为骨架，将带有瀑布流的UICollectionView封装到自定义的UITableViewCell中，但是出现的问题就是当cell中瀑布流的元素过多时，会出现明显的卡顿，而且布局复杂，层次较多，难以维护。故而重新自定义了collectionView的Layout，在仅有一个collectionView的情况下完成了上述的布局。

![这是我们项目.gif](http://upload-images.jianshu.io/upload_images/1324647-a16b3f63f74d4323.gif?imageMogr2/auto-orient/strip)


### 更新：
2016-12-23
1、加入了collectionHeaderView，类似UITableView 中的 tableHeaderView
2、将 sideMargin 改为 sectionInsets，提高布局灵活度


项目基于Swift3.0~~
# 使用
闲话不多说，上代码：
1、首先定义一个collectionview，并设置layout的代理：
``` swift 
let layout = ZJFlexibleLayout(delegate: self)
//如果需要有 headerView 的话，直接传入即可，需提前设置frame
layout.collectionHeaderView = headerView
collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: layout)
```
2、遵守对应的协议：
``` swift
protocol ZJFlexibleLayoutDataSource: class{

//控制对应section的瀑布流列数
    func numberOfCols(at section: Int) -> Int
    //控制每个cell的尺寸，实际上就是获取宽高比
    func sizeOfItemAtIndexPath(at indexPath : IndexPath) -> CGSize
    //控制瀑布流cell的间距
    func spaceOfCells(at section: Int) -> CGFloat
    //section 内边距
    func sectionInsets(at section: Int) -> UIEdgeInsets
    //每个section的header尺寸
    func sizeOfHeader(at section: Int) -> CGSize
    //每个cell的额外高度
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat
}
```
### 协议详解：
#### 1.瀑布流列数
可以随意设置瀑布流列数，如果是单列的话就相当于tableView了
``` Swift
     func numberOfCols(at section: Int) -> Int
```
---
#### 2.cell尺寸
这个应该不用多讲吧，因为cell的宽度在列数确定时就已经算出来了，所以这个方法实质上是获取cell的宽高比
``` Swift
    func sizeOfItemAtIndexPath(at indexPath : IndexPath) -> CGSize
```
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1324647-c1d10bc34034cbab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### 3.cell间距
cell 的上下左右间距，注意不要跟sectionInsets搞混了 
``` Swift
    func spaceOfCells(at section: Int) -> CGFloat
```
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1324647-90ea5f5615c40e6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### 4.section 内边距
这个是最近才加上的，可以让每个section都有一个内边距
```Swift
    func sectionInsets(at section: Int) -> UIEdgeInsets
```
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1324647-c6d16eb2238ec1c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### 5.每个section的header尺寸
sectionHeader如果宽度小于屏宽，会自动居中
```Swift
    func sizeOfHeader(at section: Int) -> CGSize
```

#### 6.cell的额外高度
此方法是专门公司项目的需求提出的，图中标明的部分高度是不固定的，需要根据数据进行判断
```Swift
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat
```
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1324647-4ce5208fae820967.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
# 结束语

[Demo](https://github.com/zzjzz9266a/ZJFlexibleLayout)已经放到GitHub上了，欢迎大家Star，也请大家不要吝啬好的建议哈~~

![这是demo.gif](http://upload-images.jianshu.io/upload_images/1324647-5d3076da5d2aebff.gif?imageMogr2/auto-orient/strip)
