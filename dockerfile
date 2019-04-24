# Build the phoenix.api image. Run this from the client's root directory:
#      docker build -t techradar .
# Run the 'latest' phoenix.api image:
#      docker run --rm -it -p 80:80 techradar:latest

# build environment
FROM node:10.15.3 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
#COPY package.json /usr/src/app/package.json
COPY . /usr/src/app
#COPY package-lock.json /usr/src/app/package-lock.json
#COPY .npmrc /usr/src/app/.npmrc
RUN npm install
#COPY . /usr/src/app
RUN npm run

# production environment
FROM nginx:1.15.10-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]