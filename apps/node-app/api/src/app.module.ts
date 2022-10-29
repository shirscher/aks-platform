import { Module } from '@nestjs/common';
import { ValuesModule } from './api/values/values.module';
import { SystemModule } from './api/system/system.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }), 
    ValuesModule,
    SystemModule]
})
export class AppModule {}
