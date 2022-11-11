import { ConfigService } from "@nestjs/config";
import { TypeOrmModuleOptions } from "@nestjs/typeorm";
import DataSourceOptionsFactory from "./DataSourceOptionsFactory";

export default function TypeOrmModuleFactory(configService: ConfigService) : TypeOrmModuleOptions  {
    return DataSourceOptionsFactory(configService);
}