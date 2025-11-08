FROM node:18 AS Build

WORKDIR /app
COPY src/package*.json ./
RUN npm install
COPY src/. .
RUN npm ci && npm cache clean --force
ENV NODE_ENV=production

# Build the application
FROM node:18-alpine
# RUN useradd --no-create-home --uid 10001 newuser
WORKDIR /app

COPY --from=Build /app ./

RUN npm install -g serve

RUN npm install --production --silent
# ENV NODE_ENV=production
# USER newuser
EXPOSE 3000
CMD ["npm", "start"]

