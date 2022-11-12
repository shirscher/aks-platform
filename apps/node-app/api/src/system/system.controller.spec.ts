import { Test, TestingModule } from '@nestjs/testing';
import { AppModule } from '../../app.module';
import { SystemController } from './system.controller';
import { SystemModule } from './system.module';

describe('SystemController', () => {
  let controller: SystemController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [SystemModule, AppModule]
    }).compile();

    controller = module.get<SystemController>(SystemController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
