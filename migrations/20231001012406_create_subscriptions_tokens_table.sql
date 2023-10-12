-- Add migration script here
CREATE TABLE subscriptions_tokens(
    subscription_token TEXT NOT NULL,
    -- Subscriber id is a foreign key
    subscriber_id uuid NOT NULL
        REFERENCES subscriptions (id),
    PRIMARY KEY (subscription_token)
);