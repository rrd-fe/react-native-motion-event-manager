package com.renrendai.motionevent.accelerometer;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.renrendai.motionevent.BaseEvent;
import com.renrendai.motionevent.BaseSensorManager;
import com.renrendai.motionevent.BaseSensorModule;

import javax.annotation.Nonnull;

public class RNAccelerometerModule extends BaseSensorModule {

    public RNAccelerometerModule(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nonnull
    @Override
    public String getName() {
        return "RNAccelerometerModule";
    }

    @Override
    protected BaseSensorManager createSensorManager(ReactApplicationContext reactContext) {
        return new AccelerometerManager(reactContext);
    }

    @Override
    protected Event createEvent(int tag, String eventName, double x, double y, double z) {
        return new MotionEvent(tag, eventName, x, y, z);
    }

    @ReactMethod
    public void startAccelerometerUpdates(final int tag, final String eventName) {
        bindSensorManager(tag, eventName);
    }

    @ReactMethod
    public void stopAccelerometerUpdates() {
        unbindSensorManager();
    }

    private class MotionEvent extends BaseEvent<MotionEvent> {

        public MotionEvent(int viewTag, String eventName, double x, double y, double z) {
            super(viewTag, eventName, x, y, z);
        }

        @Override
        protected WritableMap createEventData(double x, double y, double z) {
            WritableMap attitude = Arguments.createMap();
            attitude.putDouble("x", x);
            attitude.putDouble("y", y);
            attitude.putDouble("z", z);
            WritableMap event = Arguments.createMap();
            event.putMap("acceleration", attitude);
            return event;
        }
    }
}
