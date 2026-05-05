--viols: 
--insert commiting key violation
INSERT INTO USERS VALUES (1, 'example@gmail.com', 'Example', '2026-01-01 00:00:00');
--update committing key violation
UPDATE USERS SET user_id = 2 WHERE user_id = 1;
--insert created referential integrity violation
INSERT INTO Favorite_Parts VALUES (200, 1);
--delete creating referential integrity violation
SELECT * FROM Favorite_Parts WHERE user_id = 1;
DELETE FROM USERS WHERE user_id = 1; 
SELECT * FROM Favorite_Parts WHERE user_id = 1;
--update creating referential integrity violation
UPDATE Part_Review SET User_ID = 200 WHERE User_ID = 2;

