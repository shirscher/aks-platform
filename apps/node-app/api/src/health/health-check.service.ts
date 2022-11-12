import { Injectable } from '@nestjs/common';
import { HealthCheckResponse } from './health-check-response.dto';
import { HealthCheckResult } from './HealthCheckResult';
import { HealthStatus } from './health-status.enum';
import { IHealthCheckProvider } from './IHealthCheckProvider';

@Injectable()
export class HealthCheckService {
    /**
     *
     */
    constructor(private providers: IHealthCheckProvider[]) {
    }

    /**
     * 
     * @returns The status of all health checks
     */
     async getHealth(): Promise<HealthCheckResponse> {
        const resultPromises = this.providers.map((p, i, a) => p.checkHealth());
        var results = await Promise.all(resultPromises);

        return {
            status: this.getOverallStatus(results),
            results: results
        };
    }

    private getOverallStatus(results: HealthCheckResult[]): HealthStatus {
        if (results.some(r => r.status == HealthStatus.Unhealthy))
            return HealthStatus.Unhealthy;
        if (results.some(r => r.status == HealthStatus.Degraded))
            return HealthStatus.Degraded;
        return HealthStatus.Healthy;
    }
}


