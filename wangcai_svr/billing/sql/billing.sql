

CREATE TABLE IF NOT EXISTS anonymous_account
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    flag            TINYINT         NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS billing_account
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    money           INT             NOT NULL DEFAULT 0,
    freeze          INT             NOT NULL DEFAULT 0,
    income          INT             NOT NULL DEFAULT 0,
    outgo           INT             NOT NULL DEFAULT 0,
    shared_income   INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS billing_serial
(
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS billing_transaction
(
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    remark          TEXT            NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS billing_log
(
    id              INT             NOT NULL AUTO_INCREMENT,
    serial_num      CHAR(32)        NOT NULL DEFAULT '',
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    userid          INT             NOT NULL DEFAULT 0,
    money           INT             NOT NULL DEFAULT 0,
    remark          TEXT            NOT NULL DEFAULT '',
    insert_time     DATETIME        NOT NULL,
    err             INT             NOT NULL DEFAULT 0,
    msg             VARCHAR(255)    NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (serial_num),
    INDEX (device_id),
    INDEX (userid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;



