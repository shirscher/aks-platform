import { Test, TestingModule } from '@nestjs/testing';
import { AppModule } from '../../app.module';
import { SystemModule } from './system.module';
import { SystemService } from './system.service';

describe('SystemService', () => {
  let service: SystemService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [SystemModule, AppModule]
    }).compile();

    service = module.get<SystemService>(SystemService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
