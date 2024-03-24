# Use node 16 Alpine image as the builder stage
FROM node:16-alpine as builder

# Set the user to node
USER node

# Create app directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Copy package.json and package-lock.json if exists
COPY --chown=node:node package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY --chown=node:node . .

# Build the application
RUN npm run build

# Use NGINX base image for serving the application
FROM nginx

# Copy the build output from the builder stage to NGINX's HTML directory
COPY --from=builder /home/node/app/build /usr/share/nginx/html
