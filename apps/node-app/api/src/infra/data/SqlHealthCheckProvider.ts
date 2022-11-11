import { Injectable } from "@nestjs/common";
import { HealthCheckResult } from "src/domain/health/HealthCheckResult";
import { IHealthCheckProvider } from "src/domain/health/IHealthCheckProvider";
import { ConfigService } from "@nestjs/config";
import { EntityManager } from "typeorm";
import TypeOrmModuleFactory from "./TypeOrmModuleFactory";


@Injectable()
export class SqlHealthCheckProvider implements IHealthCheckProvider {
    readonly DEFAULT_QUERY = "SELECT @@VERSION";

    /**
     * Creates a new SqlHealthCheck
     */
    // constructor(private configService: ConfigService) {
    // }

    constructor(
        private configService: ConfigService,
        private entityManager: EntityManager) {
    }

    /**
     *
     * @returns
     */
    async checkHealth(): Promise<HealthCheckResult> {
        let query = this.configService.get<string>("DATABASE_HEALTHCHECK_QUERY");
        query = query ? query : this.DEFAULT_QUERY;

        // Copy options and clear out password if using credential authentication
        const options = TypeOrmModuleFactory(this.configService);
        var optionsCopy = JSON.parse(JSON.stringify(options));
        if (optionsCopy.authentication?.options?.password) {
            optionsCopy.authentication.options.password = "***********";
        }

        try {
            let result = await this.entityManager.query(query);

            return {
                message: "Successfully executed query",
                data: {
                    sql: query,
                    results: result, // rows.map(r => r.map(c => c.value)),
                    config: optionsCopy
                },
                status: "Healthy"
            };
        } catch (err) {
            return {
                message: "Query failed",
                error: err,
                data: {
                    config: options
                },
                status: "Unhealthy"
            }
        }
    }
}
