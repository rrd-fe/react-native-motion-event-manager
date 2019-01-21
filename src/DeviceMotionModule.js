
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNMotionModule = NativeModules.RNDeviceMotionModule;
const ReactNativeTagHandles = require('react-native/Libraries/Renderer/src/renderers/native/ReactNativeTagHandles');

var DeviceMotionModule = {
    startDeviceMotionUpdates: function(eventMapping) {
        let tag = ReactNativeTagHandles.allocateTag();
        let eventName = 'onMotionChange';
        Animated.attachNativeEvent(tag, eventName, [{
            nativeEvent: eventMapping,
        }]);
        RNMotionModule.startDeviceMotionUpdates(tag, eventName);
    },
    stopDeviceMotionUpdates: function() {
        RNMotionModule.stopDeviceMotionUpdates();
    },
}

export { DeviceMotionModule };