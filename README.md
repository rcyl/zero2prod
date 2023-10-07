## To speed up linking

.cargo/config.toml

[target.x86_64-unknown-linux-gnu]

rustflags = ["-C", "linker=clang", "-C", "link-arg=fuse-ld=lld"]

## To get unused port from TcpListener
Need to put :0 after ip address

let listener = TcpListener::bind("127.0.0.1:0")
    .expect("failed to bind to random port");

let port = listener.local_addr().unwrap().port();

## Can try web::Form<Data> instead of web::Query to use actix's extractors

## Adding a migration
export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}

sqlx migrate add create_subscriptions_table // This creates the migrations folder and file 

## Can wrap the logger middleware in Actix
App::new()
    .wrap(Logger::default())

## To check for unused dependencies
cargo install cargo-udeps
cargo +nightly udeps

## Generate query metadata to support offline compile-time verification
sqlx-prepare 
cargo sqlx prepare -- --lib
// This generates sqlx-data.json which needs to be checked in 

## cargo chef
As long as dependencies do not change, the recipe.json file will stay
the same and therefore the output of cargo chef cook --release --recipe-path
recipe.json will be cached and massively speeding up the builds

## claims crate
Consider using this crate for more verbose assertions for asserting
error or option types. For example:
```
#[test]
fn dummy_fail() {
let result: Result<&str, &str> = Err("The app crashed due to an IO error");
claims::assert_ok!(result);
}
-- dummy_fail stdout ----
thread 'dummy_fail' panicked at 'assertion failed, expected Ok(..),
got Err("The app crashed due to an IO error")
```
versus
```
assert!(result);
--- dummy_fail stdout ----
thread 'dummy_fail' panicked at 'assertion failed: result.is_ok()'
```

## validator crate
Used to check email format (among other stuff)

## fake crate
Used to generate fake emails (among others)

## quickcheck
Alternative to proptest. Defines Arbitrary trait, that needs a source of
randomness and returns an instance of the type. Default number of loops is 100

## Generate random string
```
fn generate_subscription_token() -> String {
    let mut rng = thread_rng();
    std::iter::repeat_with(|| rng.sample(Alphanumeric))
        .map(char::from)
        .take(25)
        .collect()
}
```
## Mapping result to Option
```
result.map(|r| r.some_field)
```