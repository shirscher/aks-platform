import { Injectable } from '@nestjs/common';
import { HealthCheckResponse } from './HealthCheckResponse';

@Injectable()
export class HealthCheckService {

    /**
     * 
     * @returns The status of all health checks
     */
     getHealth(): Promise<HealthCheckResponse> {
        return new Promise(resolve => {
            const response = {
                results: []
            };

            resolve(response);
        });
    }
}
