import { NativeEventEmitter, NativeModules } from 'react-native';

const { MotionActivity } = NativeModules;

export const Confidence = {
    Low: 0,
    Medium: 1,
    High: 2,
    0: 'Low',
    1: 'Medium',
    2: 'High',
};

const eventEmitter = new NativeEventEmitter(MotionActivity);

export const getUpdates = (callback) => {
    const subscription = eventEmitter.addListener(
        'activity_update',
        (activity) => callback(activity)
    );

    return () => {
        subscription.remove();
    }
};

export const getAuthorisationStatus = MotionActivity.getAuthorisationStatus;