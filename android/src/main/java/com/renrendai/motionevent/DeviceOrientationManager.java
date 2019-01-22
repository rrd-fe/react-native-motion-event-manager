package com.renrendai.motionevent;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

class DeviceOrientationManager implements SensorEventListener {

    private final float[] rotationMatrix = new float[9];
    private final float[] transformedRotationMatrix = new float[9];
    private final float[] orientationAngles = new float[3];

    private SensorManager manager;
    private OnOrientationChangeListener listener;

    DeviceOrientationManager(Context context) {
        manager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
    }

    void register() {
        Sensor rotationVector = manager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        if (rotationVector != null) {
            manager.registerListener(this, rotationVector, SensorManager.SENSOR_DELAY_GAME);
        }
    }

    void unRegister() {
        manager.unregisterListener(this);
    }

    void setOnOrientationChangeListener(OnOrientationChangeListener listener) {
        this.listener = listener;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR && listener != null) {
            SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values);
            SensorManager.remapCoordinateSystem(rotationMatrix, SensorManager.AXIS_X, SensorManager.AXIS_Y, transformedRotationMatrix);
            SensorManager.getOrientation(transformedRotationMatrix, orientationAngles);
            listener.onOrientationChange(orientationAngles[0], orientationAngles[1], orientationAngles[2]);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    interface OnOrientationChangeListener {
        void onOrientationChange(double yaw, double pitch, double roll);
    }
}
