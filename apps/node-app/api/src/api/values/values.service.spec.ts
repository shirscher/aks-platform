import { Test, TestingModule } from '@nestjs/testing';
import { ValuesModule } from './values.module';
import { ValuesService } from './values.service';

describe('ValuesService', () => {
  let service: ValuesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [ValuesModule]
    }).compile();

    service = module.get<ValuesService>(ValuesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
