# Stage 1: Build & Install Dependencies
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first to leverage cache
COPY package*.json ./

# Install dependencies (including devDependencies if needed for build, though here we just need prod for runtime)
# Using 'npm ci' for clean install
RUN npm ci

# Copy source code
COPY . .

# Stage 2: Production
FROM node:20-alpine

# Set environment to production
ENV NODE_ENV=production

WORKDIR /app

# Create a non-root user 'node' (already exists in alpine image) and set permissions
# We need to create the logs directory and give ownership to the node user
RUN mkdir -p logs && chown -R node:node /app

# Switch to non-root user
USER node

# Copy dependencies from builder (only what's needed)
# Note: For a cleaner prod image, we could run 'npm ci --only=production' in a separate stage,
# but copying from builder is fine if we pruned.
# Let's do a fresh install of ONLY production modules in this stage or copy from a "prod-deps" stage.
# To keep it simple but effective:
COPY --from=builder --chown=node:node /app/package*.json ./
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/server.js ./

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:3000/api/demo || exit 1

EXPOSE 3000

CMD ["node", "server.js"]
