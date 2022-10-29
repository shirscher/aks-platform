import "reflect-metadata"
import { DataSource } from "typeorm"

export const AppDataSource = new DataSource({
    type: "mssql",
    host: "host.docker.internal",
    username: "sa",
    password: "SA-P@ssw0rd",
    database: "master",
    synchronize: true,
    logging: false,
    extra: {
        trustServerCertificate: true
    },
    entities: [],
    migrations: [],
    subscribers: [],
})
