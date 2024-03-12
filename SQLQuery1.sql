USE twitter_db;

DROP DATABASE IF EXIST twitter_db;

CREATE TABLE users (
    user_id INT IDENTITY(1,1) NOT NULL,
    user_handle VARCHAR(50) NOT NULL UNIQUE,
    email_address VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber CHAR(10) UNIQUE,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(user_id)
	
)

--INSERTAR DATOS EN LA TABLA

INSERT INTO users (user_handle, email_address, first_name, last_name, phonenumber, created_at)
VALUES
('SelenaCuadra', 'selenac99@hotmail.com', 'Selena', 'Cuadra', '1126017576', GETDATE()),
('EtienneLartigue', 'etienne5@hotmail.com', 'Etienne', 'Lartigue', '3487686889', GETDATE()),
('NadinaMontani', 'nadinamontani@gmail.com', 'Nadina', 'Montani', '1126017578', GETDATE()),
('Gina89', 'Jorgelina@gotmail.com', 'Jorgelina', 'Fagnani', '3487473725', GETDATE()),
('Piki89', 'PikiCuadra@hotmail.com', 'Adriel', 'Cuadra', '1126017577', GETDATE()),
('Pachu', 'PachuCuadra@hotmail.com', 'Francesco', 'Cuadra', '1126017579', GETDATE());

--SELECT * FROM users;
--DROP TABLE users;

--DROP TABLE IF EXISTS followers;


--CREACION TABLA DE FOLLOWERS

CREATE TABLE followers (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (following_id) REFERENCES users(user_id),
	PRIMARY KEY (follower_id, following_id),
);



ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id <> following_id);

INSERT INTO followers(follower_id, following_id)
VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 6),
(2, 5),
(3, 5),


--Se pueden añadir constrains para hacer checks*/
/*DELETE FROM followers
WHERE follower_id = following_id;*/

/*SELECT *
FROM followers
WHERE follower_id = following_id;*/

select * from followers;

INSERT INTO followers(follower_id, following_id)
VALUES
(5, 6),
(2, 5),
(3, 5);

SELECT  follower_id, following_id FROM followers;
SELECT follower_id FROM followers WHERE following_id = 1;
SELECT COUNT(follower_id) AS followers FROM followers WHERE following_id = 1
--Top 3 usuarios con mayor número de seguidores
SELECT TOP 3 following_id, COUNT(follower_id) AS followers --los 3 primeros! ACA SE USA TOP 3 
FROM followers GROUP BY following_id
ORDER BY followers DESC 
/*SELECT ID,Nombre,Apellido,
Correoelectrónico,AddressLine,Nota
FROM Empleado
WHERE Nota is null
ORDER BY ID
LIMIT 3*/


--Top 3 usuarios pero con JOIN
SELECT TOP 3 users.user_id, users.user_handle, users.first_name, followers.following_id, COUNT(followers.follower_id) AS followers_count
FROM followers
JOIN users ON users.user_id = followers.following_id
GROUP BY users.user_id, users.user_handle, users.first_name, followers.following_id
ORDER BY followers_count DESC;

--CREATE TABLE DE TUITS

CREATE TABLE tweets(
	tweet_id INT IDENTITY(1, 1) NOT NULL,
	user_id INT NOT NULL,
	tweet_text VARCHAR(280) NOT NULL,
	num_likes INT DEFAULT 0,
	num_retweets INT DEFAULT 0,
	num_comments INT DEFAULT 0,
	created_at DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	PRIMARY KEY(tweet_id)
	);


--INSERTANDO VALORES A LA TABLA
--SE ME BORRARON LPM

INSERT INTO tweets(user_id, tweet_text, created_at)
VALUES
(1, 'mi instagram es: Selena Cuadra', GETDATE()),
(1, 'me encuentro estudiando desarrollo FullStack', GETDATE()),
(5, 'HOLAAAAAA', GETDATE()),
(6, 'AGUANTE EL FUTBOL', GETDATE());

SELECT * FROM tweets;


--¿CUANTOS TWEETS HIZO UN USUARIO?

SELECT user_id, COUNT(*) AS tweet_count FROM tweets GROUP BY user_id
 
--SUBCONSULTA:
--Obtener los tweets de los usuarios que tienen más de 2 seguidores

SELECT tweet_id, tweet_text, user_id 
FROM tweets 
WHERE user_id IN (
	SELECT following_id
	FROM followers 
	GROUP BY following_id 
	HAVING COUNT(*) > 2
);


--DELETE
DELETE FROM tweets WHERE tweet_id = 1;
DELETE FROM tweets WHERE user_id = 1;

--UPDATE
UPDATE tweets SET num_comments = num_comments + 1 WHERE tweet_id = 2;

--REEMPLAZAR TEXTO
UPDATE tweets SET tweet_text = REPLACE(tweet_text, 'Desarrollado', 'Developer')
select tweet_text from tweets

--QUIEN HA DADO LIKE? se tiene que crear una tabla para relacionar

CREATE TABLE tweet_likes(
	user_id INT NOT NULL,
	tweet_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
	PRIMARY KEY (user_id, tweet_id)
)

INSERT INTO tweet_likes(user_id, tweet_id)
VALUES
(1, 3), (1, 1), (2, 2), (3, 2), (3, 3)


--NO EXISTEN TODOS
SELECT user_id
FROM users
WHERE user_id IN (1, 2, 3, 7);

--TRIGGERS: Cuando ocurre algo en nuestra base de datos antes o despues de actualizar o insertar o algo

CREATE TRIGGER increase_follower_count
ON followers
AFTER INSERT
AS
BEGIN
    UPDATE users SET follower_count = follower_count + 1
    WHERE user_id IN (SELECT following_id FROM INSERTED);
END;



ALTER TABLE users
ADD follower_count INT DEFAULT 0;
INSERT INTO followers(follower_id, following_id)
VALUES
(5,2),
(4,5),
(6,5)
select * from users
