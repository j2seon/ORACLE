-- 데이터 딕셔너리 (DATA DICTIONARY)
-- 자원을 효율적으로 관리하기 위해 다양한 정보를 저장하는 시스템 테이블
-- 사용자가 테이블을 생성하거나, 사용자를 변경하는 등의 작업을 할 때
-- 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
-- 사용자는 데이터 딕셔너리 내용을 직접 수정하거나 삭제 할 수 없다.

--원본 테이블을 커스터마이징 해서 보여주는 원본 테이블의 가상 테이블 객체(VIEW)

-- 3개의 딕셔너리 뷰로 나눠진다.
-- 1. DBA_XXX : 데이터베이스 관리자만 접근이 가능한 객체등의 정보 조회
-- 2. ALL_XXX : 자신의 계정 + 권한을 부여받은 객체의 정보조회
-- 3. USER_XXX : 자신의 계정이 소유한 객체등에 관한 정보를 조회

CREATE OR REPLACE VIEW V_EMP(
    사번, 이름, 부서
)
AS 
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
   FROM EMPLOYEE E;

-- CONNECT, RESOURCE
-- VIEW 생성 권한 부여 (시스템 계정에서)
GRANT CREATE VIEW TO C##EMPLOYEE;

--쿼리문이 들어가 있는 것을 확인할 수 있다
SELECT 
       UV.*
   FROM USER_VIEWS UV;

-- 뷰를 조회
SELECT 
       V.*
   FROM V_EMP V;
   
-- 인라인뷰로 조회 
SELECT 
       V.*
   FROM (SELECT E.EMP_ID
              , E.EMP_NAME
              , E.DEPT_CODE
           FROM EMPLOYEE E
        ) V; 
   
-- 뷰 삭제  
DROP VIEW V_EMP;

-- VIEW(뷰) 
-- SELECT 쿼리문을 저장한 객체이다.
-- 실질적인 데이터를 저장하고 있지 않다.
-- 테이블을 사용하는 것과 동일하게 사용할 수 있다.
-- [표현식]
-- CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리

-- 사번, 이름, 직급명, 부서명, 근무지역을 조회하고
-- 그 결과를 V_RESULT_EMP라는 뷰를 생성해서 저장하세요.

CREATE VIEW V_RESULT_EMP
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
   FROM EMPLOYEE E
   LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
   LEFT JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);


SELECT 
       V.* 
   FROM V_RESULT_EMP V
  WHERE V.EMP_ID = '205';

-- 베이스 테이블의 정보가 변경되면 VIEW도 같이 변경된다.

UPDATE
       EMPLOYEE E
   SET E.EMP_NAME = '정중앙'
  WHERE E.EMP_ID = '205';

SELECT 
      E.*
   FROM EMPLOYEE E
  WHERE E.EMP_ID = '205';
  
ROLLBACK;
DROP VIEW V_RESULT_EMP;

-- 뷰의 컬럼에 별칭을 부여할 수 있다.
CREATE OR REPLACE VIEW V_EMPLOYEE(
    사번, 이름, 부서, 지역
)
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
   FROM EMPLOYEE E -- 베이스 테이블
   LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
   LEFT JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

SELECT 
      V.사번
   FROM V_EMPLOYEE V;

-- 뷰 서브쿼리 안에 연산의 결과도 포함할 수 있다.
CREATE OR REPLACE VIEW V_EMP_JOB(
    사번, 이름, 직급, 성별, 근무년수
)
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , DECODE(SUBSTR(E.EMP_NO,8,1), 1, '남', '여')
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM E.HIRE_DATE)
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);
   
SELECT 
       V.*
  FROM V_EMP_JOB V;

CREATE OR REPLACE VIEW V_JOB
AS
SELECT J.JOB_CODE
     , J.JOB_NAME 
   FROM JOB J;

SELECT 
       V.*
   FROM V_JOB V;

-- 원본데이터에 접근해서 데이터를 조작할 수 있다.
INSERT 
    INTO V_JOB(JOB_CODE, JOB_NAME)
VALUES(
    'J8', '인턴'
);

SELECT 
       *
   FROM JOB ;

UPDATE 
       V_JOB V
   SET V.JOB_NAME= '알바'
   WHERE V.JOB_CODE = 'J8';
   
SELECT 
       *
   FROM V_JOB ;

DELETE
   FROM  V_JOB V
   WHERE V.JOB_CODE = 'J8';

-- DML 명령어로 조작이 불가능한 경우 
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
-- 2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 3. 산술표현식으로 정의된 경우
-- 4. JOIN을 이용해 여러테이블을 연결한 경우
-- 5. DISTINCT를 포함한 경우
-- 6. 그룹함수나 GROUP BY 절을 포함한 경우

-- 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS
SELECT 
J.JOB_CODE
  FROM JOB J;

INSERT 
    INTO V_JOB2(JOB_CODE, JOB_NAME)
VALUES(
    'J8', '인턴'
); -- 에러발생

INSERT 
    INTO V_JOB2(JOB_CODE)
VALUES(
    'J8'
); -- 원본테이블의 JOB_NAME 컬럼에 NOT NULL 제약조건이 추가되어 있지 않아서 NULL 값으로 추가된다

ROLLBACK;

UPDATE  
       V_JOB2 V
   SET V_JOB_NAME = '인턴'
  WHERE V.JOB_CODE = 'J7'; -- 에러발생 V_JOB2에 V_JOB_NAME가 없어서
  
-- DELETE 
DELETE 
  FROM V_JOB2 V
 WHERE V.JOB_CODE = 'J8';


CREATE OR REPLACE VIEW V_JOB3
AS
SELECT J.JOB_NAME 
  FROM JOB J;

INSERT 
    INTO V_JOB3(JOB_CODE, JOB_NAME)
VALUES(
    'J8', '인턴'
); -- JOB_CODE가 없어서 에러발생

INSERT 
    INTO V_JOB3(JOB_NAME)
VALUES(
    '인턴'
); --JOB 테이블의 JOB_CODE에 NOT NULL 제약조건이 추가되어 있어서 에러발생 

UPDATE 
       V_JOB3
   SET JOB_NAME = '인턴'
  WHERE JOB_NAME = '사원';
SELECT * FROM JOB;

ROLLBACK;

-- 산술 표현식으로 정의된 경우 
CREATE OR REPLACE VIEW EMP_SAL
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.SALARY
     , TRUNC((E.SALARY + (E.SALARY + NVL(E.BONUS, 0))) * 12) 연봉
  FROM EMPLOYEE E;

INSERT 
    INTO EMP_SAL(EMP_ID, EMP_NAME, SALARY, 연봉) -- 가상 열은 사용할 수 없습니다 에러발생
VALUES(
    '800', '정진훈', 3000000 ,400000000
);  

UPDATE 
       EMP_SAL ES
   SET ES.연봉 = 80000000 -- 가상 열은 사용할 수 없습니다 에러남
 WHERE ES.EMP_ID = '200';

-- DELETE할 때는 사용 가능
DELETE 
   FROM EMP_SAL ES
  WHERE ES.연봉 = 124800002;

SELECT * FROM EMP_SAL;

ROLLBACK;

-- JOIN을 이용해 여러 테이블을 연결한 경우 
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
   FROM EMPLOYEE E 
   LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);
   
SELECT 
       V.*
   FROM V_JOINEMP V;
   
INSERT
  INTO V_JOINEMP(EMP_ID, EMP_NAME, DEPT_TITLE) -- 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.
VALUES(
      888,'조세오','인사관리부'
);

-- 조인이 된 내용이기 때문에 원본의 내용을 수정할 수 없음.
UPDATE 
      V_JOINEMP V
   SET V.DEPT_TITLE = '인사관리부' -- 키-보존된것이 아닌 테이블로 대응한 열을 수정할 수 없습니다 에러
  WHERE V.EMP_ID = '219';  
  
SELECT 
       V.*
   FROM V_JOINEMP V
  WHERE V.EMP_ID = '219'; 

-- 베이스 테이블에만 영향을 끼친다. -> 연결되어있는 테이블에 영향 X
DELETE 
  FROM V_JOINEMP V
 WHERE V.EMP_ID = '219';

--조회해보면 EMPLOYEE에는 삭제된것을 확인
SELECT 
       E.*
   FROM EMPLOYEE E
  WHERE E.EMP_ID = '219'; 

-- DEPARTMENT에는 영향이 가지 않은 것을 확인
SELECT 
       D.*
   FROM DEPARTMENT D;
   
ROLLBACK;

-- DISTINCT를 포함한경우 
CREATE OR REPLACE VIEW V_DP_EMP
AS
SELECT DISTINCT E.JOB_CODE
   FROM EMPLOYEE E;

SELECT * FROM V_DP_EMP;

INSERT 
  INTO V_DP_EMP(JOB_CODE) -- 뷰에 대한 데이터 조작이 부적합합니다 에러
VALUES ('J9');            -- DISTINCT일 경우 X

UPDATE 
       V_DP_EMP V
   SET V.JOB_CODE = 'J9'
  WHERE V.JOB_CODE = 'J7'; -- 에러발생

DELETE 
   FROM V_DP_EMP V
  WHERE V.JOB_CODE = 'J7';  -- 에러발생 
  
-- 그룹함수나 GROUP BY 절을 포함한 경우
CREATE OR REPLACE VIEW V_GROUPDEPT
AS
SELECT E.DEPT_CODE
     , SUM(E.SALARY) 합계
     , AVG(E.SALARY) 평균
  FROM EMPLOYEE E
 GROUP BY E.DEPT_CODE;

SELECT 
       V.*
  FROM V_GROUPDEPT V;
  
INSERT 
   INTO V_GROUPDEPT
   (DEPT_CODE, 합계, 평균) --가상 열은 사용할 수 없습니다 
VALUES 
('DD', 6000000, 400000);
 
UPDATE 
        V_GROUPDEPT V
    SET V.DEPT_CODE = 'D9' --뷰에 대한 데이터 조작이 부적합합니다
  WHERE V.DEPT_CODE = 'D1';

DELETE
   FROM V_GROUPDEPT V
  WHERE V.DEPT_CODE = 'D9';


-- VIEW 옵션
-- OR REPLACE : 기존에 동일한 뷰 이름이 존재하는 경우 덮어 쓰고 
--              존재하지 않으면 새로 생성하는 옵션
-- FORCE 옵션 : 서브쿼리에 사용된 테이블이 존재 하지 않아도 뷰를 생성

CREATE FORCE VIEW V_EMP
AS 
SELECT TCODE
     , TNAME
     , TCONTENTS
  FROM TT; -- TT라는 테이블이 없지만 생성된다

SELECT * FROM V_EMP ; 

-- TT 테이블 추가
--CREATE TABLE TT(
--    TCODE NUMBER PRIMARY KEY
--  , TNAME VARCHAR2(30) NOT NULL
--  , TCONTENTS VARCHAR2(1000)
--);
--DROP TABLE TT;

CREATE FORCE VIEW V_EMP
AS 
SELECT TCODE
     , TNAME
     , TTEST
     , TCONTENTS
  FROM TT; -- 기존의 객체가 이름을 사용하고 있습니다

CREATE OR REPLACE FORCE VIEW V_EMP --컴파일 오류와 함께 뷰가 생성되었습니다.
AS 
SELECT TCODE
     , TNAME
     , TTEST
     , TCONTENTS
  FROM TT;

-- NOFORCE 옵션 : 서브쿼리에 테이블이 존재해야만 뷰 생성한다. (기본값)
CREATE OR REPLACE NOFORCE VIEW V_EMP2 -- 테이블 또는 뷰가 존재하지 않습니다 에러
AS 
SELECT TCODE
     , TNAME
     , TTEST
     , TCONTENTS
  FROM TT;
  
-- WITH CHECK 옵션 : 컬럼의 값을 수정하지 못하게한다.
-- WITH CHECK OPTION : 조건절에 사용된 컬럼의 값을 수정하지 못하게 한다.

CREATE OR REPLACE VIEW V_EMP3
AS
SELECT E.*
   FROM EMPLOYEE E
  WHERE E.MANAGER_ID = '200'
   WITH CHECK OPTION;

SELECT 
       V.*
   FROM V_EMP3 V;
   
UPDATE  --뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
      V_EMP3
   SET MANAGER_ID = '900'
 WHERE MANAGER_ID = '200';

-- WITH READ ONLY : DML 수행이 불가능 (읽기만)
CREATE OR REPLACE VIEW V_DEPT
AS
SELECT * 
   FROM DEPARTMENT
   WITH READ ONLY;

DELETE FROM V_DEPT; --읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
