import { Module } from '@nestjs/common';
import { Database } from './Database';

@Module({
    providers: [Database]
})
export class DatabaseModule {}

