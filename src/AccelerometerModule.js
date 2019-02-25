
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNAccelerometerModule = NativeModules.RNAccelerometerModule;

var AccelerometerModule = {
    startAccelerometerUpdates: function(eventMapping) {
        // Since allocateTag() is not exposed to public, we set a big unique number to
        // the tag param as a workaround
        let tag = 100002;
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