package com.renrendai.motionevent.devicemotion;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.renrendai.motionevent.BaseEvent;
import com.renrendai.motionevent.BaseSensorManager;
import com.renrendai.motionevent.BaseSensorModule;

public class RNDeviceMotionModule extends BaseSensorModule {

    public RNDeviceMotionModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNDeviceMotionModule";
    }

    @Override
    protected BaseSensorManager createSensorManager(ReactApplicationContext reactContext) {
        return new DeviceOrientationManager(reactContext);
    }

    @Override
    protected Event createEvent(int tag, String eventName, double x, double y, double z) {
        return new MotionEvent(tag, eventName, x, y, z);
    }

    @ReactMethod
    public void startDeviceMotionUpdates(final int tag, final String eventName) {
        bindSensorManager(tag, eventName);
    }

    @ReactMethod
    public void stopDeviceMotionUpdates() {
        unbindSensorManager();
    }

    private class MotionEvent extends BaseEvent<MotionEvent> {


        public MotionEvent(int viewTag, String eventName, double x, double y, double z) {
            super(viewTag, eventName, x, y, z);
        }

        @Override
        protected WritableMap createEventData(double x, double y, double z) {
            WritableMap attitude = Arguments.createMap();
            attitude.putDouble("yaw", x);
            attitude.putDouble("pitch", y);
            attitude.putDouble("roll", z);
            WritableMap event = Arguments.createMap();
            event.putMap("attitude", attitude);
            return event;
        }
    }
}
