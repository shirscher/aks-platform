import { Module } from '@nestjs/common';
import { SqlHealthCheckProvider } from '../../infra/data/SqlHealthCheckProvider';
import { HealthCheckService } from '../../domain/health/HealthCheckService';
import { SystemController } from './system.controller';
import { SystemService } from './system.service';

@Module({
  controllers: [SystemController],
  providers: [
    SystemService,
    SqlHealthCheckProvider,
    {
      provide: 'HealthCheckService',
      useFactory: (...providers) => new HealthCheckService(providers),
      inject: [SqlHealthCheckProvider]
    }
  ]
})
export class SystemModule {}
