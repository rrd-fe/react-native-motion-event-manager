package com.renrendai.motionevent.gyroscope;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.renrendai.motionevent.BaseSensorManager;

class GyroscopeManager extends BaseSensorManager implements SensorEventListener {

    public GyroscopeManager(Context context) {
        super(context);
    }

    @Override
    public void registerSensor() {
        Sensor accelerometer = getSensorManager().getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        if (accelerometer != null) {
            getSensorManager().registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_GAME);
        }
    }

    @Override
    public void unRegisterSensor() {
        getSensorManager().unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_GYROSCOPE) {
            getSensorListener().onSensorChanged(event.values[0], event.values[1], event.values[2]);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
