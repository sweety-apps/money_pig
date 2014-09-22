

CREATE TABLE IF NOT EXISTS task_of_user
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    task_id         INT             NOT NULL DEFAULT 0,
    type            INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    money           INT             NOT NULL DEFAULT 0,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, task_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS task_of_device
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    userid          INT             NOT NULL DEFAULT 0,
    task_id         INT             NOT NULL DEFAULT 0,
    type            INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    money           INT             NOT NULL DEFAULT 0,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id, task_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS task_base
(
    id              INT             NOT NULL DEFAULT 0,
    type            INT             NOT NULL DEFAULT 0,
    status          TINYINT         NOT NULL DEFAULT 0,
    title           VARCHAR(255)    NOT NULL DEFAULT '',
    icon            VARCHAR(255)    NOT NULL DEFAULT '',
    intro           VARCHAR(255)    NOT NULL DEFAULT '',
    descr           TEXT            NOT NULL DEFAULT '',
    steps           TEXT            NOT NULL DEFAULT '',
    money           INT             NOT NULL DEFAULT 0,
    insert_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX (type)
) ENGINE = MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- CREATE TABLE IF NOT EXISTS task_builtin
-- (
--     id              INT             NOT NULL AUTO_INCREMENT,
--     安装
--     填写个人资料
--     邀请好友
--     签到
--     ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--     PRIMARY KEY (id)
-- ) ENGINE = MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS task_daily
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    userid          INT             NOT NULL DEFAULT 0,
    date            DATE            NOT NULL,
    task_id         INT             NOT NULL DEFAULT 0,
    type            INT             NOT NULL DEFAULT 0,
    money           INT             NOT NULL DEFAULT 0,
    extra           TEXT            NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX (device_id, date),
    INDEX (userid, date)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS task_invite
(
    id              INT             NOT NULL AUTO_INCREMENT,
    userid          INT             NOT NULL DEFAULT 0,
    invitee         INT             NOT NULL DEFAULT 0,
    invite_code     VARCHAR(20)     NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (userid, invitee)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS task_app_download
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    userid          INT             NOT NULL DEFAULT 0,
    appid           CHAR(20)        NOT NULL DEFAULT '',
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id, appid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS task_app
(
    id              INT             NOT NULL AUTO_INCREMENT,
    appid           VARCHAR(255)    NOT NULL DEFAULT '',
    app_name        VARCHAR(255)    NOT NULL DEFAULT '',
    download_url    TEXT            NOT NULL DEFAULT '',
    redirect_url    TEXT            NOT NULL DEFAULT '',
    icon            VARCHAR(255)    NOT NULL DEFAULT '',
    genre           TINYINT         NOT NULL DEFAULT 0,
    filesize        BIGINT          NOT NULL DEFAULT 0,
    version         VARCHAR(64)     NOT NULL DEFAULT '',
    screenshots     TEXT            NOT NULL DEFAULT '',
    intro           TEXT            NOT NULL DEFAULT '', 
    last_update     DATETIME        NOT NULL,
    score           INT             NOT NULL DEFAULT 0,
    download_times  INT             NOT NULL DEFAULT 0,
    corp_id         INT             NOT NULL DEFAULT 0,
    corp            VARCHAR(255)    NOT NULL DEFAULT '',
    site            VARCHAR(255)    NOT NULL DEFAULT '',
    contact         VARCHAR(255)    NOT NULL DEFAULT '',
    insert_time     DATETIME        NOT NULL,
    money           INT             NOT NULL DEFAULT 0,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = MyISAM AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS offer_wall_point
(
    id              INT             NOT NULL AUTO_INCREMENT,
    device_id       CHAR(32)        NOT NULL DEFAULT '',
    type            INT             NOT NULL DEFAULT 0,
    point           INT             NOT NULL DEFAULT 0,
    create_time     DATETIME        NOT NULL,
    ts              TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (device_id, type)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
