# ---- Base Node ----
# Example from: https://gist.github.com/praveenweb/acd27014e6d244c3194d3e9d7da04e17
FROM node:carbon AS builder
# Create app directory
WORKDIR /app
# ---- Dependencies ----
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
# Install app dependencies including 'devDependencies'
RUN npm install
# ---- Copy Files/Build ----
WORKDIR /app
COPY src /app

# --- Release with Alpine ----
FROM node:8.9-alpine AS release  
# Create app directory
WORKDIR /app
# Copy app from the builder
COPY --from=builder /app ./
# Install app dependencies
RUN npm install --only=production
# Start
EXPOSE 8080
CMD ["node", "main.js"]