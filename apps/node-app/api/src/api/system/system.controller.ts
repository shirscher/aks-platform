import { Controller, Get, Inject } from '@nestjs/common';
import { HealthCheckResponse } from '../../domain/health/HealthCheckResponse';
import { HealthCheckService } from '../../domain/health/HealthCheckService';
import { SystemService } from './system.service';
import { SystemInfoResponse } from './SystemInfoResponse';

@Controller('system')
export class SystemController {
    constructor(
        private systemService: SystemService,
        @Inject("HealthCheckService") private healthCheckService: HealthCheckService) { }

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
