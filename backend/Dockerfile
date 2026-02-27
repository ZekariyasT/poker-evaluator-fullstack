# ── Stage 1: compile ────────────────────────────────────────────────────────
FROM --platform=linux/amd64 golang:1.22-alpine AS builder

# protobuf-compiler (protoc) + the two Go protoc plugins
RUN apk add --no-cache protobuf && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

WORKDIR /app

# Copy proto definition and all Go source files.
# (go.sum does not exist yet; we let go mod tidy create it below.)
COPY proto/          proto/
COPY backend/go.mod  ./
COPY backend/        ./

# Generate Go types + gRPC stubs from the proto file.
# paths=source_relative writes proto/poker.pb.go and proto/poker_grpc.pb.go
RUN protoc \
      --go_out=.      --go_opt=paths=source_relative \
      --go-grpc_out=. --go-grpc_opt=paths=source_relative \
      proto/poker.proto

# Resolve every import (including the generated proto package) and pin go.sum.
RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o server .

# ── Stage 2: minimal runtime image ──────────────────────────────────────────
FROM --platform=linux/amd64 gcr.io/distroless/static-debian12

COPY --from=builder /app/server /server

# 8080 → gRPC-Web (for the Flutter browser client)
# 9090 → native gRPC  (for k6 load tests)
EXPOSE 8080 9090

ENTRYPOINT ["/server"]
