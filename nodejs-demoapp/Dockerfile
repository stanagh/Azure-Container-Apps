# ----- BUILD STAGE -----
FROM node:18-alpine AS build

WORKDIR /app

COPY src/package*.json ./

# Install ONLY production dependencies
RUN npm install --production

COPY src/. .

# ----- RUN STAGE -----
FROM node:18-alpine

RUN adduser -D -u 10001 newuser

WORKDIR /app

# Copy only the production-ready files from build stage
COPY --from=build /app /app

USER newuser

EXPOSE 3000
ENV NODE_ENV=production

CMD ["npm", "start"]

