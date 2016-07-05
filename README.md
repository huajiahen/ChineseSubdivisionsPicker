# ChineseSubdivisionsPicker

ChineseSubdivisionsPicker is a simple Chinese Subdivisions picker inherited from UIPickerView and written in Swift.

<img src="https://raw.githubusercontent.com/huajiahen/ChineseSubdivisionsPicker/master/ScreenShot.png" width="320px" />

You can let user pick province, city and district data from it.

Campatible from iOS7 to iOS9.

## Usage

```swift
let myPicker = ChineseSubdivisionsPicker() 
//You can also use Interface Builder to create a ChineseSubdivisionsPicker
myPicker.pickerType = .District
myPicker.pickerDelegate = self
```

### Basics
#### pickerType: ChineseSubdivisionsPicker.ChineseSubdivisionsPickerType
Available picker types are `.Province` `.City` and `.District`
Picker type is `.District` in default. 

#### pickerDelegate: ChineseSubdivisionsPickerDelegate
You should implement `subdivisionsPickerDidUpdate()` in your pickerDelegate 
(a UIViewController in usual) to receive callback when picker value is changed.

Note: Delegate method will be called when you set `province`, `city` and `district` value.

#### province, city, district: String?
You can fetch & set province, city and district name. 

Note that you must set these value in logic order (aka. From province to city then to district), and the value you set MUST match exactly with which in `ChineseSubdivisions.plist`. Value setting MUST perform on main thread.

### Note
Changing `dataSource` or `delegate` of ChineseSubdivisionsPicker will not work. 
You should change `pickerDelegate` instead for receiving callback.

## Installation

### Carthage (iOS8 or later)

add this to your Cartfile

```
github "huajiahen/ChineseSubdivisionsPicker"
```

and run `carthage update`. For detail usage of carthage, pls visit [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods (iOS8 or later)

ChineseSubdivisionsPicker is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following lines to your Podfile:

```ruby
use_frameworks!
pod 'ChineseSubdivisionsPicker'
```

Due to iOS limitation, you can not intergrate swift file 
(such as ChineseSubdivisionsPicker) with cocoapods in project
 which deployment targer is iOS7.
But you can follow `To manually add to your project` below.

### To manually add to your project

1. Add all files in `ChineseSubdivisionsPicker/` to your project
2. that's all!

## Author

huajiahen, forgottoon@gmail.com	

## License

ChineseSubdivisionsPicker is available under the MIT license. 
See the LICENSE file for more info.

***

ps: 以下为中文介绍，安装方法请参考英文说明。

## 中国行政区划选择器
中国行政区划选择器继承自 UIPickerView，使用 swift 实现。

<img src="https://raw.githubusercontent.com/huajiahen/ChineseSubdivisionsPicker/master/ScreenShot.png" width="320px" />

用户可以选择省、市或区。你可以定制选择器的最小选择粒度。

支持iOS7以上

## 使用方法

Demo请参考项目主目录下的`ChineseSubdivisionsPickerExample`.

```swift
let myPicker = ChineseSubdivisionsPicker() 
//You can also use Interface Builder to create a ChineseSubdivisionsPicker
myPicker.pickerType = .District
myPicker.pickerDelegate = self
```

### 主要类型
#### pickerType: ChineseSubdivisionsPicker.ChineseSubdivisionsPickerType
可选的选择器类型为 `.Province`（只可选择省份） `.City`（可选择省市） and `.District`
（可选择省市区），默认的选择器类型是 `.District`（可选择省市区）。

#### pickerDelegate: ChineseSubdivisionsPickerDelegate
你需要在你的 pickerDelegate（通常是一个 UIViewController）里实现 
`subdivisionsPickerDidUpdate()` 方法，ChineseSubdivisionsPicker 
会在更新选定的省市区时调用这个方法。

注意，你直接设置 province, city 和 district 属性时也会触发这个回调方法。

#### province, city, district: String?
可通过 `province`, `city`, `district` 属性获取到目前选择的省市区的名字。
此外，你也可以通过将他们设置为`ChineseSubdivisions.plist`中的省市区名字从而更新选择器的UI。需要注意，设置省市区必须按照逻辑顺序（即先设置省，接着市，最后设置区），且设置这些属性必须在主线程进行。

### 特别提醒
注意，ChineseSubdivisionsPicker 的 `dataSource` 和 `delegate` 修改是不会生效的（始终为Picker自己）。如果你想要接受回调，应该修改 `pickerDelegate` 属性。
