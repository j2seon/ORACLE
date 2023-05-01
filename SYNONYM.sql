-- 동의어(SYSNONYM)
-- 다른 데이터 베이스가 가진 객체에 대한 별명 혹은 줄임말
-- 여러 다른 사용자가 테이블을 공유할 경우
-- 다른 사용자가 테이블에 접근할 경우 '사용자명.테이블명'으로 표현한다.
-- 동의어를 사용하면 간단하게 사용할 수 있다.

CREATE SYNONYM EMP FOR EMPLOYEE; -- 그냥하면 권한이 불충분하다.

-- SYSNONYM 생성권한 부여(시스템계정으로 실행)
GRANT CREATE SYNONYM TO C##EMPLOYEE;

SELECT 
       * 
   FROM EMP;
   
-- 동의어 구분
-- 1. 비공개 동의어
-- 객체에 대한 접근 권한을 부여받은 사용자가 정의한 동의어
-- 2. 공개 동의어
-- 모든 권한을 주는 사용자(DBA) 정의한 동의어
-- 모든 사용자가 사용할 수 있다. (PUBLIC)
-- EX ) DUAL
SELECT 
       D.* 
   FROM C##EMPLOYEE.DEPARTMENT D;
   
CREATE PUBLIC SYNONYM DEPT FOR C##EMPLOYEE.DEPARTMENT;

SELECT 
       * 
   FROM EMP;

SELECT 
       *
   FROM DEPT;

   