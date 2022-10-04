import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

const DEFAULT_PORT = 8080;

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  let port = parseInt(process.env.NESTJS_PORT);
  if (isNaN(port)) {
    port = DEFAULT_PORT;
  }
  await app.listen(port);
  console.log(`Listening on port ${port}`);
}
bootstrap();
