import { HealthStatus } from "./HealthStatus";

export interface HealthCheckResult {
    status: HealthStatus,
    message?: string,
    data?: {[key: string]: any},
    error?: Error
}
