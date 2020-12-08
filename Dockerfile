FROM golang:latest
WORKDIR /src
COPY /src /src
RUN go get github.com/jamespearly/loggly
RUN go install github.com/jamespearly/loggly 
RUN go get -u github.com/aws/aws-sdk-go/...
