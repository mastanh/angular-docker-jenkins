FROM nginx:1.17.9-alpine as runtime
COPY nginx.conf /etc/nginx/conf.d/
COPY dist/ /usr/share/nginx/html
EXPOSE 80
