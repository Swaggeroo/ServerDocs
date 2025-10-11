FROM python:3.14.0-alpine AS builder
RUN apk add --no-cache build-base python3-dev
RUN pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin mkdocs-macros-plugin mkdocs-autolinks-plugin mkdocs-glightbox
WORKDIR /src
COPY src /src
RUN mkdocs build

FROM nginx:1.29.2-alpine
RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /src/site/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]