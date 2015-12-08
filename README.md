# ChineseSubdivisionsPicker
## 中国行政区划选择器

ChineseSubdivisionsPicker is a simple Chinese Subdivisions picker inherited from UIPickerView and written in Swift.

中国行政区划选择器继承自 UIPickerView，使用 swift 实现。

<img src="https://raw.githubusercontent.com/huajiahen/ChineseSubdivisionsPicker/master/ScreenShot.png" width="320px" />

You can let user pick province, city and district data from it.

用户可以选择省、市或区。你可以定制选择器的最小选择粒度。

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
Available picker types are .Province .City and .District
Picker type is .District in default. 

可选的选择器类型为 .Province（只可选择省份） .City（可选择省市） and .District（可选择省市区），默认的选择器类型是 .District（可选择省市区）。

#### pickerDelegate: ChineseSubdivisionsPickerDelegate
You should implement ```swift subdivisionsPickerDidUpdate()``` in your pickerDelegate(a UIViewController in usual) to receive callback when picker value is changed.

你需要在你的 pickerDelegate（通常是一个 UIViewController）里实现 ```swift subdivisionsPickerDidUpdate()``` 方法，ChineseSubdivisionsPicker 会在更新选定的省市区时调用这个方法。

#### province, city, district: String?
You can fetch current province, city and district name.

可通过 province, city, district 属性获取到目前选择的省市区的名字。

### Note
Change dataSource or delegate will not work. You should  change pickerDelegate instead.

注意，ChineseSubdivisionsPicker 的 dataSource 和 delegate 是无法修改的（否则Picker 无法正常工作）。如果你想要接受回调，应该修改 pickerDelegate 属性。

## Installation

### CocoaPods

KeychainAccess is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

#### iOS7
```ruby
platform :ios, '7.0'
pod 'ChineseSubdivisionsPicker'
```

#### iOS8 or later

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'ChineseSubdivisionsPicker'
```

### To manually add to your project

1. Add all files in `ChineseSubdivisionsPicker/` to your project
2. that's all!

## Author

huajiahen, forgottoon@gmail.com	

## License

ChineseSubdivisionsPicker is available under the MIT license. See the LICENSE file for more info.
