--1. Создать базу данных перелетов flight_repository со следующими таблицами:
-- airport (аэропорт)
--    code (уникальный код аэропорта)
--    country (страна)
--    city (город)
-- aircraft (самолет)
--    id
--    model (модель самолета - unique)
-- seat (место в самолете)
--    aircraft_id (самолет)
--    seat_no (номер места в самолете)
-- flight (рейс)
--    id (номер рейса не уникальный, поэтому нужен id)
--    flight_no (номер рейса)
--    departure_date (дата вылета)
--    departure_airport_code (аэропорт вылета)
--    arrival_date (дата прибытия)
--    arrival_airport_code (аэропорт прибытия)
--    aircraft_id (самолет)
--    status (статус рейса: cancelled, arrived, departed, scheduled)
-- ticket (билет на самолет)
--    id
--    passenger_no (номер паспорта пассажира)
--    passenger_name (имя и фамилия пассажира)
--    flight_id (рейс)
--    seat_no (номер места в самолете – flight_id + seat-no - unique)
--    cost (стоимость)
--
--
-- 2. Занести информацию во все созданные таблицы
--
-- Запросы:
-- 3. Кто летел позавчера рейсом Минск (MNK) - Лондон (LDN) на месте B1?
-- 4. Сколько мест осталось незанятыми 2020-06-14 на рейсе MN3002?
-- 5. Какие 2 перелета были самые длительные за все время?
-- 6. Какая максимальная и минимальная продолжительность перелетов междуflight_repository
--      Минском и Лондоном и сколько было всего таких перелетов?
-- 7. Какие имена встречаются чаще всего и какую долю от числа всех пассажиров они составляют?
-- 8. Вывести имена пассажиров, сколько всего каждый с таким именем купил билетов,
--      а также на сколько это количество меньше от того имени пассажира, кто купил билетов больше всего
-- 9. Вывести стоимость всех маршрутов по убыванию. Отобразить разницу в стоимости
--      между текущим и ближайшими в отсортированном списке маршрутами


--------------- Задание 1---------------------------------------
CREATE DATABASE flight_repository;



CREATE TABLE airport
(
    code    VARCHAR(3) PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    city    VARCHAR(100) NOT NULL
);



CREATE TABLE aircraft
(
    id    SERIAL PRIMARY KEY,
    model VARCHAR(100) NOT NULL UNIQUE
);



CREATE TABLE seat
(
    aircraft_id INT REFERENCES aircraft (id),
    seat_no     VARCHAR(4) NOT NULL,
    PRIMARY KEY (aircraft_id, seat_no)
);

CREATE TABLE flight
(
    id                     SERIAL PRIMARY KEY,
    flight_no              VARCHAR(20)                          NOT NULL,
    departure_date         TIMESTAMP                            NOT NULL,
    departure_airport_code VARCHAR(3) REFERENCES airport (code) NOT NULL,
    arrival_date           TIMESTAMP                            NOT NULL,
    arrival_airport_code   VARCHAR(3) REFERENCES airport (code) NOT NULL,
    aircraft_id            INT REFERENCES aircraft (id)         NOT NULL,
    status                 VARCHAR(20)                          NOT NULL
);

CREATE TABLE ticket
(
    id             SERIAL PRIMARY KEY,
    passenger_no   INT UNIQUE,
    passenger_name VARCHAR(128) NOT NULL,
    flight_id      INT REFERENCES flight (id),
    seat_no        VARCHAR(4),
    cost           MONEY        NOT NULL,
    UNIQUE (flight_id, seat_no)
);


-------------Задание 2. Занести информацию во все созданные таблицы--------------------

INSERT INTO airport(code, country, city)
VALUES ('VNK', 'Россия', 'Москва'),
       ('PTR', 'Россия', 'Питер'),
       ('MNK', 'Беларусь', 'Минск'),
       ('LDN', 'Англия', 'Лондон'),
       ('KRD', 'Россия', 'Краснодар'),
       ('VTB', 'Беларусь', 'Витебск');


INSERT INTO aircraft(model)
VALUES ('Airbus A220'),
       ('Airbus A310'),
       ('Airbus A320'),
       ('Airbus A330'),
       ('Airbus A340'),
       ('Airbus A350'),
       ('Airbus A360'),
       ('Airbus A370'),
       ('Airbus A380');

INSERT INTO seat(aircraft_id, seat_no)
SELECT id, seats.column1
FROM aircraft
         CROSS JOIN (VALUES ('A1'), ('A2'), ('B1'), ('B2'), ('C1'), ('C2'), ('D1'), ('D2')) seats;


INSERT INTO seat(aircraft_id, seat_no)
VALUES ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'A2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'A3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'B1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'B2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A220'), 'B3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'A2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'A3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'B1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'B2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A310'), 'B3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'A2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'A3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'B1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'B2'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A320'), 'B3'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A330'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A340'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A350'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A360'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A370'), 'A1'),
       ((SELECT id FROM aircraft WHERE model = 'Airbus A380'), 'A1');



INSERT INTO flight(flight_no, departure_date, departure_airport_code, arrival_date, arrival_airport_code, aircraft_id,
                   status)
VALUES ('MN3002', '2020-06-14T14:30', 'MNK', '2020-06-14T18:30', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A220'),
        'departed'),
       ('VN3001', '2020-08-18T14:30', 'VNK', '2020-08-18T20:30', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A220'),
        'scheduled'),
       ('PT3002', '2019-06-14T14:30', 'PTR', '2019-06-14T15:30', 'VNK',
        (SELECT id FROM aircraft WHERE model = 'Airbus A320'),
        'cancelled'),
       ('PT3005', '2018-06-14T14:30', 'PTR', '2018-06-14T19:30', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A330'),
        'arrived'),
       ('LD3009', '2021-06-14T16:30', 'LDN', '2021-06-14T22:30', 'VNK',
        (SELECT id FROM aircraft WHERE model = 'Airbus A340'),
        'scheduled'),
       ('KR3000', '2021-03-11T14:30', 'KRD', '2021-03-11T19:10', 'VTB',
        (SELECT id FROM aircraft WHERE model = 'Airbus A350'),
        'scheduled'),
       ('VT3010', '2020-06-07T12:30', 'VTB', '2020-06-07T17:10', 'KRD',
        (SELECT id FROM aircraft WHERE model = 'Airbus A360'),
        'cancelled'),
       ('VT3011', '2020-06-14T18:30', 'VTB', '2020-06-14T22:30', 'VNK',
        (SELECT id FROM aircraft WHERE model = 'Airbus A370'),
        'scheduled'),
       ('MN3005', '2020-06-14T10:30', 'MNK', '2020-06-14T14:30', 'PTR',
        (SELECT id FROM aircraft WHERE model = 'Airbus A380'),
        'arrived');


INSERT INTO flight(flight_no, departure_date, departure_airport_code, arrival_date, arrival_airport_code, aircraft_id,
                   status)
VALUES ('MN3002', '2020-06-17T14:30', 'MNK', '2020-06-17T18:40', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A220'),
        'departed'),
       ('MN3003', '2020-06-15T14:30', 'MNK', '2020-06-15T19:30', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A220'),
        'departed'),
       ('MN3004', '2020-06-16T15:30', 'MNK', '2020-06-16T19:20', 'LDN',
        (SELECT id FROM aircraft WHERE model = 'Airbus A220'),
        'departed');


INSERT INTO ticket(passenger_no, passenger_name, flight_id, seat_no, cost)
VALUES (1111, 'Петр Петров', 1, 'A1', 1000),
       (1112, 'Петр Иванов', 1, 'A2', 2000),
       (1113, 'Петр Кравченко', 1, 'B1', 3000),
       (1114, 'Петр Гончаренко', 1, 'D1', 1500),
       (1115, 'Петр Назаренко', 1, 'D2', 800),
       (1116, 'Света Петрова', 2, 'C2', 3000),
       (1117, 'Света Иванова', 2, 'D1', 2000),
       (1118, 'Света Кравченко', 2, 'D2', 700),
       (1119, 'Роман Гончаренко', 3, 'A1', 1400),
       (1120, 'Павел Назаренко', 4, 'A1', 1800),
       (1121, 'Павел Кравченко', 4, 'A2', 1900),
       (1122, 'Александр Петров', 5, 'C2', 2500),
       (1123, 'Евгений Петров', 6, 'A1', 3300),
       (1124, 'Евгений Назаренко', 6, 'D2', 1000),
       (1125, 'Ольга Петрова', 7, 'D2', 700),
       (1126, 'Иван Иванов', 8, 'A1', 1000),
       (1127, 'Иван Петров', 8, 'D2', 2000),
       (1128, 'Денис Шойгу', 9, 'B1', 2500),
       (1129, 'Дмитрий Петров', 9, 'C2', 1000);


-------------Задание 3. Кто летел позавчера рейсом Минск (MNK) - Лондон (LDN) на месте B1?---------------

SELECT passenger_name
FROM ticket
         JOIN flight f on ticket.flight_id = f.id
WHERE f.arrival_date::date = (now() - INTERVAL '2 day')::date
  AND f.departure_airport_code = 'MNK'
  AND f.arrival_airport_code = 'LDN'
  AND ticket.seat_no = 'B1';


------------Задание 4. Сколько мест осталось незанятыми 2020-06-14 на рейсе MN3002?----------------------


SELECT (SELECT count(*)
        FROM seat
        WHERE f.aircraft_id = aircraft_id) - count(*) remainder
FROM ticket
         JOIN flight f on ticket.flight_id = f.id
WHERE f.flight_no = 'MN3002'
  AND f.departure_date::date = '2020-06-14'
GROUP BY f.id;


--------------Задание 5. Какие 2 перелета были самые длительные за все время?---------------

SELECT id, departure_date, arrival_date
FROM flight
ORDER BY (arrival_date - departure_date) DESC
LIMIT 2;



--------------- Задание 6. Какая максимальная и минимальная продолжительность перелетов между--------------
---------------------Минском и Лондоном и сколько было всего таких перелетов?------------------------------

SELECT max((arrival_date - departure_date)::time),
       min((arrival_date - departure_date)::time),
       count(*)
FROM flight
WHERE departure_airport_code IN ('LDN', 'MNK')
  AND arrival_airport_code IN ('LDN', 'MNK';


----------- Задание 7. Какие имена встречаются чаще всего и какую долю от числа всех пассажиров они составляют?-------

SELECT names.name,
       max(names.count),
       max(names.count) * 1.0 / (SELECT count(*)
                                 FROM ticket) AS proportion
FROM (SELECT split_part(ticket.passenger_name, ' ', 1) AS name,
             count(*) OVER (PARTITION BY split_part(ticket.passenger_name, ' ', 1))
      FROM ticket) names
GROUP BY names.name
ORDER BY max DESC;


----------------- Задание 8. Вывести имена пассажиров, сколько всего каждый с таким именем купил билетов,--------------
-------------а также на сколько это количество меньше от того имени пассажира, кто купил билетов больше всего----------

CREATE VIEW frequency AS
SELECT names.name,
       max(names.count) amount
FROM (SELECT split_part(ticket.passenger_name, ' ', 1) AS name,
             count(*) OVER (PARTITION BY split_part(ticket.passenger_name, ' ', 1))
      FROM ticket) names
GROUP BY names.name
ORDER BY amount DESC;

SELECT name,
       amount,
       (SELECT max(amount) FROM frequency) - amount AS difference
FROM frequency
GROUP BY name, amount;



------ 9. Вывести стоимость всех маршрутов по убыванию. Отобразить разницу в стоимости----------
------------между текущим и ближайшими в отсортированном списке маршрутами----------------------


SELECT flight.departure_airport_code,
       flight.arrival_airport_code,
       t.cost,
       lag(t.cost) over (ORDER BY t.cost DESC) - t.cost AS difference
FROM flight
         JOIN ticket t on flight.id = t.flight_id
ORDER BY t.cost DESC;

