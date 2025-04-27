USE todo;
SET CHARSET UTF8;

DROP TABLE IF EXISTS TaskMetaInfo;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Users;

-- ユーザーテーブルを作成
CREATE TABLE Users (
    UserId INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    OtherUserInfo VARCHAR(255)
);

-- タスクテーブルを作成
CREATE TABLE Tasks (
    TaskId INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Deadline DATETIME,
    Priority VARCHAR(20),
    Status VARCHAR(20),
    UserId INT NOT NULL,  -- UsersテーブルのUserIdと関連付ける外部キー
    FOREIGN KEY (UserId) REFERENCES Users (UserId)
);

-- タグテーブルを作成
CREATE TABLE Tags (
    TagId INT AUTO_INCREMENT PRIMARY KEY,
    TagName VARCHAR(50) NOT NULL
);

-- タスクとタグの関連テーブルを作成
CREATE TABLE TaskMetaInfo (
    TaskId INT NOT NULL,  -- TasksテーブルのTaskIdと関連付ける外部キー
    TagId INT NOT NULL,   -- TagsテーブルのTagIdと関連付ける外部キー
    PRIMARY KEY (TaskId, TagId),
    FOREIGN KEY (TaskId) REFERENCES Tasks (TaskId),
    FOREIGN KEY (TagId) REFERENCES Tags (TagId)
);
