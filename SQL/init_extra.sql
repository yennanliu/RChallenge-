/*
SQL init extra sample data (postgreSQL)
*/

drop table if exists exchange_rates;
create table exchange_rates(
ts timestamp without time zone,
from_currency varchar(3),
to_currency varchar(3),
rate numeric
);

truncate table exchange_rates;
insert into exchange_rates
values
('2018-04-01 00:00:00', 'USD', 'GBP', '0.71'),
('2018-04-01 00:00:05', 'USD', 'GBP', '0.82'),
('2018-04-01 00:01:00', 'USD', 'GBP', '0.92'),
('2018-04-01 01:02:00', 'USD', 'GBP', '0.62'),

('2018-04-01 02:00:00', 'USD', 'GBP', '0.71'),
('2018-04-01 03:00:05', 'USD', 'GBP', '0.82'),
('2018-04-01 04:01:00', 'USD', 'GBP', '0.92'),
('2018-04-01 04:22:00', 'USD', 'GBP', '0.62'),

('2018-04-01 00:00:00', 'EUR', 'GBP', '1.71'),
('2018-04-01 01:00:05', 'EUR', 'GBP', '1.82'),
('2018-04-01 01:01:00', 'EUR', 'GBP', '1.92'),
('2018-04-01 01:02:00', 'EUR', 'GBP', '1.62'),

('2018-04-01 02:00:00', 'EUR', 'GBP', '1.71'),
('2018-04-01 03:00:05', 'EUR', 'GBP', '1.82'),
('2018-04-01 04:01:00', 'EUR', 'GBP', '1.92'),
('2018-04-01 05:22:00', 'EUR', 'GBP', '1.62'),

('2018-04-01 05:22:00', 'EUR', 'HUF', '0.062')
;

-- For volumes of data close to real, run this:
insert into exchange_rates (
select ts, from_currency, to_currency, rate from (
select date_trunc('second', dd + (random() * 60) * '1 second':: interval) as ts, case when random()*2 < 1 then 'EUR' else 'USD' end as from_currency,
'GBP' as to_currency, (200 * random():: int )/100 as rate
FROM generate_series
        ( '2018-04-01'::timestamp 
        , '2018-04-02'::timestamp
        , '1 minute'::interval) dd
     ) a 
where ts not in (select ts from exchange_rates)
order by ts
)
;

-- Transactions

drop table if exists transactions;
create table transactions (
ts timestamp without time zone,
user_id int,
currency varchar(3),
amount numeric
);

truncate table transactions;
insert into transactions
values
('2018-04-01 00:00:00', 1, 'EUR', 2.45),
('2018-04-01 01:00:00', 1, 'EUR', 8.45),
('2018-04-01 01:30:00', 1, 'USD', 3.5),
('2018-04-01 20:00:00', 1, 'EUR', 2.45),

('2018-04-01 00:30:00', 2, 'USD', 2.45),
('2018-04-01 01:20:00', 2, 'USD', 0.45),
('2018-04-01 01:40:00', 2, 'USD', 33.5),
('2018-04-01 18:00:00', 2, 'EUR', 12.45),

('2018-04-01 18:01:00', 3, 'GBP', 2),

('2018-04-01 00:01:00', 4, 'USD', 2),
('2018-04-01 00:01:00', 4, 'GBP', 2)
;

-- For volumes of data close to real, run this:
insert into transactions (
SELECT dd + (random()*5) * '1 second'::interval as ts, (random() * 1000)::int as user_id,
case when random()*2 < 1 then 'EUR' else 'USD' end as currency,
(random() * 10000) :: int / 100 as amount
FROM generate_series
        ( '2018-04-01'::timestamp 
        , '2018-04-02'::timestamp
        , '1 second'::interval) dd
)        ;
