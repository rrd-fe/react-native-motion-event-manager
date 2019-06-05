package com.renrendai.motionevent.devicemotion;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.renrendai.motionevent.BaseSensorManager;

class DeviceOrientationManager extends BaseSensorManager implements SensorEventListener {

    private final float[] rotationMatrix = new float[9];
    private final float[] transformedRotationMatrix = new float[9];
    private final float[] orientationAngles = new float[3];

    public DeviceOrientationManager(Context context) {
        super(context);
    }

    @Override
    public void registerSensor() {
        Sensor rotationVector = getSensorManager().getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        if (rotationVector != null) {
            getSensorManager().registerListener(this, rotationVector, SensorManager.SENSOR_DELAY_GAME);
        }
    }

    @Override
    public void unRegisterSensor() {
        getSensorManager().unregisterListener(this);

    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR) {
            SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values);
            SensorManager.remapCoordinateSystem(rotationMatrix, SensorManager.AXIS_X, SensorManager.AXIS_Y, transformedRotationMatrix);
            SensorManager.getOrientation(transformedRotationMatrix, orientationAngles);
            getSensorListener().onSensorChanged(orientationAngles[0], orientationAngles[1], orientationAngles[2]);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
