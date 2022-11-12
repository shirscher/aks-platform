import { Test, TestingModule } from '@nestjs/testing';
import { AppModule } from '../app.module';
import { SqlHealthCheckProvider } from './SqlHealthCheckProvider'

describe('SqlHealthCheckProvider', () => {
  let provider: SqlHealthCheckProvider;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [AppModule]
    }).compile();

    provider = module.get<SqlHealthCheckProvider>(SqlHealthCheckProvider);
  });

  it('should be defined', () => {
    expect(provider).toBeDefined();
  });
});
