-- 1. Создать базу данных книг. Подключиться к базе данных.
--           Создать таблицу для хранения данных о книгах со следующими полями:
--           - идентификатор (id)
--           - название
--           - год издания
--           - количество страниц
--           - id автора
--           Создать таблицу авторов книг со следующими полями:
--           - идентификатор (id)
--           - имя
--           - фамилия
--
-- Сделать первичным ключом каждой таблицы идентификатор.
-- Добавить идентификаторам авто-инкрементирование.
-- В таблице книг сделать внешний ключ на таблицу авторов (поле id автора)
-- 2. Заполнить таблицу авторов данными (5 записей)   +
-- 3. Заполнить таблицу книг данными (10 записей)     +
-- 4. Написать запрос, выбирающий: название книги, год и имя автора, отсортированные по году издания книги в возрастающем порядке.
--       Написать тот же запрос, но для убывающего порядка.
-- 5. Написать запрос, выбирающий количество книг у заданного автора.
-- 6. Написать запрос, выбирающий книги, у которых количество страниц больше среднего количества страниц по всем книгам
-- 7. Написать запрос, выбирающий 5 самых старых книг
-- 8. Дополнить запрос и посчитать суммарное количество страниц среди этих книг
-- 9. Написать запрос, изменяющий количество страниц у одной из книг
-- 10. Написать запрос, удаляющий автора, который написал самую большую книгу


-- 1. Создать базу данных книг. Подключиться к базе данных.
CREATE DATABASE book_repository;


CREATE TABLE author
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name  VARCHAR NOT NULL
);

CREATE TABLE book
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR NOT NULL,
    year            INT     NOT NULL,
    number_of_pages INT     NOT NULL,
    id_author       INT REFERENCES author ON DELETE CASCADE
);

-- 2. Заполнить таблицу авторов данными (5 записей)

INSERT INTO author(first_name, last_name)
VALUES ('Джошуа', 'Блох'),
       ('Брюс', 'Эккель'),
       ('Роберт', 'Мартин'),
       ('Герберт', 'Шилдт'),
       ('Роберт', 'Сенджвик');


-- 3. Заполнить таблицу книг данными (10 записей)

INSERT INTO book (name, year, number_of_pages, id_author)
VALUES ('Java. Эффективное программирование', 2009, 600, (SELECT id FROM author WHERE last_name = 'Блох')),
       ('Философия Java', 2000, 800, (SELECT id FROM author WHERE last_name = 'Эккель')),
       ('Мышление в C++', 2005, 700, (SELECT id FROM author WHERE last_name = 'Эккель')),
       ('Чистый код', 2009, 900, (SELECT id FROM author WHERE last_name = 'Мартин')),
       ('The clean coder', 2011, 750, (SELECT id FROM author WHERE last_name = 'Мартин')),
       ('Чистая архитектура', 2017, 850, (SELECT id FROM author WHERE last_name = 'Мартин')),
       ('C# полное руководство', 2013, 900, (SELECT id FROM author WHERE last_name = 'Шилдт')),
       ('Java полное руководство', 2012, 1300, (SELECT id FROM author WHERE last_name = 'Шилдт')),
       ('Полный справочник по C++', 2004, 1000, (SELECT id FROM author WHERE last_name = 'Шилдт')),
       ('Алгоритмы', 1983, 700, (SELECT id FROM author WHERE last_name = 'Сенджвик'));


-- 4. Написать запрос, выбирающий: название книги, год и имя автора, отсортированные по году издания книги в возрастающем порядке.
--       Написать тот же запрос, но для убывающего порядка.


SELECT name,
       year,
       (SELECT a.first_name
        FROM author a
        WHERE a.id = book.id_author)
FROM book
ORDER BY book.year;


SELECT name,
       year,
       (SELECT a.first_name
        FROM author a
        WHERE a.id = book.id_author)
FROM book
ORDER BY book.year DESC;


-- 5. Написать запрос, выбирающий количество книг у заданного автора.
SELECT count(id_author)
FROM book
WHERE id_author = (SELECT id
                   FROM author
                   WHERE last_name = 'Сенджвик');



-- 6. Написать запрос, выбирающий книги, у которых количество страниц
-- больше среднего количества страниц по всем книгам

SELECT id, name, year, number_of_pages, id_author
FROM book
WHERE number_of_pages > (SELECT avg(number_of_pages)
                         FROM book);


-- 7. Написать запрос, выбирающий 5 самых старых книг

SELECT id, name, year, number_of_pages, id_author
FROM book
ORDER BY year
LIMIT 5;


-- 8. Дополнить запрос и посчитать суммарное количество страниц среди этих книг

SELECT sum(old_book.number_of_pages)
FROM (SELECT number_of_pages
      FROM book
      ORDER BY year
      LIMIT 5) old_book;


-- 9. Написать запрос, изменяющий количество страниц у одной из книг

UPDATE book
SET number_of_pages = 500
WHERE id = 2;


-- 10. Написать запрос, удаляющий автора, который написал самую большую книгу

DELETE
FROM author
WHERE id = (SELECT id_author
            FROM book
            WHERE number_of_pages = (SELECT max(number_of_pages)
                                     FROM book));
