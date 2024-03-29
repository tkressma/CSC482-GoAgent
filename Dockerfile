# Start the Go app build
FROM golang:latest AS build

# Copy source
WORKDIR /src
COPY /src /src

# Get required modules (assumes packages have been added to ./vendor)
RUN go mod download

# Build a statically-linked Go binary for Linux
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .


# New build phase -- create binary-only image
FROM alpine:latest

# Add support for HTTPS
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates

WORKDIR /

# Copy files from previous build container
COPY --from=build /src/main ./

# Add environment variables
# ENV ...
ENV AWS_REGION=us-east-1
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV LOGGLY_TOKEN=

# Check results
RUN env && pwd && find .

# Start the application
CMD ["./main"]
