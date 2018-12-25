import React, { Component } from 'react';
import PropTypes from 'prop-types';

import { requireNativeComponent, findNodeHandle, UIManager } from 'react-native';

const NativeDeviceMotionView = requireNativeComponent('DeviceMotionView');

class DeviceMotionView extends Component {

    static propTypes = {
        onDeviceMotionChange: PropTypes.func,
    }

    componentDidMount() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.DeviceMotionView.Commands.startDeviceMotionUpdate,
            null,
        );
    }

    componentWillUnmount() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.DeviceMotionView.Commands.stopDeviceMotionUpdate,
            null,
        );
    }

    onDeviceMotionChange = (event) => {
        if (this.props.onDeviceMotionChange) {
            this.props.onDeviceMotionChange(event);
        }
    };

    render() {
        return (
            <NativeDeviceMotionView
              {...this.props}
              onDeviceMotionChange={this.onDeviceMotionChange}
            />
        );
    }
}

import { Animated } from 'react-native';
const AnimatedDeviceMotionView = Animated.createAnimatedComponent(DeviceMotionView);

export default AnimatedDeviceMotionView;
