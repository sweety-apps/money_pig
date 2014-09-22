

CREATE TABLE IF NOT EXISTS order_base
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    type            INT             NOT NULL DEFAULT 0,
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    status          TINYINT         NOT NULL DEFAULT 0,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, serial_num)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS order_alipay_transfer
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    alipay_account  VARCHAR(64)     NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    confirm_time    DATETIME        NOT NULL,
    operate_time    DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, serial_num)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS order_phone_payment
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    phone_num       VARCHAR(20)     NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    confirm_time    DATETIME        NOT NULL,
    operate_time    DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, serial_num)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS order_exchange_code
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    exchange_type   INT             NOT NULL DEFAULT 0,
    exchange_code   VARCHAR(255)    NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    confirm_time    DATETIME        NOT NULL,
    operate_time    DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, serial_num)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS exchange_code_jingdong
(
    id              INT             NOT NULL AUTO_INCREMENT,
    code            CHAR(32)        NOT NULL DEFAULT '',
    status          TINYINT         NOT NULL DEFAULT 0,
    insert_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (code)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS exchange_code_xlvip
(
    id              INT             NOT NULL AUTO_INCREMENT,
    code            CHAR(32)        NOT NULL DEFAULT '',
    type            TINYINT         NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    insert_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (code)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


