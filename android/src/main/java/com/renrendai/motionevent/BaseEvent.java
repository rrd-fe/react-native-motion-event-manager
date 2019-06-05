package com.renrendai.motionevent;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;

public abstract class BaseEvent<T extends Event> extends Event<T> {

    private String eventName;
    private double x;
    private double y;
    private double z;

    public BaseEvent(int viewTag, String eventName, double x, double y, double z) {
        super(viewTag);
        this.eventName = eventName;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    @Override
    public String getEventName() {
        return eventName;
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), createEventData(x, y, z));
    }

    protected abstract WritableMap createEventData(double x, double y, double z);
}
