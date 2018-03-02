# react-native-core-image

react-native-core-image is currently only supported on iOS. This is meant to expose the Core Image library built into iOS.

## Getting started

`$ npm install react-native-core-image --save`

### Mostly automatic installation

`$ react-native link react-native-core-image`

### Manual installation

#### iOS

1.  In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2.  Go to `node_modules` ➜ `react-native-core-image` and add `RNCoreImage.xcodeproj`
3.  In XCode, in the project navigator, select your project. Add `libRNCoreImage.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4.  Run your project (`Cmd+R`)<

## Usage

```javascript
import CoreImage from "react-native-core-image";

CoreImage.processBlurredImage(localFileUrl, blurRadius, (err, imageFileUrl) => {
    this.setState({
      imageFileUrl,
    });
  }
);
```
