package com.renrendai.motionevent;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.EventDispatcher;
import com.facebook.react.uimanager.events.RCTEventEmitter;

public class RNDeviceMotionModule extends ReactContextBaseJavaModule {

    private DeviceOrientationManager manager;

    public RNDeviceMotionModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNDeviceMotionModule";
    }

    @ReactMethod
    public void startDeviceMotionUpdates(final int tag, String eventName) {
        final EventDispatcher dispatcher = getReactApplicationContext().getNativeModule(UIManagerModule.class).getEventDispatcher();
        final MotionEvent event = new MotionEvent(eventName);
        if (manager == null) {
            manager = new DeviceOrientationManager(getReactApplicationContext());
            manager.setOnOrientationChangeListener(new DeviceOrientationManager.OnOrientationChangeListener() {
                @Override
                public void onOrientationChange(double yaw, double pitch, double roll) {
                    if (dispatcher != null) {
                        event.updateOrientation(tag, yaw, pitch, roll);
                        dispatcher.dispatchEvent(event);
                    }
                }
            });
        }
        manager.register();
    }

    @ReactMethod
    public void stopDeviceMotionUpdates() {
        if (manager != null) {
            manager.unRegister();
            manager = null;
        }
    }

    private class MotionEvent extends Event<MotionEvent> {

        private String eventName;
        private double yaw;
        private double pitch;
        private double roll;

        MotionEvent(String eventName) {
            this.eventName = eventName;
        }

        void updateOrientation(int tag, double yaw, double pitch, double roll) {
            init(tag);
            this.yaw = yaw;
            this.pitch = pitch;
            this.roll = roll;
        }

        @Override
        public String getEventName() {
            return eventName;
        }

        @Override
        public void dispatch(RCTEventEmitter rctEventEmitter) {
            rctEventEmitter.receiveEvent(getViewTag(), getEventName(), serializeEventData());
        }

        private WritableMap serializeEventData() {
            WritableMap attitude = Arguments.createMap();
            attitude.putDouble("pitch", pitch);
            attitude.putDouble("roll", roll);
            attitude.putDouble("yaw", yaw);
            WritableMap event = Arguments.createMap();
            event.putMap("attitude", attitude);
            return event;
        }
    }
}
