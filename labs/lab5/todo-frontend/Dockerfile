FROM node:14-slim AS appbuild

LABEL org.opencontainers.image.source="1.0"
LABEL org.opencontainers.image.description="To Do List application builder"

ENV REACT_APP_API_HOST=""

USER 0

COPY . /tmp/todo-frontend

RUN cd /tmp/todo-frontend && npm install && npm run build

FROM nginx

LABEL org.opencontainers.image.source="1.0"
LABEL org.opencontainers.image.description="To Do List application front-end"
LABEL org.opencontainers.image.vendor="Redhat Inc"
LABEL org.opencontainers.image.authors="smahalin@redhat.com"
LABEL org.opencontainers.image.created="2017-12-25"

COPY nginx.conf /etc/nginx/
COPY --from=appbuild /tmp/todo-frontend/build /usr/share/nginx/html

EXPOSE 8080

CMD nginx -g "daemon off;"