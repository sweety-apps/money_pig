

CREATE TABLE IF NOT EXISTS anonymous_device
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    idfa            VARCHAR(64)     NOT NULL DEFAULT '',
    mac             VARCHAR(64)     NOT NULL DEFAULT '',
    platform        VARCHAR(128)    NOT NULL DEFAULT '',
    activate_time   DATETIME        NOT NULL,
    flag            TINYINT         NOT NULL DEFAULT 0,
    sex             TINYINT         NOT NULL DEFAULT 0,
    age             TINYINT         NOT NULL DEFAULT 0,
    career          VARCHAR(255)    NOT NULL DEFAULT '',
    interest        TEXT            NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS user_device
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    idfa            VARCHAR(64)     NOT NULL DEFAULT '',
    mac             VARCHAR(64)     NOT NULL DEFAULT '',
    platform        VARCHAR(128)    NOT NULL DEFAULT '',
    activate_time   DATETIME        NOT NULL,
    flag            TINYINT         NOT NULL DEFAULT 0,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id),
    INDEX (userid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS user_info
(
    id              INT             NOT NULL AUTO_INCREMENT,
    phone_num       CHAR(20)        NOT NULL DEFAULT '',
    nickname        VARCHAR(64)     NOT NULL DEFAULT '',
    passwd          VARCHAR(64)     NOT NULL DEFAULT '',
    sex             TINYINT         NOT NULL DEFAULT 0,
    age             TINYINT         NOT NULL DEFAULT 0,
    interest        TEXT            NOT NULL DEFAULT '',
    invite_code     VARCHAR(20)     NOT NULL DEFAULT '',
    inviter_id      INT             NOT NULL DEFAULT 0,
    inviter_code    VARCHAR(20)     NOT NULL DEFAULT '',
    create_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (phone_num),
    UNIQUE (invite_code)
) ENGINE = InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS login_history
(
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    platform        VARCHAR(128)    NOT NULL DEFAULT '',
    version         VARCHAR(64)     NOT NULL DEFAULT '',
    ip              VARCHAR(64)     NOT NULL DEFAULT '',
    network         VARCHAR(64)     NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (userid),
    INDEX (device_id)
) ENGINE = MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

