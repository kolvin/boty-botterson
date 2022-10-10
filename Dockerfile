ARG GOLANG_BUILD_TAG="1.19-alpine"
ARG ALPINE_TAG="latest"

FROM golang:$GOLANG_BUILD_TAG as build

WORKDIR /go/src/app

COPY app/go.mod .
# COPY app/go.sum .

RUN go mod download

RUN go install github.com/cespare/reflex@latest

COPY app/*.go .

RUN ls -la
RUN go build -o ./main .

FROM alpine:$ALPINE_TAG

RUN apk --no-cache add ca-certificates
WORKDIR /root/

# Copy executable from builder
COPY --from=builder /go/src/app/main .

EXPOSE 8080

CMD ["./main"]
