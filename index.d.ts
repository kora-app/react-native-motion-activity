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
    }

    export function getAuthorisationStatus(): Promise<Status>

    export function getUpdates(callback: (activities: ReadonlyArray<Activity>) => void): () => void;
}
