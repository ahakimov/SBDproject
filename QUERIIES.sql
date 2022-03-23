--------------------QUERY 1
--SUBQUERY
SELECT IDPERSON
    ,FIRSTNAME
    ,LASTNAME
FROM PERSON
WHERE IDPERSON IN ( SELECT IDPERSON
                    FROM RENTAL
                    GROUP BY IDPERSON
                    HAVING COUNT(IDBIKE)=1);
                    
--------------------QUERY 2
-- USING EXISTS
-- QUERY WHICH GIVES ADDRESS INFO ABOUT REPORTERS 
SELECT * FROM ADDRESSES
    WHERE EXISTS (SELECT * FROM PERSON 
        WHERE ADDRESSES.IDADDRESS = PERSON.IDADDRESS AND EXISTS(
                                                            SELECT * FROM REPORT
                                                            WHERE PERSON.IDPERSON = REPORT.IDPERSON))
        ORDER BY ADDRESSES.IDADDRESS;







--------------------QUERY 3
-- INNER JOIN
-- QUERY GIVES US ADDRESS INFO ABOUT RENTERS
SELECT  r.IDRENTAL,  p.FIRSTNAME, p.LASTNAME
        ,(a.COUNTRY ||', '|| a.CITY ||', '|| a.STREET ||', '|| a.APARTMENT) AS UserFullAddress 
       
        FROM (( RENTAL r INNER JOIN Person p ON
        r.IDPERSON = p.IDPERSON)
        INNER JOIN ADDRESSES a ON p.IDADDRESS = a.IDADDRESS);


--------------------QUERY 4        
-- RIGHT JOIN
-- this query gives info about persons who rented and names starts with letter A
SELECT BIKE.IDBIKE
    ,BIKE.CODE
    ,RENTAL.RENTDATE
    ,('rental.beginn' ||', '|| RENTAL.TAKENTIME) AS startStatTime
    ,(RENTAL.DESTINATION||', '|| RENTAL.RETURNEDTIME) AS finishStatTime
    ,PERSON.IDPERSON , PERSON.FIRSTNAME, PERSON.LASTNAME
    FROM (BIKE
    RIGHT JOIN RENTAL ON
    BIKE.IDBIKE = RENTAL.IDBIKE 
        RIGHT JOIN PERSON ON
        RENTAL.IDPERSON = PERSON.IDPERSON
       )
        WHERE PERSON.FIRSTNAME LIKE 'A%'
        ORDER BY BIKE.IDBIKE asc;
        
 --------------------QUERY 5
 -- ANY / ALL
SELECT COUNTRY
       ,CITY
       ,STREET
FROM ADDRESSES
WHERE CITY != ALL
    ( SELECT CITY 
    FROM ADDRESSES
    WHERE CITY = 'WARSAW')
    ORDER BY STREET ;
        
----------------------TRIGGER
--Adds update data into table Address LOG after inserting new Address into Addresses table 
CREATE OR REPLACE TRIGGER ADDRESSES_T1 
AFTER INSERT ON ADDRESSES 
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW
BEGIN
  INSERT INTO ADDRESSES_LOG 
  (LOG_ID,
  INSERT_DATE)
  VALUES
  (:NEW.IDADDRESS,
  :NEW.CREATION_DATE);
  
END;
--TRIGGER TEST
INSERT INTO ADDRESSES (IDADDRESS, COUNTRY, CITY, STREET, ZIP, APARTMENT, CREATION_DATE)
VALUES ('0021', 'POLAND', 'GDANSK', 'MAIN STREET', '00-888', '50', SYSDATE);

INSERT INTO ADDRESSES (IDADDRESS, COUNTRY, CITY, STREET, ZIP, APARTMENT, CREATION_DATE)
VALUES ('0022', 'POLAND', 'GDANSK', 'BEACH SIDE', '00-082', '17', SYSDATE);

INSERT INTO ADDRESSES (IDADDRESS, COUNTRY, CITY, STREET, ZIP, APARTMENT, CREATION_DATE)
VALUES ('0023', 'POLAND', 'GDANSK', 'CENTER', '00-022', '17', SYSDATE);



-------------PROCEDURE 1
CREATE OR REPLACE PROCEDURE insertPersonProcedure
(firstName IN VARCHAR2, lastName IN VARCHAR2) AS
BEGIN
   INSERT INTO Person(idPerson, idAddress, firstName, lastName, peselNumber) VALUES('10021', '0022', 'ANTONI', 'BARBARA', '9401452078');
END insertPersonProcedure;


-------------PROCEDURE 2

EXEC DFDF;
CREATE OR REPLACE PROCEDURE DFDF
IS
    cityy varchar(60),
    out_of_range exception;
    pragma exception_init(out_of_range, -20001);
            begin
            select city,country
            where city = cityy
            from adresses;
            if city != 'Lviv' then
            
            RAISE_APPLICATION_ERROR(-20001 , 'There are not shuch a city in database');
            end if;
            exception
            when out_of_range then
            dbms_output.put_line(sqlerrm);
            end;

