# react-native-core-image

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

#### Android

1.  Open up `android/app/src/main/java/[...]/MainActivity.java`

* Add `import com.reactlibrary.RNCoreImagePackage;` to the imports at the top of the file
* Add `new RNCoreImagePackage()` to the list returned by the `getPackages()` method

2.  Append the following lines to `android/settings.gradle`:
    ```
    include ':react-native-core-image'
    project(':react-native-core-image').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-core-image/android')
    ```
3.  Insert the following lines inside the dependencies block in `android/app/build.gradle`:
    ```
      compile project(':react-native-core-image')
    ```

#### Windows

[Read it! :D](https://github.com/ReactWindows/react-native)

1.  In Visual Studio add the `RNCoreImage.sln` in `node_modules/react-native-core-image/windows/RNCoreImage.sln` folder to their solution, reference from their app.
2.  Open up your `MainPage.cs` app

* Add `using Core.Image.RNCoreImage;` to the usings at the top of the file
* Add `new RNCoreImagePackage()` to the `List<IReactPackage>` returned by the `Packages` method

## Usage

```javascript
import RNCoreImage from "react-native-core-image";

// TODO: What to do with the module?
RNCoreImage;
```
