CREATE DATABASE hotel_analysis;
USE hotel_analysis;
USE hotel_analysis;

CREATE TABLE customers (
    customer_id      INTEGER       PRIMARY KEY,
    customer_name    VARCHAR(100)  NOT NULL,
    customer_segment VARCHAR(20)   NOT NULL,
    signup_date      DATE          NOT NULL,
    home_city        VARCHAR(50),
    loyalty_tier     VARCHAR(20)   NOT NULL
);
CREATE TABLE properties (
    property_id     INTEGER       PRIMARY KEY,
    property_name   VARCHAR(100)  NOT NULL,
    property_city   VARCHAR(50)   NOT NULL,
    property_type   VARCHAR(20)   NOT NULL,
    star_rating     INTEGER       NOT NULL,
    total_rooms     INTEGER       NOT NULL,

    UNIQUE (property_name, property_city)
);
CREATE TABLE bookings (
    booking_id       INTEGER        PRIMARY KEY,
    customer_id      INTEGER        NOT NULL,
    property_id      INTEGER        NOT NULL,
    booking_date     DATE           NOT NULL,
    checkin_date     DATE           NOT NULL,
    checkout_date    DATE           NOT NULL,
    room_type        VARCHAR(30),
    num_rooms        INTEGER        NOT NULL,
    nights           INTEGER        NOT NULL,
    booking_channel  VARCHAR(30)    NOT NULL,
    adr              DECIMAL(10,2)  NOT NULL,
    discount_amount  DECIMAL(10,2)  NOT NULL DEFAULT 0,
    coupon_code      VARCHAR(20),
    total_amount     DECIMAL(10,2)  NOT NULL,
    payment_method   VARCHAR(30),
    booking_status   VARCHAR(20)    NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (property_id) REFERENCES properties(property_id),

    CHECK (checkout_date > checkin_date),
    CHECK (num_rooms > 0)
);
CREATE TABLE reviews (
    review_id      INTEGER       PRIMARY KEY AUTO_INCREMENT,
    booking_id     INTEGER       NOT NULL UNIQUE,
    review_rating  DECIMAL(3,1)  NOT NULL,
    review_date    DATE          NOT NULL,

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    CHECK (review_rating >= 1 AND review_rating <= 10)
);