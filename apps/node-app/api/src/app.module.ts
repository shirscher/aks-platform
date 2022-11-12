import { Module } from '@nestjs/common';
import { ValuesModule } from './values/values.module';
import { SystemModule } from './system/system.module';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import TypeOrmModuleFactory from './data/TypeOrmModuleFactory';
import { HealthModule } from './health/health.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }), 
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: TypeOrmModuleFactory,
      inject: [ConfigService]
    }),
    ValuesModule,
    SystemModule,
    HealthModule]
})
export class AppModule {}
