# Step 1: Build Stage
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Step 2: Production Stage
FROM node:18-alpine

# Set environment variables
ENV NODE_ENV=production

# Set working directory inside the container
WORKDIR /app

# Copy built files from the build stage
COPY --from=builder /app/.output ./

# Install only production dependencies
COPY package*.json ./
RUN npm install --production

# Expose the port that the Nuxt app will run on
EXPOSE 3000

# Run the application
CMD ["node", "server/index.mjs"]
