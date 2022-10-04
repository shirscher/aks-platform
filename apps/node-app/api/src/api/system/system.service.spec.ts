import { Test, TestingModule } from '@nestjs/testing';
import { SystemModule } from './system.module';
import { SystemService } from './system.service';

describe('SystemService', () => {
  let service: SystemService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [SystemModule]
    }).compile();

    service = module.get<SystemService>(SystemService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
