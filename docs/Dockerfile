# =============================================================================
# Dockerfile for VitePress Documentation
# Integration Subsystem (Подсистема интеграции)
# =============================================================================

# Build stage (if not using pre-built artifacts)
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY docs/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy documentation source
COPY docs/ ./

# Build VitePress
RUN npm run docs:build

# =============================================================================
# Production stage - nginx for serving static files
# =============================================================================
FROM nginx:1.25-alpine AS production

LABEL maintainer="Integration Subsystem Team"
LABEL org.opencontainers.image.title="Integration Subsystem Documentation"
LABEL org.opencontainers.image.description="VitePress documentation for 1C:Enterprise Integration Subsystem"
LABEL org.opencontainers.image.source="https://github.com/your-org/integration_subsystem"

# Build arguments for labels
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${VCS_REF}"

# Install curl for healthcheck
RUN apk add --no-cache curl

# Remove default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY docs/nginx.conf /etc/nginx/nginx.conf

# Copy built documentation from builder stage
# If using GitHub Actions artifact, this will be overwritten by the mounted dist folder
COPY --from=builder /app/.vitepress/dist /usr/share/nginx/html

# Alternatively, if dist is pre-built and passed as context:
# COPY docs/.vitepress/dist /usr/share/nginx/html

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
