FROM golang:1.21.4-alpine3.18 AS build-state

WORKDIR /workspace

COPY . .

RUN go mod download

RUN go build -o main .

FROM alpine:3.18 AS runner-state

WORKDIR /app

COPY --from=build-state /workspace/main .

ENTRYPOINT ["./main"]
