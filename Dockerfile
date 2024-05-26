FROM node:latest
# Create app directory
WORKDIR /

# Install app dependencies
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "index.js" ]

