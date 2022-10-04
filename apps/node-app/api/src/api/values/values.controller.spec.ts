import { Test, TestingModule } from '@nestjs/testing';
import { ValuesController } from './values.controller';
import { ValuesModule } from './values.module';

describe('ValuesController', () => {
  let controller: ValuesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [ValuesModule]
    }).compile();

    controller = module.get<ValuesController>(ValuesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
