package com.renrendai.motionevent.accelerometer;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.renrendai.motionevent.BaseSensorManager;

class AccelerometerManager extends BaseSensorManager implements SensorEventListener {

    public AccelerometerManager(Context context) {
        super(context);
    }

    @Override
    public void registerSensor() {
        Sensor accelerometer = getSensorManager().getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
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
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            getSensorListener().onSensorChanged(event.values[0], event.values[1], event.values[2]);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
