FROM lukemathwalker/cargo-chef:latest-rust-1.72.0 as chef
WORKDIR /app
RUN apt update && apt install lld clang -y

FROM chef as planner
#copy all files from our working environment to Docker image
COPY . .
# Computer a lock like file for our proejct
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json
# Build project dependencies, not application!
RUN cargo chef cook --release --recipe-path recipe.json
# Up to this point, if dependency tree stats the same, all the layers
# should be cached
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release --bin zero2prod

#Runtime stage
FROM debian:bookworm-slim AS runtime
WORKDIR /app
# Install OpenSSL
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
#copy compiled binary from the builder env to runtime env
COPY --from=builder /app/target/release/zero2prod zero2prod
#We need the conguration file at runtime
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./zero2prod"]