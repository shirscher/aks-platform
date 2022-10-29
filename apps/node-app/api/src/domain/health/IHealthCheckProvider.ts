import { HealthCheckResult } from "./HealthCheckResult";


export interface IHealthCheckProvider {
    checkHealth(): Promise<HealthCheckResult>;
}
