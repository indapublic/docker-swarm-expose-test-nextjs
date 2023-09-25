ARG NODE_VERSION=18
FROM node:$NODE_VERSION-alpine as dependencies
WORKDIR /opt/app
COPY app/package.json app/package-lock.json ./
RUN npm install --from-lock-file

FROM node:$NODE_VERSION-alpine as builder
WORKDIR /opt/app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1
COPY --from=dependencies /opt/app/node_modules ./node_modules
COPY app .
RUN npm run build

FROM node:$NODE_VERSION-alpine as runner
WORKDIR /opt/app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 HOST=0.0.0.0 PORT=3000

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /opt/app/next.config.js ./
COPY --from=builder --chown=nextjs:nodejs /opt/app/public ./public
COPY --from=builder --chown=nextjs:nodejs /opt/app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /opt/app/node_modules ./node_modules

USER nextjs

EXPOSE 3000

CMD ["node_modules/.bin/next", "start"]
