-- 인덱스(INDEX)
-- SQL 명령문의 검색 처리 속도를 향상시키기 위해
-- 컬럼에 대해서 생성하는 오라클 객체이다.

-- 하드디스크의 어느 위치인지에 대한 정보를 가진 주소록
-- DATA - ROWID로 구성되어있다. 

-- 인덱스를 관리 
SELECT 
      *
   FROM USER_IND_COLUMNS;
   
-- ROWID : 오브젝트 번호, 상대파일 번호, 블록 번호, 데이터 번호
SELECT 
       ROWID
     , E.EMP_ID
     , E.EMP_NAME
   FROM EMPLOYEE E
   WHERE E.EMP_ID = '200';
   
-- 인덱스 종류
-- 1. 고유인덱스(UNIQUE INDEX)
-- 2. 비고유인덱스(NONUNIQUE INDEX)
-- 3. 단일 인덱스(SIGLE INDEX)
-- 4. 결합인덱스(COMPOSITE INDEX)
-- 5. 함수기반 인덱스(FUNCTION BASED INDEX)

-- UNIQUE INDEX
-- UNIQUE INDEX로 생성된 컬럼에는 중복값이 포함될 수 없다.
-- 오라클 PRIMARY KEY 제약조건을 생성하면 자동으로 해당 컬럼에 UNIQUE INDEX가 생성된다.
-- PRIMARY KEY를 이용하여 ACCESS하는 경우에 성능향상의 효과가 있다.

SELECT 
       E.*
   FROM EMPLOYEE E;

-- UNIQUE INDEX 활용 
SELECT 
       E.*
   FROM EMPLOYEE E
  WHERE E.EMP_ID > '0';
  
CREATE UNIQUE INDEX IDX_EMPNO
ON EMPLOYEE(EMP_NO);  -- UNIQUE 제약조건에 의해서 이미 인덱스가 존재해서 중복해서 생성되지 않는다.

SELECT 
       *
   FROM USER_IND_COLUMNS;

-- PRIMARY KEY나 UNIQUE에 있는 인덱스들은 DROP을 할 수도 없다.
DROP INDEX SYS_C007499;

-- 중복값이 있는 컬럼은 UNIQUE 인덱스를 생성하지 못한다. 
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);

SELECT
      *
   FROM EMPLOYEE 
  WHERE DEPT_CODE= 'D9';

-- NONUNIQUE INDEX
-- WHERE절에서 빈번하게 사용되는 일별 컬럼을 대상으로 생성
-- 주로 성능향상을 위한 목적으로 생성한다.
CREATE INDEX IDX_DEPTCODE
ON EMPLOYEE (DEPT_CODE);

SELECT
      *
   FROM EMPLOYEE 
  WHERE DEPT_CODE= 'D9';
  
-- 결합인덱스(COMPOSITE INDEX)
-- 결합 인덱스 시에는 카디널리티(집합의 유니크(UNIQUE)한 값의 갯수)가 높고,
-- 중복값이 낮은 값이 먼저 오는 것이 검색속도를 향상시킨다.
-- 따라서 결합 인덱스를 작성 시 카디널리티가 높은 것을 먼저적는 것이 좋다.

CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID,DEPT_TITLE);

DROP INDEX IDX_DEPT;
/* 인덱스 힌트
   일반적으로는 옵티마이저가 적절한 인덱스를 타거나 풀스캐닝을 해서 비용을 적게드는 효율적인 방식으로 검색을한다.
   하지만 우리는 원하는 테이블에 있는 인덱스를 사용할 수 있도록 해주는 구문(힌드)를 통해 선택가능하다.
*/   
-- SELECT 절 첫줄에 힌트 주석(/*+ 내용 */)을 작성하여 적절한 인덱스를 부여할 수 있다.
-- 주석에 '+'를 반드시 붙이고 /*+ 다음에 스페이스를 반드시줘야한다.
 

SELECT /*+ INDEX_DESC(DEPARTMENT IDX_DEPT) */
      D.DEPT_ID
   FROM DEPARTMENT D
  WHERE D.DEPT_TITLE > '0'
    AND D.DEPT_ID > '0';

-- 함수기반 인덱스
-- SELECT 절이나 WHERE 절에서 산술계산실이나 함수가 사용된 경우
-- 계산에 포함된 컬럼은 인덱스의 적용을 받지 않는다.
-- 계산식으로 검색하는 경우가 많다면 수식아나 함수식으로 이루어진 컬럼을 인덱스로 만들 수도 있다.
CREATE TABLE EMP02
AS
SELECT
      * 
  FROM EMPLOYEE;

SELECT 
       *
  FROM EMP02 E;
  
CREATE INDEX IDX_EMP02_SALCALC
ON EMP02 ((SALARY + (SALARY * NVL(BONUS,0))) * 12);
  
SELECT /*+ INDEX_DESC(EMP02 IDX_EMP02_SALCALC */
      E.EMP_ID
    , E.EMP_NAME
    ,((E.SALARY + (E.SALARY * NVL(E.BONUS,0))) * 12) 연봉
  FROM EMP02 E
 WHERE ((E.SALARY + (E.SALARY * NVL(E.BONUS,0))) * 12)> 100000000;



