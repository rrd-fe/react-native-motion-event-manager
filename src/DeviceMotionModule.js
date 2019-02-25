
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNMotionModule = NativeModules.RNDeviceMotionModule;

var DeviceMotionModule = {
    startDeviceMotionUpdates: function(eventMapping) {
        // Since allocateTag() is not exposed to public, we set a big unique number to
        // the tag param as a workaround
        let tag = 100000;
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