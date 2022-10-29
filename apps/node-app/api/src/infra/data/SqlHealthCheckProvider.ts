import { Connection, ConnectionConfig, Request } from "tedious";
import { Injectable } from "@nestjs/common";
import { HealthCheckResult } from "src/domain/health/HealthCheckResult";
import { IHealthCheckProvider } from "src/domain/health/IHealthCheckProvider";
import { ConfigService } from "@nestjs/config";


@Injectable()
export class SqlHealthCheckProvider implements IHealthCheckProvider {
    readonly DEFAULT_QUERY = "SELECT @@VERSION";

    /**
     * Creates a new SqlHealthCheck
     */
    constructor(private configService: ConfigService) {
    }

    /**
     *
     * @returns
     */
    checkHealth(): Promise<HealthCheckResult> {
        return new Promise(resolve => {
            const connectionConfig = this.createConnectionConfig();
            const connection = new Connection(connectionConfig);

            var configCopy = JSON.parse(JSON.stringify(connectionConfig));
            if (configCopy.authentication?.options?.password) {
                configCopy.authentication.options.password = "***********";
            }

            connection.connect(err => {
                if (err) {
                    resolve({
                        message: "Connection failed",
                        error: err,
                        data: {
                            config: configCopy
                        },
                        status: "Unhealthy"
                    });
                } else {
                    var query = this.configService.get<string>("DATABASE_HEALTHCHECK_QUERY");
                    query = query ? query : this.DEFAULT_QUERY;
                    var request = new Request(
                        query,
                        (err, rowCount, rows) => {
                            resolve({
                                message: rowCount == 1 ? "Successfully executed query" : `Query failed with error: ${err.message}`,
                                data: {
                                    sql: query,
                                    rowCount: rowCount,
                                    results: rows.map(r => r.map(c => c.value)),
                                    config: configCopy
                                },
                                error: err,
                                status: rowCount == 1 ? "Healthy" : "Unhealthy"
                            });
                        });
        
                    connection.execSql(request);
                }
            });
        });
    }

    createConnectionConfig() : ConnectionConfig {
        let authentication;
        const authType = this.configService.get<string>("DATABASE_AUTH_TYPE", "").toLowerCase();
        if (authType === "msi") {
            throw new Error(`DATABASE_AUTH_TYPE '${authType}' is not implemented`);
        } else if (!authType || authType == "password") {
            const userName = this.configService.get<string>("DATABASE_USERNAME");
            const password = this.configService.get<string>("DATABASE_PASSWORD");

            if (!userName) {
                throw new Error("DATABASE_USERNAME setting must be set in the environment when DATABASE_AUTH_TYPE is 'msi'")
            }
            if (!password) {
                throw new Error("DATABASE_PASSWORD setting must be set in the environment when DATABASE_AUTH_TYPE is 'msi'")
            }

            authentication = {
                type: "default",
                options: {
                    userName: userName,
                    password: password
                }
            }
        } else {
            throw new Error(`Invalid DATABASE_AUTH_TYPE value '${authType}'`);
        }

        return {
            server: this.configService.get<string>("DATABASE_SERVER"),
            options: {
                database: this.configService.get<string>("DATABASE_NAME"),
                trustServerCertificate: true,
                rowCollectionOnRequestCompletion: true
            },
            authentication: authentication
        };
    }
}
