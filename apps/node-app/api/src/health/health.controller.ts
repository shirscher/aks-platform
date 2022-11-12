import { Controller, Get, Inject } from '@nestjs/common';
import { HealthCheckResponse } from './health-check-response.dto';
import { HealthCheckService } from './health-check.service';

@Controller('health')
export class HealthController {
    constructor(
        @Inject("HealthCheckService") private healthCheckService: HealthCheckService) { }

    @Get("/ping")
    async ping(): Promise<string> {
        return new Promise(resolve => {
            resolve("pong");
        });
    }

    @Get()
    async getHealth(): Promise<HealthCheckResponse> {
        var response = await this.healthCheckService.getHealth();
        return response;
    }
}
