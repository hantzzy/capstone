  
FROM nginx:1.17
COPY html-content /usr/share/nginx/html

EXPOSE 80