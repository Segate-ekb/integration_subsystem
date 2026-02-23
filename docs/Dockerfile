# =============================================================================
# Dockerfile for VitePress Documentation
# Integration Subsystem (Подсистема интеграции)
# =============================================================================
# 
# This Dockerfile expects pre-built VitePress artifacts in docs/.vitepress/dist
# Build is done by GitHub Actions before Docker build
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
COPY nginx.conf /etc/nginx/nginx.conf

# Copy pre-built documentation (built by GitHub Actions)
COPY .vitepress/dist /usr/share/nginx/html

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
