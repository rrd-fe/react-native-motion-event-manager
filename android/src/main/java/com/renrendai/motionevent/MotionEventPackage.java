package com.renrendai.motionevent;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.renrendai.motionevent.accelerometer.RNAccelerometerModule;
import com.renrendai.motionevent.devicemotion.RNDeviceMotionModule;
import com.renrendai.motionevent.gyroscope.RNGyroscopeModule;
import com.renrendai.motionevent.magnetometer.RNMagnetometerModule;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Nonnull;

public class MotionEventPackage implements ReactPackage {
    @Nonnull
    @Override
    public List<NativeModule> createNativeModules(@Nonnull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new RNAccelerometerModule(reactContext));
        modules.add(new RNDeviceMotionModule(reactContext));
        modules.add(new RNGyroscopeModule(reactContext));
        modules.add(new RNMagnetometerModule(reactContext));
        return modules;
    }

    @Nonnull
    @Override
    public List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
