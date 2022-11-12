import { Module } from '@nestjs/common';
import { SqlHealthCheckProvider } from './SqlHealthCheckProvider';
import { HealthCheckService } from './health-check.service';
import { HealthController } from './health.controller';

@Module({
  controllers: [HealthController],
  providers: [
    {
      provide: 'HealthCheckService',
      useFactory: (...providers) => new HealthCheckService(providers),
      inject: [SqlHealthCheckProvider]
    },
    SqlHealthCheckProvider
  ]
})
export class HealthModule {}
