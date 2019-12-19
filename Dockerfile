FROM arm32v7/node:10-buster-slim

RUN apt-get update \
    && apt-get install -y \
    python \
    python-pip \
    make \
    g++ \
    && apt-get install -y --no-install-recommends \
    gosu
    
RUN pip install RPi.GPIO

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN mkdir -p /usr/src/node-red
RUN mkdir /data
WORKDIR /usr/src/node-red


# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN yarn

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

USER root

RUN apt-get remove -y make g++
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]
CMD ["yarn", "run", "start", "--userDir", "/data"]

