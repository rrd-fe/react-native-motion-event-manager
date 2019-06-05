package com.renrendai.motionevent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.EventDispatcher;

import javax.annotation.Nonnull;

public abstract class BaseSensorModule extends ReactContextBaseJavaModule {

    private BaseSensorManager manager;

    public BaseSensorModule(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
        manager = createSensorManager(reactContext);
    }

    protected void bindSensorManager(final int tag, final String eventName) {
        if (manager != null) {
            final EventDispatcher dispatcher = getReactApplicationContext().getNativeModule(UIManagerModule.class).getEventDispatcher();
            manager.setSensorListener(new SensorListener() {
                @Override
                public void onSensorChanged(double x, double y, double z) {
                    if (dispatcher != null) {
                        dispatcher.dispatchEvent(createEvent(tag, eventName, x, y, z));
                    }
                }
            });
            manager.registerSensor();
        }
    }

    protected void unbindSensorManager() {
        if (manager != null) {
            manager.resetSensorListener();
            manager.unRegisterSensor();
        }
    }

    protected abstract BaseSensorManager createSensorManager(ReactApplicationContext reactContext);

    protected abstract Event createEvent(int tag, String eventName, double x, double y, double z);
}
