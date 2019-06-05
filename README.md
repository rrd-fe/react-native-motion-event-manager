[English README Here](./README_en.md)

react-native-motion-event-manager将device motion导出到RN，它使用了Animated的API和native driver的特性来使UI的更新都在native的UI线程来完成，不用通过RN的bridge，避免了动画的延迟和卡顿。

## 安装

在package.json所在目录运行
```
npm i react-native-motion-event-manager
```

### iOS

#### Cocoapods安装

然后在iOS的工程目录的Podfile中添加如下代码：

```
pod 'RNMotionEventManager', :path => '/your/path/to/react-native-motion-event-manager'
```
之后运行`pod install`

#### 手动安装

1. 在XCode的project navigator中，右键 `Libraries`，之后点击 `Add Files to [your project's name]`
2. 依次进入目录 `node_modules` ➜ `react-native-motion-event-manager` ➜ `ios`，然后添加 `RNMotionEventManager.xcodeproj`
3. 在XCode中选择你的target的`Build Phases`，在`Link Binary With Libraries`中添加 `libRNMotionEventManager.a`。
4. 在真机上运行工程。

### Android

#### 使用react-native link

```
react-native link react-native-motion-event-manager
```
#### 手动添加
1. 引入 react-native-motion-event-manager

```
include ':react-native-motion-event-manager'
project(':react-native-motion-event-manager').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-motion-event-manager/android')
```
2. 添加依赖

```
implementation project(':react-native-motion-event-manager')
```
3. 初始化 MotionEventPackage

```
@Override
protected List<ReactPackage> getPackages() {
  return Arrays.<ReactPackage>asList(
    new MainReactPackage(),
    new MotionEventPackage()
  );
}
```

## 使用



> Not everything you can do with Animated is currently supported in Native Animated. The main limitation is that you can only animate non-layout properties, things like `transform` and `opacity` will work but flexbox and position properties won't. Another one is with `Animated.event`, it will only work with direct events and not bubbling events. This means it does not work with `PanResponder` but does work with things like `ScrollView#onScroll`.

然后在RN中的具体页面，以DeviceMotionModule使用为例，使用代码如下：
```
import { DeviceMotionModule } from 'react-native-motion-event-manager';

class YourClass extends Component {
	componentDidMount() {
	    // replace with your mapping here
        let eventMapping = {
            attitude: {
                roll: this.state.roll, 
            }
        };
        DeviceMotionModule.startDeviceMotionUpdates(eventMapping);
    }

    componentWillUnmount() {
        DeviceMotionModule.stopDeviceMotionUpdates();
    }
}
```
其中`this.state.roll`这个state是一个Animated.Value，之后客户端每次触发motion的更新，就会触发这个Animated.Value的更新。
这个Value可以用于构造另外一个Animated.Value或者直接赋予某个element的style。例如：
```
<Animated.Text
  style={{opacity:this.state.roll.interpolate({
      inputRange: [-1.5, 1.5],
      outputRange: [0, 1]
    })}}>
  Some text here.
</Animated.Text>
```

## 注意事项

在/node_modules/react-native/Libraries/Animated/src/NativeAnimatedHelper.js里的最后可以找到支持的属性列表：

```
/**
 * Styles allowed by the native animated implementation.
 *
 * In general native animated implementation should support any numeric property that doesn't need
 * to be updated through the shadow view hierarchy (all non-layout properties).
 */
const STYLES_WHITELIST = {
  opacity: true,
  transform: true,
  /* legacy android transform properties */
  scaleX: true,
  scaleY: true,
  translateX: true,
  translateY: true,
};

const TRANSFORM_WHITELIST = {
  translateX: true,
  translateY: true,
  scale: true,
  scaleX: true,
  scaleY: true,
  rotate: true,
  rotateX: true,
  rotateY: true,
  perspective: true,
};
```

