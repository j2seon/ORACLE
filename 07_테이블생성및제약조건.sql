-- DDL(CREATE TABLE) 및 제약조건

-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의어 

-- 테이블 만들기
-- [표현식]
-- CREATE TABLE 테이블명(컬럼명 자료형(크기), 컬럼명 자료형(크기)....);

CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20)
);

-- 컬럼에 주석 달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';

SELECT 
        UT.*
    FROM USER_TABLES UT;
    
SELECT 
        UTC.*
    FROM USER_TAB_COLUMNS UTC
   WHERE UTC.TABLE_NAME = 'MEMBER';
   
-- 제약조건
-- 테이블 작성 시 각 컬럼에 대해 값 기록에 대한 제약 조건을 설정할 수 있다.
-- 데이터 무결성 보장을 목적으로 한다.
-- 입력/수정하는 데이터에 문제가 없는지 자동으로 검사하는 목적

SELECT 
        UC.*
    FROM USER_CONSTRAINTS UC;
    
SELECT 
        UCC.*
    FROM USER_CONS_COLUMNS UCC;
    
-- NOT NULL : 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
--            삽입/수정 시 NULL값을 허용하지 않도록 컬럼 레벨에서 제한
CREATE TABLE USER_NOCONS(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(3),
    PHONE VARCHAR2(255),
    EMAIL VARCHAR2(50)
);

INSERT
    INTO USER_NOCONS
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5678'
, 'hong123@greedy.com'
);
INSERT
    INTO USER_NOCONS
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  2
, NULL
, NULL
, NULL
, '남'
, '010-1234-5678'
, 'hong123@greedy.com'
);
ALTER USER C##EMPLOYEE QUOTA 1024M ON USERS;

COMMIT;

-- CREATE 관련된 DDL 구문은 실행과 동시에 바로 반영된다.
-- INSERT, UPDATE, DELETED와 같은 DML구문일 경우
-- 수행한 결과를 완료를 시킬려면 COMMIT, 마지막 COMMIT 시점으로 되돌리려면 ROLLBACK을 적용시켜준다.
CREATE TABLE USER_NOTNULL(
    USER_NO NUMBER NOT NULL, -- 컬럼레벨 제약조건 설정
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL,
    GENDER VARCHAR2(3),
    PHONE VARCHAR2(255),
    EMAIL VARCHAR2(50)
);

INSERT
    INTO USER_NOTNULL
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, NULL
, '남'
, '010-1234-5678'
, 'hong123@greedy.com'
);

-- UNIQUE 제약조건 : 컬럼에 입력한 값에 대해 중복을 제한하는 제약 조건
--                  컬럼레벨에서 설정가능, 테이블레벨에서도 설정 가능


CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER NOT NULL, 
    USER_ID VARCHAR2(20) UNIQUE NOT NULL, -- 컬럼레벨 제약조건 
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL,
    GENDER VARCHAR2(3),
    PHONE VARCHAR2(255),
    EMAIL VARCHAR2(50)
);

INSERT
    INTO USER_UNIQUE
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5678'
, 'hong123@greedy.com'
);

SELECT 
       UCC.TABLE_NAME
     , UCC.COLUMN_NAME 
     , UC.CONSTRAINT_TYPE
   FROM USER_CONSTRAINTS UC
      , USER_CONS_COLUMNS UCC
  WHERE UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
    AND UCC.CONSTRAINT_NAME = 'SYS_C007499';



