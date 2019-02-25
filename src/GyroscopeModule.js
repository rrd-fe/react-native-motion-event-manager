
import {
    Animated,
    NativeModules,
} from 'react-native';

const RNGyroscopeModule = NativeModules.RNGyroscopeModule;

var GyroscopeModule = {
    startGyroscopeUpdates: function(eventMapping) {
        // Since allocateTag() is not exposed to public, we set a big unique number to
        // the tag param as a workaround
        let tag = 100004;
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