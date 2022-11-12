import { HealthStatus } from "./health-status.enum";

export interface HealthCheckResult {
    status: HealthStatus,
    message?: string,
    data?: {[key: string]: any},
    error?: Error
}
