# Use the official Node.js image as the base image
FROM node:latest AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Next.js application
RUN npm run build

# Start a new stage from the base image
FROM node:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install only production dependencies
RUN npm install --production

# Copy the built Next.js application from the previous stage
COPY --from=builder /app/.next ./.next

# Expose the port your Next.js app runs on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
