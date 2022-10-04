import { HealthStatus } from "./HealthStatus";

export interface HealthCheckResult {
    status: HealthStatus,
    message: string,
    data: any,
    error: Error
}
