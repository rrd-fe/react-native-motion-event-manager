
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNMagnetometerModule = NativeModules.RNMagnetometerModule;

var MagnetometerModule = {
    startMagnetometerUpdates: function(eventMapping) {
        // Since allocateTag() is not exposed to public, we set a big unique number to
        // the tag param as a workaround
        let tag = 100006;
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