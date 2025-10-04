FROM nginx:alpine

# Copy the HTML file to nginx's default directory
COPY index.html /usr/share/nginx/html/

# Expose port 8080
EXPOSE 8080

# Update nginx config to listen on port 8080
RUN sed -i 's/listen\s*80;/listen 8080;/' /etc/nginx/conf.d/default.conf

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
