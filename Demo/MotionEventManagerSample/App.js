/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Animated} from 'react-native';
import { DeviceMotionModule } from 'react-native-motion-event-manager';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props);

    this.state = {
      roll: new Animated.Value(0),
    }
  }

  componentDidMount() {
    // replace with your mapping here
      let eventMapping = {
          attitude: {
              roll: this.state.roll, 
          }
      };
      DeviceMotionModule.startDeviceMotionUpdates(eventMapping);
  }

  componentWillUnmount() {
      DeviceMotionModule.stopDeviceMotionUpdates();
  }

  render() {
    return (
      <View style={styles.container}>
      <Animated.Text
        style={{opacity:this.state.roll.interpolate({
            inputRange: [-1.5, 1.5],
            outputRange: [0, 1]
          })}}>
        Opacity will change while rolling.
      </Animated.Text>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
