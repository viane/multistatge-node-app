#
# ---- Base Node ----
FROM alpine:3.5 AS base
# install node
RUN apk add --no-cache nodejs-current tini
# set working directory
WORKDIR /root/app
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]
# copy project file
COPY package.json .
 
# ---- Dependencies ----
FROM base AS dependencies
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
RUN cp -R node_modules prod_node_modules
RUN npm install
 
# ---- Test ----
FROM dependencies AS test
COPY . .
RUN  npm run posttest
 
# ---- Release ----
FROM base AS release
COPY --from=dependencies /root/app/prod_node_modules ./node_modules
COPY . .
EXPOSE 8080
CMD npm run start
