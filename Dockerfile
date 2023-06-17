FROM node:18-alpine as build-stage

WORKDIR /usr/src
COPY ./anecdotes .
RUN npm install && npm run build

FROM nginx:1.19-alpine

EXPOSE 80
COPY --from=build-stage /usr/src/build /usr/share/nginx/html

# https://medium.com/kocsistem/how-to-run-nginx-for-root-non-root-5ceb13db6d41
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid
USER nginx