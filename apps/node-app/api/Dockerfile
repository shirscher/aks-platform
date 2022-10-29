FROM node:16.17-alpine3.15 as build

WORKDIR /usr/app

COPY ./package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:16.17-alpine3.15 as production

# TODO: Why are these here? Doesn't .env or configmap cover these?
ENV BUILD_NUMBER=0.0.0.0
ENV NODE_ENV=production
ENV NESTJS_PORT=8080

WORKDIR /usr/app

COPY ./package*.json ./

RUN npm install --only=production && rm ./package*.json

COPY --from=build /usr/app/dist ./

USER node

CMD ["node", "main.js"]