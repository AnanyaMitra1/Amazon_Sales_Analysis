

ALTER TABLE sales_data
ADD COLUMN timeofday VARCHAR(20);


UPDATE amazon
SET timeofday =
    CASE
        WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;

SET SQL_SAFE_UPDATES = 0;

----------------

ALTER TABLE amazon
ADD COLUMN dayname VARCHAR(10);

UPDATE amazon
SET dayname = DAYNAME(datetime_combined);



----

ALTER TABLE amazon
ADD COLUMN datetime_combined DATETIME;

------

UPDATE amazon
SET datetime_combined = STR_TO_DATE(CONCAT(Date, ' ', Time), '%d-%m-%Y %H:%i:%s');

UPDATE amazon
SET datetime_combined = STR_TO_DATE(CONCAT(Date, ' ', Time), '%d-%m-%Y %H:%i:%s');


UPDATE amazon
SET datetime_combined = CONCAT(Date, ' ', Time);


----

ALTER TABLE amazon
ADD COLUMN monthname VARCHAR(15);

UPDATE amazon
SET monthname = MONTHNAME(datetime_combined);




