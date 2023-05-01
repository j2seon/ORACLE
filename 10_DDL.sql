--DDL 
-- ALTER : 
-- 테이블 객체 수정 : ALTER TABLE 테이블명 수정할 내용 
-- 컬럼 추가/삭제/변경, 제약 조건 추가/삭제/변경
-- 테이블명 변경, 제약조건 이름 변경

SELECT 
       DC.*
   FROM DEPT_COPY DC;
   
-- 컬럼 추가    
ALTER TABLE DEPT_COPY
   ADD (LNAME VARCHAR2(20));

-- 컬럼 삭제
ALTER TABLE DEPT_COPY
  DROP COLUMN LNAME;

-- DEFAULT로 기본값 지정 가능
--CREATE TABLE TEST(
--    TEST_NAME VARCHAR2(20) DEFAULT '테스트' 
--)

-- 컬럼 생성 시 DEFAULT 값 지정
ALTER TABLE DEPT_COPY
   ADD (CNAME VARCHAR2(20) DEFAULT '한국');

-- 컬럼에 제약조건 추가
CREATE TABLE DEPT_COPY2
AS
 SELECT D.*
  FROM DEPARTMENT D;
  
SELECT 
       DC.*
   FROM DEPT_COPY2 DC;
   
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY (컬럼명)
ALTER TABLE DEPT_COPY2
  ADD CONSTRAINT PK_DEPT_ID2 PRIMARY KEY(DEPT_ID);

ALTER TABLE DEPT_COPY2
  ADD CONSTRAINT UN_DEPT_TITLE UNIQUE(DEPT_TITLE);

ALTER TABLE DEPT_COPY2
  MODIFY LOCATION_ID CONSTRAINT NN_LID NOT NULL;

-- 컬럼 자료형 수정
ALTER TABLE DEPT_COPY2
MODIFY DEPT_ID CHAR(3)
MODIFY DEPT_TITLE VARCHAR2(30)
MODIFY LOCATION_ID VARCHAR2(2);


-- 칼럼의 크기를 줄이는 경우에는 변경하려는 크기를 초과하는 값이 없을 때만 변경할 수 있다.

-- DEFAULT 값 변경
ALTER TABLE DEPT_COPY
MODIFY CNAME DEFAULT '미국';

DELETE FROM DEPT_COPY WHERE DEPT_ID ='D0';

INSERT
   INTO DEPT_COPY
VALUES
(
  'D0'
, '생산부'
, 'L2'
, DEFAULT
);

SELECT 
       *
   FROM DEPT_COPY;
   
-- 컬럼 삭제
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_TITLE;

SELECT 
       *
   FROM DEPT_COPY2;

-- 지우려는  테이블에 최소 한 개 이상의 칼럼이 남아있어야 한다.
ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID;

CREATE TABLE TB1(
    PK NUMBER PRIMARY KEY,
    FK NUMBER REFERENCES TB1,
    COL1 NUMBER,
--    CONSTRAINT CK_PK_COL CHECK(PK > 0 AND COL1 > 0)
    CHECK(PK > 0 AND COL1 > 0)
);
DROP TABLE TB1;

-- 컬럼 삭제 시 참조하고 있는 컬럼이 있다면 삭제를 못한다.
ALTER TABLE TB1
DROP COLUMN FK;
ROLLBACK;

-- 제약 조건도 함께 삭제
SELECT 
       *
    FROM TB1;

-- 컬럼 삭제 : DROP COLUMN 삭제할 컬럼명 또는 DROP(삭제할 컬럼명)
-- 데이터가 기록되어 있어도 삭제된다.
-- 삭제된 컬럼은 복구가 불가능
-- 테이블에는 최소 한개의 컬럼이 존재해야한다. : 모든 컬럼 삭제 불가
SELECT 
       *
   FROM DEPT_COPY;
   
ALTER TABLE DEPT_COPY
  DROP(CNAME);


-- 여러개를 한번에 삭제할 수 있음.
ALTER TABLE DEPT_COPY
  DROP(DEPT_TITLE, LOCATION_ID);

--롤백해도 복구되지 않음.
ROLLBACK;

ALTER TABLE 테이블 명
  DROP CONSTRAINT 

-- 제약조건 삭제
CREATE TABLE CONST_EMP(
  ENAME VARCHAR2(20) NOT NULL,
  ENO VARCHAR2(15) NOT NULL,
  MARRIAGE CHAR(1) DEFAULT 'N',
  EID CHAR(3),
  EMAIL VARCHAR2(30),
  JID CHAR(2),
  MID CHAR(3),
  DID CHAR(2),
  CONSTRAINT CK_MARRIAGE CHECK(MARRIAGE IN ('Y', 'N')),
  CONSTRAINT PK_EID PRIMARY KEY(EID),
  CONSTRAINT UN_ENO UNIQUE(ENO),
  CONSTRAINT UN_EMAIL UNIQUE(EMAIL),
  CONSTRAINT FK_JID FOREIGN KEY(JID)
  REFERENCES JOB(JOB_CODE) ON DELETE SET NULL,
  CONSTRAINT FK_MID FOREIGN KEY(MID)
  REFERENCES CONST_EMP ON DELETE SET NULL,
  CONSTRAINT FK_DID FOREIGN KEY(DID)
  REFERENCES DEPARTMENT ON DELETE CASCADE
);

-- 제약 조건 1개 삭제 시
ALTER TABLE CONST_EMP
  DROP CONSTRAINT CK_MARRIAGE;

-- 제약 조건 여러개 삭제 시 
ALTER TABLE CONST_EMP
  DROP CONSTRAINT FK_DID
  DROP CONSTRAINT FK_JID
  DROP CONSTRAINT FK_MID;

-- NOT NULL 제약조건 삭제 시 MODIFY 사용
ALTER TABLE CONST_EMP
MODIFY (ENAME NULL, ENO NULL);

--제약조건 명 변경
ALTER TABLE CONST_EMP
RENAME CONSTRAINT PK_EID TO PKEID2;

-- 테이블 이름 변경
ALTER TABLE CONST_EMP
RENAME TO CONST_EMP_TEST;
SELECT
      * 
  FROM CONST_EMP_TEST;

-- 테이블 삭제
DROP TABLE CONST_EMP_TEST CASCADE CONSTRAINT;

ALTER TABEL 테이블명
RENAME













   
   
   
   
   
   
   