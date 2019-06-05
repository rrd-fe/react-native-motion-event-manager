package com.renrendai.motionevent;

import android.content.Context;
import android.hardware.SensorManager;

public abstract class BaseSensorManager {

    private SensorManager sensorManager;
    private SensorListener listener = DEFAULTLISTENER;

    public BaseSensorManager(Context context) {
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
    }

    void setSensorListener(SensorListener listener) {
        if (this.listener != null) {
            this.listener = listener;
        } else {
            this.listener = DEFAULTLISTENER;
        }
    }

    void resetSensorListener() {
        this.listener = DEFAULTLISTENER;
    }

    protected SensorListener getSensorListener() {
        return listener;
    }

    protected SensorManager getSensorManager() {
        return sensorManager;
    }

    public abstract void registerSensor();

    public abstract void unRegisterSensor();

    private final static SensorListener DEFAULTLISTENER = new SensorListener() {
        @Override
        public void onSensorChanged(double x, double y, double z) {

        }
    };
}
