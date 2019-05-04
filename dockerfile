# Stage 1: Build the application
# docker build -t ohif/viewer:latest .
FROM node:11.2.0-slim as builder

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ENV REACT_APP_CONFIG=config/example_openidc.js
ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /usr/src/app/package.json
COPY yarn.lock /usr/src/app/yarn.lock

ADD . /usr/src/app/
RUN yarn install
RUN yarn run build:web

# # Stage 2: Bundle the built application into a Docker container
# # which runs Nginx using Alpine Linux
FROM nginx:1.15.5-alpine
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
