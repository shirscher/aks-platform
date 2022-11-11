import { MigrationInterface, QueryRunner, Table, TableColumn } from "typeorm"

export class migrations1668129387793 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(
            new Table({
                name: "Values",
                columns: [
                    new TableColumn({
                        name: "Key",
                        type: "varchar",
                        length: "50",
                        isPrimary: true
                    }),
                    new TableColumn({
                        name: "Value",
                        type: "varchar",
                        length: "100"
                    })
                ]
            })
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable("Values");
    }
}
