import { Injectable } from '@nestjs/common';
import { Value } from './Value';
import { GetValueResponse } from './GetValueResponse';
import { GetValuesResponse } from './GetValuesResponse';
import { CreateValueResponse } from './CreateValueResponse';
import { CreateValueRequest } from './CreateValueRequest';
import { DeleteValueResponse } from './DeleteValueResponse';
import { UpdateValueRequest } from './UpdateValueRequest';
import { UpdateValueResponse } from './UpdateValueResponse';

@Injectable()
export class ValuesService {
    private values : Value[];

    /**
     * Gets a list of all values
     * @returns A list of values
     */
    getValues(): Promise<GetValuesResponse> {
        return new Promise((resolve) => {
            const response = {
                values: this.values
            };

            resolve(response);
        });
    }

    /**
     * Gets a single value by its key
     * @param key The key of the record to retrieve
     * @returns 
     */
    getValue(key : string): Promise<GetValueResponse> {
        return new Promise((resolve) => {
            const response = this.values.find(v => v.key == key) ?? { key: "", value: "" };
            
            resolve(response);
        })
    }

    /**
     * Creates a new key/value pair
     * @param request 
     * @returns 
     */
    createValue(request: CreateValueRequest): Promise<CreateValueResponse> {
        return new Promise((resolve) => {
            this.values[this.values.length] = request;

            resolve(this.values[-1]);
        });
    }

    /**
     * 
     * @param request 
     */
    updateValue(request: UpdateValueRequest): Promise<UpdateValueResponse> {
        return new Promise((resolve) => {
            const value = this.values.find(v => v.key == request.key);

            if (value) {
                value.value = request.value;
            }

            const response = {
            };

            resolve(response);
        });
    }

    /**
     * 
     * @param key 
     * @returns 
     */
    deleteValue(key: string): Promise<DeleteValueResponse> {
        return new Promise((resolve) => {
            const index = this.values.findIndex(v => v.key == key);

            if (index > -1) {
                this.values.splice(index, 1);
            }

            resolve({});
        });
    } 
}
