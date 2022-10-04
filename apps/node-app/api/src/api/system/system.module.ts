import { Module } from '@nestjs/common';
import { HealthCheckService } from './healthCheck.service';
import { SystemController } from './system.controller';
import { SystemService } from './system.service';

@Module({
  controllers: [SystemController],
  providers: [SystemService, HealthCheckService]
})
export class SystemModule {}
