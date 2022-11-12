import { Controller, Get, Inject } from '@nestjs/common';
import { SystemService } from './system.service';
import { SystemInfoResponse } from './system-info-response.dto';

@Controller('system')
export class SystemController {
    constructor(
        private systemService: SystemService) { }

    @Get()
    async getSystemInfo(): Promise<SystemInfoResponse> {
        var response = await this.systemService.getSystemInfo();
        return response;
    }
}
