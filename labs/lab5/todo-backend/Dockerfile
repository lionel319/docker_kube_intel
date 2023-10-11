FROM node:14-slim

LABEL org.opencontainers.image.source="1.0"
LABEL org.opencontainers.image.description="To Do List application backend"
LABEL org.opencontainers.image.vendor="Redhat Inc"
LABEL org.opencontainers.image.authors="smahalin@redhat.com"
LABEL org.opencontainers.image.created="2017-12-25"

USER 0

COPY . /opt/app-root/src


RUN cd /opt/app-root/src && \
    npm install && \
    npm run build

ENV DATABASE_SVC=127.0.0.1
ENV DATABASE_PORT=3306
ENV DATABASE_PASSWORD=password
ENV PORT=3000

EXPOSE 3000

USER 1001

WORKDIR /opt/app-root/src

CMD npm start