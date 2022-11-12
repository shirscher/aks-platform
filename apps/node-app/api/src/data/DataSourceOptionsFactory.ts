import { ConfigService } from "@nestjs/config";
import { join } from "path";
import { DataSourceOptions } from "typeorm";

export default function DataSourceOptionsFactory(configService: ConfigService): DataSourceOptions {
    let authentication;
    const authType = configService.get<string>("DATABASE_AUTH_TYPE", "").toLowerCase();
    if (authType === "msi") {
        authentication = {
            authType: "azure-active-directory-msi-vm"
        };
    } else if (!authType || authType == "password") {
        const userName = configService.get<string>("DATABASE_USERNAME");
        const password = configService.get<string>("DATABASE_PASSWORD");

        if (!userName) {
            throw new Error("DATABASE_USERNAME setting must be set in the environment when DATABASE_AUTH_TYPE is 'msi'");
        }
        if (!password) {
            throw new Error("DATABASE_PASSWORD setting must be set in the environment when DATABASE_AUTH_TYPE is 'msi'");
        }

        authentication = {
            type: "default",
            options: {
                userName: userName,
                password: password
            }
        };
    } else {
        throw new Error(`Invalid DATABASE_AUTH_TYPE value '${authType}'`);
    }

    return {
        type: "mssql",
        host: configService.get<string>("DATABASE_SERVER"),
        //port: configService.get<number>("DATABASE_PORT", undefined),
        database: configService.get<string>("DATABASE_NAME"),
        authentication: authentication,
        extra: {
            trustServerCertificate: true
        },
        entities: [join(__dirname, '../', '**', '*.entity.{ts,js}')] 
    };
}
