"react-native-motion-event-manager" extract device motion to RN.
It uses Animated API and native driver to update UI in native UI thread. With bypassing the RN bridge, it eliminates delay of animations.

## Installation

```
npm i react-native-motion-event-manager
```

### iOS

#### Cocoapods

Add the following to your Podfile
```
pod 'RNMotionEventManager', :path => '/your/path/to/react-native-motion-event-manager'
```
and then run `pod install`

#### Manual

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-motion-event-manager` ➜ `ios`and add `RNMotionEventManager.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNMotionEventManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project on device.

### Android

To be continued.

## Usage

Below is a sample using DeviceMotionModule:

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
Here `this.state.roll` is an Animated.Value, and every update of native motion event will trigger the update of this Animated.Value. This Value can be used to construct another Animated.Value or be set as the style of some element. For example:

```
<Animated.Text
  style={{opacity:this.state.roll.interpolate({
      inputRange: [-1.5, 1.5],
      outputRange: [0, 1]
    })}}>
  Some text here.
</Animated.Text>
```

## Caveats

> Not everything you can do with Animated is currently supported in Native Animated. The main limitation is that you can only animate non-layout properties, things like `transform` and `opacity` will work but flexbox and position properties won't. Another one is with `Animated.event`, it will only work with direct events and not bubbling events. This means it does not work with `PanResponder` but does work with things like `ScrollView#onScroll`.

We can find complete supported property list in  "/node_modules/react-native/Libraries/Animated/src/NativeAnimatedHelper.js":

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

