import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ValueEntity } from './value.entity';
import { ValuesController } from './values.controller';
import { ValuesService } from './values.service';

@Module({
    imports: [TypeOrmModule.forFeature([ValueEntity])],
    controllers: [ValuesController],
    providers: [ValuesService]
})
export class ValuesModule {}

