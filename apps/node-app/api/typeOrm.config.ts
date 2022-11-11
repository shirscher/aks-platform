import { DataSource } from "typeorm"
import { config } from 'dotenv';
import { ConfigService } from "@nestjs/config";
import DataSourceOptionsFactory from "./src/infra/data/DataSourceOptionsFactory"

// Make sure we pull config settings from the environment and .env file when working locally
config();
 
const configService = new ConfigService();
const dataSourceOptions = DataSourceOptionsFactory(configService);

let withMigrations = { 
    ...dataSourceOptions,
    migrations: ['migrations/**/*{.ts,.js}']
};

export const AppDataSource = new DataSource(withMigrations);
