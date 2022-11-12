import { HealthCheckResult } from "./HealthCheckResult";
import { HealthStatus } from "./health-status.enum";

export interface HealthCheckResponse {
    status: HealthStatus
    results: HealthCheckResult[]
}

