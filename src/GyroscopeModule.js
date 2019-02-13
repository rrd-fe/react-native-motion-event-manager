
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNGyroscopeModule = NativeModules.RNGyroscopeModule;
const ReactNativeTagHandles = require('react-native/Libraries/Renderer/src/renderers/native/ReactNativeTagHandles');

var GyroscopeModule = {
    startGyroscopeUpdates: function(eventMapping) {
        let tag = ReactNativeTagHandles.allocateTag();
        let eventName = 'onGyroscopeChange';
        Animated.attachNativeEvent(tag, eventName, [{
            nativeEvent: eventMapping,
        }]);
        RNGyroscopeModule.startGyroscopeUpdates(tag, eventName);
    },
    stopGyroscopeUpdates: function() {
        RNGyroscopeModule.stopGyroscopeUpdates();
    },
}

export { GyroscopeModule };