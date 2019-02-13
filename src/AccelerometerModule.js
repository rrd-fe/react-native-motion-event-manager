
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNAccelerometerModule = NativeModules.RNAccelerometerModule;
const ReactNativeTagHandles = require('react-native/Libraries/Renderer/src/renderers/native/ReactNativeTagHandles');

var AccelerometerModule = {
    startAccelerometerUpdates: function(eventMapping) {
        let tag = ReactNativeTagHandles.allocateTag();
        let eventName = 'onAccelerometerChange';
        Animated.attachNativeEvent(tag, eventName, [{
            nativeEvent: eventMapping,
        }]);
        RNAccelerometerModule.startAccelerometerUpdates(tag, eventName);
    },
    stopAccelerometerUpdates: function() {
        RNAccelerometerModule.stopAccelerometerUpdates();
    },
}

export { AccelerometerModule };