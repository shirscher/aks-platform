import { Module } from '@nestjs/common';
import { ValuesModule } from './api/values/values.module';
import { SystemModule } from './api/system/system.module';

@Module({
  imports: [ValuesModule, SystemModule]
})
export class AppModule {}
