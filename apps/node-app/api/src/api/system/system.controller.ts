import { Controller, Get } from '@nestjs/common';
import { SystemService } from './system.service';
import { HealthCheckService } from './healthCheck.service';
import { SystemInfoResponse } from './SystemInfoResponse';
import { HealthCheckResponse } from './HealthCheckResponse';

@Controller('system')
export class SystemController {
    constructor(
        private systemService: SystemService,
        private healthCheckService: HealthCheckService) { }

    @Get()
    async getSystemInfo(): Promise<SystemInfoResponse> {
        var response = await this.systemService.getSystemInfo();
        return response;
    }

    @Get("/ping")
    async ping(): Promise<string> {
        return new Promise(resolve => {
            resolve("pong");
        });
    }

    @Get("/health")
    async getHealth(): Promise<HealthCheckResponse> {
        var response = await this.healthCheckService.getHealth();
        return response;
    }
}
