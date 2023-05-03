-- DML(Data Manupulation Language)
-- INSERT, UPDATE, DELETE
-- 데이터 조작언어이며, 테이블에 값을 삽입하거나 수정하거나 삭제하는 언어

/* INSERT : 새로운 행을 추가하는 구문이다.
            테이블의 행 수가 증가한다. 
  [표현식]
   테이블의 일부 컬럼에 INSERT할 때 
   INSERT INFO 테이블명(컬럼명,컬럼명,....) VALUES(데이터, 데이터...);
   EX) INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME) VALUES(200,'선동일');
   
   테이블의 모든 컬럼에 INSERT 할 때 
   INSERT INTO 테이블명 VALUES(데이터, 데이터....)
   모든 컬럼에 INSERT 할때도 컬럼명을 기술하는 것이 의미 파악에 더 좋다
*/

INSERT
    INTO EMPLOYEE E
(
    EMP_ID, EMP_NAME, EMP_NO, EMAIL ,PHONE, DEPT_CODE,
    JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN
)
VALUES
(
 '201', '송중기', '991111-1080502', 'jang_ch@greedy.com', '01022222222',
 'D1', 'J1', 'S3', 5200000, 0.2, '200', SYSDATE, NULL, DEFAULT
);

SELECT 
       E.*
   FROM EMPLOYEE E
  WHERE E.EMP_NAME = '장채현';
COMMIT;

--INSERT 시에 VALUES 대신 서브쿼리를 이용할 수 있다.
CREATE TABLE EMP_01(
   EMP_ID NUMBER,
   EMP_NAME VARCHAR2(30),
   DEPT_TITLE VARCHAR2(20)
);

SELECT 
       E.*
   FROM EMP_01 E;

INSERT 
   INTO EMP_01
(
   EMP_ID
 , EMP_NAME
 , DEPT_TITLE
)
(
  SELECT E.EMP_ID
       , E.EMP_NAME
       , D.DEPT_TITLE
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
);

ROLLBACK;

SELECT 
      E.*
  FROM EMP_01 E;
  
-- INSERT ALL : INSERT시에 사용하는 서브쿼리가 같은 경우
--              두개 이상의 테이블에 INSERT ALL을 이용하여
--              한 번에 데이터를 삽입할 수 있다.
--              단, 각 서브쿼리의 조건절이 같아야 한다.

CREATE TABLE EMP_DEPT_D1
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.HIRE_DATE
   FROM EMPLOYEE E
  WHERE 1 = 0; 

CREATE TABLE EMP_MANAGER
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
   FROM EMPLOYEE E
  WHERE 1 = 0;
  
-- EMP_DEPT_D1 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인 직원을 조회해서 사번,이름, 소속부서, 입사일을 삽입하고
-- EMP_MANAGER 테이블에 EMPLOYEE테이블에 있는 부서코드가 D1인 직원을 조회해서 사번,이름,관리자사번을 조회해서 삽입하세요

INSERT 
    INTO EMP_DEPT_D1 A
(
    SELECT E.EMP_ID
         , E.EMP_NAME
         , E.DEPT_CODE
         , E.HIRE_DATE
       FROM EMPLOYEE E
      WHERE E.DEPT_CODE = 'D1'
);

INSERT 
    INTO EMP_MANAGER A
(
    A.EMP_ID
  , A.EMP_NAME
  , A.MANAGER_ID
)
(
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
   FROM EMPLOYEE E 
  WHERE E.DEPT_CODE = 'D1'
);

DELETE
    FROM EMP_DEPT_D1;
    
DELETE
    FROM EMP_MANAGER;

-- INSERT ALL INTO 테이블명 VALUES(컬럼명)
--            INTO 테이블명 VALUES(컬럼명)
--  서브쿼리 ;

INSERT ALL
   INTO EMP_DEPT_D1
VALUES(
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , HIRE_DATE
)
   INTO EMP_MANAGER
VALUES(
   EMP_ID
 , EMP_NAME
 , MANAGER_ID
)
SELECT E.EMP_ID
     , E.DEPT_CODE
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.MANAGER_ID
   FROM EMPLOYEE E
  WHERE E.DEPT_CODE = 'D1';

-- EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의
-- 사번, 이름, 입사일, 급여를 조회하여
-- EMP_OLD 테이블에 삽입하고, 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하세요

CREATE TABLE EMP_OLD
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY 
   FROM EMPLOYEE E
  WHERE 1 = 0;

CREATE TABLE EMP_NEW
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY 
   FROM EMPLOYEE E
  WHERE 1 = 0;

-- WHEN THEN 
-- INSERT ALL/FIRST
--   WHEN 조건 THEN
--    INTO 테이블명 VALUES(컬럼명)
--   ELSE
--    INTO 테이블명 VLAUES(컬럼명)

INSERT ALL 
   WHEN HIRE_DATE < '2000/01/01' THEN
     INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
   WHEN HIRE_DATE >= '2000/01/01' THEN
     INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
   FROM EMPLOYEE E;
COMMIT;


CREATE TABLE EMP_OLD2
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY 
   FROM EMPLOYEE E
  WHERE 1 = 0;
CREATE TABLE EMP_NEW2
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY 
   FROM EMPLOYEE E
  WHERE 1 = 0;
  
CREATE TABLE EMP_NEW3
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY 
   FROM EMPLOYEE E
  WHERE 1 = 0;
  
INSERT ALL 
    WHEN HIRE_DATE < '2000/01/01' THEN
      INTO EMP_OLD2
    WHEN HIRE_DATE > '2000/01/01' THEN
      INTO EMP_NEW2
    ELSE 
      INTO EMP_NEW3
SELECT EMP_ID
     , EMP_NAME
     , HIRE_DATE
     , SALARY
   FROM EMPLOYEE;


--UPDATE : 테이블에 기록된 컬럼의 값을 수정하는 구문
--         테이블의 전체 행 갯수는 변화가 없다.
-- [표현식]
-- UPDATE 테이블명 SET 컬럼명 = 바꿀값, 컬럼명 = 바꿀 값,....
-- [WHERE 컬럼명 비교연산자 비교값];
CREATE TABLE DEPT_COPY
AS 
SELECT *
  FROM DEPARTMENT;

SELECT 
      DC.*
  FROM DEPT_COPY DC;
  
UPDATE 
       DEPT_COPY 
   SET DEPT_TITLE = '전략기획팀'
 WHERE DEPT_ID = 'D9';
  
-- UPDATE 시에도 서브쿼리를 이용할 수 있다.
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)
CREATE TABLE EMP_SALARY
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.SALARY
     , E.BONUS
  FROM EMPLOYEE E;

SELECT 
       ES.*
   FROM EMP_SALARY ES
  WHERE ES.EMP_NAME IN('유재식', '방명수');
DROP TABLE EMP_SALARY;
-- 평상 시 유재식 사원을 부러워하던 방명수 사원의 급여와 보너스율을 유재식사원과 동일하게 변경해주기로 함
-- 이를 반영하는 UPDATE문을 작성하세요
UPDATE 
       EMP_SALARY ES
   SET ES.SALARY =(SELECT E1.SALARY
                     FROM EMPLOYEE E1
                     WHERE E1.EMP_NAME = '유재식'
                   )
     , ES.BONUS = (SELECT E1.BONUS
                     FROM EMPLOYEE E1
                     WHERE E1.EMP_NAME = '유재식'
                   )
   WHERE ES.EMP_NAME = '방명수';                   

-- 다중열 서브쿼리를 이용한 UPDATE 문
-- 방명수 사원의 급여 인상 소식을 전해들은 다른 직원들이 단체로 파업
-- 노옹철, 전형돈, 정중하 하동운 사원의 급여와 보너스를 유재식 사원의 급여와 보너스를 같게 변경하는 UPDATE문
UPDATE 
      EMP_SALARY ES
  SET (ES.SALARY, ES.BONUS) = (SELECT E1.SALARY, E1.BONUS
                                 FROM EMPLOYEE E1
                                WHERE E1.EMP_NAME= '유재식'
                                )
  WHERE ES.EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

-- 다중행 서브쿼리를 이용한 UPDATE 
-- EMP_SALARY 테이블에서 아시아 근무지역에 근무하는 직원의 보너스를 0.5로 변경하세요
UPDATE 
       EMP_SALARY ES
   SET ES.BONUS = 0.5
  WHERE ES.EMP_ID IN(SELECT E1.EMP_ID
                       FROM EMPLOYEE E1
                       JOIN DEPARTMENT D1 ON(E1.DEPT_CODE = D1. DEPT_ID)
                       JOIN LOCATION L1 ON(D1.LOCATION_ID = L1.LOCAL_CODE)
                      WHERE L1.LOCAL_NAME LIKE 'AISA%' 
                    );
-- UPDATE 시 변경할 값을 해당 컬럼에 대해 제약조건에 위배되지 않아야한다.
UPDATE 
        EMPLOYEE E
   SET E.DEPT_CODE = '6'
 WHERE E.DEPT_CODE = 'D6'; -- FOREIGN KEY 제약조건 위배

UPDATE 
       EMPLOYEE E
   SET E.EMP_NAME = NULL
 WHERE E.EMP_ID = '200';
 
--DELETE : 테이블의 행을 삭제하는 구문이다.
--         테이블의 행의 갯수가 줄어든다
-- [표현식]
-- DELETE FROM 테이블명 [WHERE 조건 설정]
-- 만약 WHERE 조건을 설정하지 않으면 모든 행 삭제

COMMIT;

SELECT
       E.*
   FROM EMPLOYEE E;
SELECT
       *
   FROM DEPARTMENT;
   
DELETE
  FROM EMPLOYEE;
 
ROLLBACK;

-- FOREIGN KEY 제약조건이 설정되어 있는 경우
-- 참조되고 있는 값에 대해서는 삭제할 수 없다.

DELETE 
   FROM DEPARTMENT D
  WHERE  D.DEPT_ID = 'D1';

-- FOREIGN KEY 제약조건이 설정되어 있어도
-- 참조되고 있지 않은 값에 대해서는 삭제할 수 있다.

DELETE 
   FROM DEPARTMENT D
  WHERE  D.DEPT_ID = 'D3';

ROLLBACK;

 -- 삭제 시 FOREIGN KEY 제약조건으로 칼럼삭제가 불가능한 경우
 -- 제약 조건을 비활성화 할 수 있다.
ALTER TABLE EMPLOYEE DISABLE CONSTRAINT SYS_C007551 CASCADE;
 
DELETE 
   FROM DEPARTMENT D
  WHERE  D.DEPT_ID = 'D1';
 
SELECT 
       *
   FROM EMPLOYEE ;
SELECT 
       *
   FROM DEPARTMENT ;
   
ROLLBACK;
 
-- 비활성화 된 제약조건을 다시 활성화
ALTER TABLE EMPLOYEE ENABLE CONSTRAINT SYS_C007551;

-- TRUNCATE : 테이블의 전체 행을 삭제할 시 사용한다.
--            DELETE보다 수행속도가 빠르다.
--            ROLLBACK을 통해 복구할 수 없다.
SELECT 
       ES.*
   FROM EMP_SALARY ES;
   
COMMIT;

DELETE 
   FROM EMP_SALARY;

ROLLBACK;
 
TRUNCATE TABLE EMP_SALARY; 
 
-- MERGE : 구조가 같은 두개의 테이블을 하나로 합치는 기능을 한다.
--         테이블에서 지정하는 조건의 값이 존재하면 UPDATE 
--         조건의 값이 없으면 INSERT 한다.
CREATE TABLE EMP_M01
AS 
SELECT E.*
   FROM EMPLOYEE E;
DROP TABLE EMP_M01;
CREATE TABLE EMP_M02
AS
SELECT E.*
   FROM EMPLOYEE E
  WHERE E.JOB_CODE ='J4';
 
INSERT
    INTO EMP_M02 
(
    EMP_ID, EMP_NAME, EMP_NO, EMAIL ,PHONE, DEPT_CODE,
    JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN
)
VALUES
(
 '900', '장채현', '901123-1080502', 'jang_ch@greedy.com', '01022222222',
 'D1', 'J1', 'S3', 9900000, 0.2, NULL, SYSDATE, NULL, DEFAULT
);

SELECT 
       EM.*
   FROM EMP_M01 EM;


SELECT 
       EM.*
   FROM EMP_M02 EM;
   
UPDATE 
       EMP_M02 EM
   SET EM.SALARY = 0;

-- MERGE INTO 적용하려는 테이블명|뷰
-- USING 테이블|서브쿼리|뷰
--    ON (컬럼 = 컬럼)
--  WHEN MATCHED THEN 일치하는 경우 -> UPDATE나 DELETE 수행
--       UPDATE SET 
--       (DELETE)
--  WHEN NOT MATCHED THEN 불일치하는 경우 -> INSERT 수행
--       INSERT (컬럼) VALUES(컬럼) 

MERGE INTO EMP_M01 
USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
    EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
    EMP_M01.EMP_NO = EMP_M02.EMP_NO,
    EMP_M01.EMAIL = EMP_M02.EMAIL,
    EMP_M01.PHONE = EMP_M02.PHONE,
    EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
    EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
    EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
    EMP_M01.SALARY = EMP_M02.SALARY,
    EMP_M01.BONUS = EMP_M02.BONUS,
    EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
    EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
    EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
    EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO,
    EMP_M02.EMAIL, EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE,
    EMP_M02.SAL_LEVEL, EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID,
    EMP_M02.HIRE_DATE, EMP_M02.ENT_DATE, EMP_M02.ENT_YN);
    
SELECT 
       EM.*
   FROM EMP_M01 EM;



















