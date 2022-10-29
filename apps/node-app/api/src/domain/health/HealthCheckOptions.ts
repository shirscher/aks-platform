import { HealthStatus } from "./HealthStatus";


export interface HealthCheckOptions {
    intervalSeconds: number;
    overallStatus: HealthStatus;
}
