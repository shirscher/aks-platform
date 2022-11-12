import { BeforeInsert, BeforeUpdate, Column, Entity, PrimaryColumn } from "typeorm";

@Entity("Values")
export class ValueEntity {
    /**
     * Creates a new ValueEntity
     */
    constructor(key: string, value: string) {
        this.key = key;
        this.value = value;
    }

    @PrimaryColumn()
    readonly key: string;

    @Column()
    value: string;

    @Column()
    createUtcTimestamp: Date;
  
    @Column()
    updateUtcTimestamp: Date;

    @BeforeUpdate()
    updateTimestamp() {
        this.updateUtcTimestamp = new Date;
    }

    @BeforeInsert()
    createTimestamp() {
        this.createUtcTimestamp = this.updateUtcTimestamp = new Date;
    }
}
