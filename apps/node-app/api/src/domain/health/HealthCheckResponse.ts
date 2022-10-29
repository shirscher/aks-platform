import { HealthCheckResult } from "./HealthCheckResult";
import { HealthStatus } from "./HealthStatus";

export interface HealthCheckResponse {
    status: HealthStatus
    results: HealthCheckResult[]
}

