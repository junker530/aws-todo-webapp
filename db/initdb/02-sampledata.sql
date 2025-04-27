USE todo;
SET CHARSET UTF8;

-- ユーザーテーブルにサンプルユーザーを追加
INSERT INTO Users (Username, EmailAddress, Password, OtherUserInfo)
VALUES ('SampleUser', 'sampleuser@example.com', 'hashedpassword', 'その他のユーザー情報');

-- タスクテーブルにサンプルタスクを追加
INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId)
VALUES ('重要なプレゼン資料作成', '重要なクライアントのプレゼン資料を作成する', '2023-08-10', '高', '未完了', 1);

INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId)
VALUES ('週次レポート作成', '週次レポートを作成して提出する', '2023-08-15', '中', '未完了', 1);

INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId)
VALUES ('誕生日プレゼントの購入', '友人の誕生日プレゼントを購入する', '2023-08-20', '低', '未完了', 1);

INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId)
VALUES ('新しい本を読む', '新刊の小説を購入して読む', '2023-08-25', '中', '未完了', 1);

INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId)
VALUES ('旅行の予約', '次の休暇に向けて旅行の予約をする', '2023-08-30', '高', '未完了', 1);
