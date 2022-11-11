import { Module } from '@nestjs/common';
import { ValuesModule } from './api/values/values.module';
import { SystemModule } from './api/system/system.module';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import TypeOrmModuleFactory from './infra/data/TypeOrmModuleFactory';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }), 
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: TypeOrmModuleFactory,
      inject: [ConfigService]
    }),
    ValuesModule,
    SystemModule]
})
export class AppModule {}
