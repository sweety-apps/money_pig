

CREATE TABLE IF NOT EXISTS sms_center
(
    id              INT             NOT NULL AUTO_INCREMENT,
    token           CHAR(40)        NOT NULL DEFAULT '',
    phone_num       VARCHAR(20)     NOT NULL DEFAULT '', 
    sms_code        VARCHAR(20)     NOT NULL DEFAULT '',
    action          TINYINT         NOT NULL DEFAULT 0,
    data            TEXT            NOT NULL DEFAULT '',
    status          TINYINT         NOT NULL DEFAULT 0,
    insert_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (token)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

