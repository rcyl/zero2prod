FROM rust:1.59.0-slim as builder

WORKDIR /app
RUN apt update && apt install lld clang -y
#copy all files from our working environment to Docker image
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release

#Runtime stage
FROM rust:1.59.0 AS runtime

WORKDIR /app
#copy compiled binary from the builder env to runtime env
COPY --from=builder /app/target/release/zero2prod zero2prod
#We need the conguration file at runtime
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./zero2prod"]