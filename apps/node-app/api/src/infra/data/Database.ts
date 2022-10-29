import { Injectable, Scope } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Connection, ConnectionConfig, ParameterOptions, Request, TediousType } from "tedious";

@Injectable()
export class Database {
    private config: ConnectionConfig;
    private connection?: Connection;

    constructor(configService: ConfigService) {
        this.config = configService.get<ConnectionConfig>("Database");
    }

    async open() {
        this.connection = await openConnection(this.config);
    }

    async execute(
        sql: string,
        params?: { name: string, type: TediousType, value: any, options?: ParameterOptions }[]): Promise<any[]> {

        return await executeSql(this.connection, sql, params);
    }
    

    close() {
        if (this.connection) this.connection.close();
    }
}

function openConnection(config: ConnectionConfig): Promise<Connection> {
    return new Promise((resolve, reject) => {
        var connection = new Connection(config);
        connection.on("connect", err => {
            if (err) reject(err);
            else resolve(connection);
        });
    });
}

function executeSql(
    connection: Connection,
    sql: string,
    params?: { name: string, type: TediousType, value: any, options?: ParameterOptions }[]): Promise<any[]> {

        return new Promise((resolve, reject) => {
            var request = new Request(sql, (err, rowCount, rows) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(rows);
                }
            });

            if (params) {
                params.forEach(p => request.addParameter(p.name, p.type, p.value, p.options));
            }

            connection.execSql(request);
        })
}
