# 中文介绍

- [功能](#功能)
- [环境要求](#环境要求)
- [安装](#安装)
- [如何使用](#如何使用)
- [开源协议](#开源协议)


## 功能

- [x] 设计优雅，使用方便
- [x] 可适用于各种各样的流式布局
- [x] 纯Swift项目

## 环境要求
- iOS 8.0+
- Xcode 8.3+
- Swift 3.1+

## 安装

### CocoaPods
`Podfile`配置如下：
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ZJFlexibleLayout'
end
```
### Carthage

`Cartfile`配置如下：

```ogdl
github "zzjzz9266a/ZJFlexibleLayout"
```
运行 `carthage update` 之后把生成的`ZJFlexibleLayout.framework` 拖进项目。

## 如何使用
 1、创建一个 `ZJFlexibleLayout`并添加代理，在创建`UICollectionView`的时候把layout传进去：
``` swift 
let layout = ZJFlexibleLayout(delegate: self)
layout.collectionHeaderView = headerView    //could be nil
collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: layout)
```
2、实现协议`ZJFlexibleDataSource`，只需要实现前两个方法即可：
``` swift
protocol ZJFlexibleLayoutDataSource: class{

    //控制对应section的瀑布流列数
    func numberOfCols(at section: Int) -> Int
    //控制每个cell的尺寸，实质上就是获取宽高比
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

## Demo
<p align="center">
    <img src="https://github.com/zzjzz9266a/ZJFlexibleLayout/blob/master/ZJFlexibleLayout.gif">
</p>

## 开源协议

ZJFlexibleDataLayout 遵循 MIT 开源协议，具体查看[LICENSE](https://github.com/zzjzz9266a/ZJFlexibleLayout/blob/master/LICENSE).
