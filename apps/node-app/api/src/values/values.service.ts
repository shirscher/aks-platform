import { Injectable, NotFoundException } from '@nestjs/common';
import { ValueEntity } from './value.entity';
import { GetValueResponse } from './GetValueResponse';
import { GetValuesResponse } from './GetValuesResponse';
import { CreateValueResponse } from './CreateValueResponse';
import { CreateValueRequest } from './CreateValueRequest';
import { DeleteValueResponse } from './DeleteValueResponse';
import { UpdateValueRequest } from './UpdateValueRequest';
import { UpdateValueResponse } from './UpdateValueResponse';
import { InjectRepository } from '@nestjs/typeorm';
import { Entity, Repository } from 'typeorm';

@Injectable()
export class ValuesService {
    /**
     *
     */
    constructor(
        @InjectRepository(ValueEntity)
        private readonly valueRepository: Repository<ValueEntity>
    ) {
    }

    /**
     * Gets a list of all values
     * @returns A list of values
     */
    async getValues(): Promise<ValueEntity[]> {
        var results = await this.valueRepository.find();
        return results;
    }

    /**
     * Gets a single value by its key.
     * @param key The key of the record to retrieve.
     * @returns The value entity with the specified key or null if no value with this key was found.
     */
    async getValue(key: string): Promise<ValueEntity | null> {
        var result = await this.valueRepository.findOneBy({
            key: key
        });
        return result;
    }

    /**
     * Creates a new key/value pair.
     * @param request 
     * @returns 
     */
    async createValue(request: CreateValueRequest): Promise<ValueEntity> {
        const entity = new ValueEntity(request.key, request.value);
        await this.valueRepository.insert(entity);
        return entity;
    }

    /**
     * Updates an existing key/value pair.
     * @param request 
     */
    async updateValue(key: string, request: UpdateValueRequest): Promise<ValueEntity> {
        const entity = await this.getValue(key);
        if (entity == null) {
            return null;
        }
        
        entity.value = request.value;
        await this.valueRepository.save(entity);

        return entity;
    }

    /**
     * Deletes the value with the given key.
     * @param key 
     * @returns true if the value was found and deleted, otherwise false.
     */
    async deleteValue(key: string): Promise<boolean> {
        const result = await this.valueRepository.delete({
            key: key
        })

        return result.affected > 0;
    } 
}
