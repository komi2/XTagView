# XTagView

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

## Overview

`XTagView` is View arranging tag label automatically.

<img width="400" alt="2018-10-12 14 39 21" src="https://user-images.githubusercontent.com/2538808/46849958-c5f74680-ce2c-11e8-81b3-3b239e6a7084.png">



## Installation

### Carthage

Add `XTagView` in your Cartfile.

```
github "komi2/XTagView" == 0.2.0
```

## Usage

Import `XTagView` at first.

```swift
import XTagView
```
### Initialization

```swift
let option = XTagViewOption(
  insets: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6),
  marginX: CGFloat(6),
  marginY: CGFloat(6),
  font: UIFont.systemFont(ofSize: 14),
  containerWidth: CGFloat(300),
  titleColor: .white,
  backgroundColor: .black,
  cornerRadius: CGFloat(12),
  labelInsets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
)

let xTagView = XTagView(option: option)
```

### Deploying text

```swift
let titles = [
  "strawberry", "cherry", "watermelon",
  "plum", "pear", "pineapple"
]

xTagView.updateTags(titles: titles)
```

### Control

You can control `XTagView` by using `XTagViewDelegate`.

#### Touch event of tag selected.

```swift
  
func selectTag(sender: UILabel) {
  print(sender.text ?? "none")
}
```

#### Edit label background color.

<img width="400" alt="2018-10-12 14 37 42" src="https://user-images.githubusercontent.com/2538808/46851494-a236ff00-ce32-11e8-8c2e-67839f23f128.png">


```swift
func backgroundColor(index: Int, title: String, currentColor: UIColor) -> UIColor {
  return self.colors[index % 3]
}
```

#### Edit label title color.

```swift
func titleColor(index: Int, title: String, currentColor: UIColor) -> UIColor {
  return self.colors[index % 3]
}
```

