import { Controller, Get, Post } from '@nestjs/common';
import { ValuesService } from './values.service';
import { GetValueResponse } from './GetValueResponse';
import { GetValuesResponse } from './GetValuesResponse';
import { CreateValueRequest } from './CreateValueRequest';
import { CreateValueResponse } from './CreateValueResponse';

@Controller('values')
export class ValuesController {
    constructor(private readonly valuesService: ValuesService) {
    }

    @Get()
    async getValues() : Promise<GetValuesResponse> {
        const response = await this.valuesService.getValues();
        return response;
    }

    @Get("{key}")
    async getValue(key: string) : Promise<GetValueResponse> {
        const response = await this.valuesService.getValue(key);
        return response;
    }

    @Post()
    async createValue(request : CreateValueRequest) : Promise<CreateValueResponse> {
        const response = await this.valuesService.createValue(request);
        return response;
    }
}
