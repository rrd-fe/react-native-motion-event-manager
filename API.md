
## DeviceMotionModule 

```
import { DeviceMotionModule } from 'react-native-motion-event-manager';

class YourClass extends Component {
    componentDidMount() {
        // replace with your mapping here
        let eventMapping = {
            attitude: {
                pitch: this.state.pitch,
                roll: this.state.roll,
                yaw: this.state.yaw,
            },
            rotationRate: {           // iOS only
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
            gravity: {                // iOS only
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
            userAcceleration: {       // iOS only
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
            magneticField: {          // iOS only
                field: {
                    x: this.state.x,
                    y: this.state.y,
                    z: this.state.z,
                },
                accuracy: this.state.accuracy,
            }
        };
        DeviceMotionModule.startDeviceMotionUpdates(eventMapping);
    }

    componentWillUnmount() {
        DeviceMotionModule.stopDeviceMotionUpdates();
    }
}

```

## AccelerometerModule

```
import { AccelerometerModule } from 'react-native-motion-event-manager';

class YourClass extends Component {
    componentDidMount() {
        // replace with your mapping here
        let eventMapping = {
            acceleration: {
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
        };
        AccelerometerModule.startAccelerometerUpdates(eventMapping);
    }

    componentWillUnmount() {
        AccelerometerModule.stopAccelerometerUpdates();
    }
}
```

## GyroscopeModule

```
import { GyroscopeModule } from 'react-native-motion-event-manager';

class YourClass extends Component {
    componentDidMount() {
        // replace with your mapping here
        let eventMapping = {
            rotationRate: {
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
        };
        GyroscopeModule.startGyroscopeUpdates(eventMapping);
    }

    componentWillUnmount() {
        GyroscopeModule.stopGyroscopeUpdates();
    }
}
```

## MagnetometerModule

```
import { MagnetometerModule } from 'react-native-motion-event-manager';

class YourClass extends Component {
    componentDidMount() {
        // replace with your mapping here
        let eventMapping = {
            magneticField: {
                x: this.state.x,
                y: this.state.y,
                z: this.state.z,
            },
        };
        MagnetometerModule.startMagnetometerUpdates(eventMapping);
    }

    componentWillUnmount() {
        MagnetometerModule.stopMagnetometerUpdates();
    }
}
```





