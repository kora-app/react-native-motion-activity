declare module 'react-native-motion-activity' {
    type Status = 'NOT_DETERMINED' | 'RESTRICTED' | 'DENIED' | 'AUTHORISED';

    export enum Confidence {
        Low = 0,
        Medium,
        High
    }

    interface Activity {
        automotive: boolean;
        confidence: Confidence;
        cycling: boolean;
        running: boolean;
        startDate: Date | undefined;
        stationary: boolean;
        unknown: boolean;
        walking: boolean;
        timestamp: Date | undefined;
    }

    export function getAuthorisationStatus(): Promise<Status>

    export function subscribe(callback: (activities: Activity) => void): () => void;

    export function queryActivities(from: Date, to: Date): Promise<ReadonlyArray<Activity>>;
}
