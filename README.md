<p align="center">
    <a href="https://github.com/zzjzz9266a/ZJFlexibleLayout"><img src="https://github.com/zzjzz9266a/ZJFlexibleLayout/blob/master/ZJFlexibleLayout.png"></a>
</p>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ZJFlexibleLayout.svg)](https://github.com/CocoaPods/CocoaPods)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-iOS-green.svg)](https://github.com/zzjzz9266a/ZJFlexibleLayout)
[![Language](https://img.shields.io/badge/language-swift %204.1-orange.svg)](https://github.com/zzjzz9266a/ZJFlexibleLayout)
[![LICENSE](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/zzjzz9266a/ZJFlexibleLayout/blob/master/LICENSE)


ZJFlexibleLayout is a simple UI component of flexible waterfall layout for iOS platform.
## Features

- [x] Easy To Use
- [x] Flexible In Any Layout Including WaterFall
- [x] Written All By Swift

## Requirements
- iOS 8.0+
- Xcode 8.3+
- Swift 3.1+

## Installation
Just drag all the swift files in path of "source" into your project.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build ZJFlexibleLayout 4.0+.

To integrate ZJFlexibleLayout into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ZJFlexibleLayout'
end
```
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ZJFlexibleLayout into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "zzjzz9266a/ZJFlexibleLayout"
```
Run `carthage update` to build the framework and drag the built `ZJFlexibleLayout.framework` into your Xcode project.

## Usage
 1、Create a `collectionview`，and set the delegate for `layout`：
``` swift 
let layout = ZJFlexibleLayout(delegate: self)
layout.collectionHeaderView = headerView    //could be nil
collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: layout)
```
2、Implement the protocol `ZJFlexibleDataSource`：
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
## License

ZJFlexibleDataLayout is released under the MIT license. [See LICENSE](https://github.com/zzjzz9266a/ZJFlexibleLayout/blob/master/LICENSE) for details.
