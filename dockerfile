# Build the techradar image. Run this from the client's root directory:
#      docker build -t techradar .
# Run the 'latest' techradar image:
#      docker run --rm -it -p 80:80 techradar:latest

FROM node:10.15.3 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install

FROM nginx:1.15.10-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/docs /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]