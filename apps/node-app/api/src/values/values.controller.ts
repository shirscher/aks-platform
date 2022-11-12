import { Body, Controller, Delete, Get, HttpCode, HttpException, HttpStatus, Param, Post, Put, Res } from '@nestjs/common';
import { ValuesService } from './values.service';
import { GetValueResponse } from './GetValueResponse';
import { GetValuesResponse } from './GetValuesResponse';
import { CreateValueRequest } from './CreateValueRequest';
import { CreateValueResponse } from './CreateValueResponse';
import { UpdateValueRequest } from './UpdateValueRequest';
import { UpdateValueResponse } from './UpdateValueResponse';

@Controller('values')
export class ValuesController {
    constructor(private readonly valuesService: ValuesService) {
    }

    @Get()
    async getValues() : Promise<GetValuesResponse> {
        // TODO: Paging example
        const values = await this.valuesService.getValues();
        return {
            values: values
        };
    }

    @Get(":key")
    async getValue(@Param("key") key: string) : Promise<GetValueResponse> {
        const value = await this.valuesService.getValue(key);
        
        if (value) {
            return value;
        }

        throw new HttpException(`Value with key "${key}" was not found.`, HttpStatus.NOT_FOUND);
    }

    @Post()
    async createValue(@Body() request : CreateValueRequest) : Promise<CreateValueResponse> {
        const response = await this.valuesService.createValue(request);
        return response;
    }

    @Put(":key")
    async updateValue(@Param("key") key: string, @Body() request: UpdateValueRequest): Promise<UpdateValueResponse> {
        const response = await this.valuesService.updateValue(key, request);

        if (response) {
            return response;
        }

        throw new HttpException(`Value with key "${key}" was not found.`, HttpStatus.NOT_FOUND);
    }

    @Delete(":key")
    @HttpCode(HttpStatus.NO_CONTENT)
    async deleteValue(@Param("key") key: string): Promise<void> {
        const deleted = await this.valuesService.deleteValue(key);

        if (!deleted) {
            throw new HttpException(`Value with key "${key}" was not found.`, HttpStatus.NOT_FOUND);
        }
    }
}
