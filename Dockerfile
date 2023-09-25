ARG NODE_VERSION=18
FROM node:$NODE_VERSION-alpine as dependencies
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm install --from-lock-file

FROM node:$NODE_VERSION-alpine as builder
ARG ENVIRONMENT=production
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY app .
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM node:$NODE_VERSION-alpine as runner
WORKDIR /app
ENV HOST=0.0.0.0 PORT=3000 NODE_ENV=production NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY dummy.js /app

USER nextjs

EXPOSE 3000
# EXPOSE 3001

CMD ["node", "server.js"]
# CMD ["node", "dummy.js"]
