import { Injectable } from '@nestjs/common';
import { HealthCheckResponse } from './HealthCheckResponse';
import { HealthCheckResult } from './HealthCheckResult';
import { HealthStatus } from './HealthStatus';
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
        if (results.some(r => r.status == "Unhealthy"))
            return "Unhealthy";
        if (results.some(r => r.status == "Degraded"))
            return "Degraded";
        return "Healthy";
    }
}


