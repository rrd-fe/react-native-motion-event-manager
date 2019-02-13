
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNMagnetometerModule = NativeModules.RNMagnetometerModule;
const ReactNativeTagHandles = require('react-native/Libraries/Renderer/src/renderers/native/ReactNativeTagHandles');

var MagnetometerModule = {
    startMagnetometerUpdates: function(eventMapping) {
        let tag = ReactNativeTagHandles.allocateTag();
        let eventName = 'onMagnetometerChange';
        Animated.attachNativeEvent(tag, eventName, [{
            nativeEvent: eventMapping,
        }]);
        RNMagnetometerModule.startMagnetometerUpdates(tag, eventName);
    },
    stopMagnetometerUpdates: function() {
        RNMagnetometerModule.stopMagnetometerUpdates();
    },
}

export { MagnetometerModule };