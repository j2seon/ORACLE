-- PL/SQL(PROCEDURE LANGUAGE EXTENSION TO SQL)
-- 오라클 자체에 내장된 절차적 언어
-- SQL 단점을 보완하여 SQL문장 내에서 
-- 변수의 정의, 조건처리, 반복처리, 예외처리등을 지원한다.

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/
-- 콘솔창에 PLSQL을 띄움
SET SERVEROUTPUT ON; 

-- 변수의 선언과 초기와, 변수 값 출력
DECLARE 
   EMP_ID NUMBER;
   EMP_NAME VARCHAR2(30);
BEGIN
  EMP_ID := 888;
  EMP_NAME :='배장남';

  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

-- 레퍼런스 변수의 선언과 초기화, 변수값 출력
DECLARE 
   EMP_ID EMPLOYEE.EMP_ID%TYPE;
   EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT
           E.EMP_ID
         , E.EMP_NAME
       INTO EMP_ID
          , EMP_NAME
       FROM EMPLOYEE E
       WHERE E.EMP_ID = '&아이디';
       
  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

-- 레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를
-- 선언하고 EMPLOYEE 테이블에서 사번, 이름 , 부서코드 직급코드 급여를 조회하여
-- 선언한 레퍼런스 변수에 담아 출력하세여
-- 입력받은 이름과 일치하는 조건의 직원을 조회
DECLARE
  EMP_ID EMPLOYEE.EMP_ID%TYPE;
  EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
  DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
  JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
  SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT 
           E.EMP_ID
         , E.EMP_NAME
         , E.DEPT_CODE
         , E.JOB_CODE
         , E.SALARY
        INTO EMP_ID
           , EMP_NAME
           , DEPT_CODE
           , JOB_CODE
           , SALARY
        FROM EMPLOYEE E
       WHERE E.EMP_ID = '&EMPID';
       
  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DEPT_CODE);
  DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JOB_CODE);
  DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
  
END;
/

-- %ROWTYPE 
-- 테이블의 한행의 모든 컬럼과 자료형을 참조하는 경우 사용
DECLARE
   EMP EMPLOYEE%ROWTYPE;
BEGIN
   SELECT E.*
     INTO EMP
     FROM EMPLOYEE E
    WHERE EMP_ID = '&EMP_ID';
    
  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP.EMP_ID);
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP.EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || EMP.DEPT_CODE);
  DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || EMP.JOB_CODE);
  DBMS_OUTPUT.PUT_LINE('SALARY : ' || EMP.SALARY);   
END;
/

-- 연봉을 구하는 PL/SQL 블럭작성
DECLARE 
   VEMP EMPLOYEE%ROWTYPE;
   YSALARY NUMBER;
BEGIN
   SELECT E.*
     INTO VEMP
     FROM EMPLOYEE E
    WHERE E.EMP_NAME = '&사원명';
    
    IF(VEMP.BONUS IS NULL) THEN YSALARY := VEMP.SALARY * 12;
    ELSIF(VEMP.BONUS IS NOT NULL) THEN YSALARY := (VEMP.SALARY + (VEMP.SALARY * VEMP.BONUS)) * 12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.EMP_ID || '             '
                         || VEMP.EMP_NAME || '           '
                         || TO_CHAR(YSALARY, 'L99,999,999'));
END;
/
SELECT (SALARY) * 12 FROM EMPLOYEE WHERE EMP_ID = '201';

-- 점수를 입력받아 SCORE 변수에 저장하고
-- 90점 이상은 'A', 80점 이상은'B' , 70점이상은 'C'
-- 60점 이상은 'D', 60점 미만은 'F'로 조건 처리하여
-- GRADE 변수에 저장하고
-- 당신의 점수는 90점이고, 학점은 A 학점입니다. 형태로 출력하세요

DECLARE 
   SCORE NUMBER;
   GRADE VARCHAR2(1);
BEGIN
   SCORE := '&SCORE';
   
   IF SCORE >= 90 THEN GRADE :='A';
   ELSIF SCORE >= 80 THEN GRADE :='B';
   ELSIF SCORE >= 70 THEN GRADE :='C';
   ELSIF SCORE >= 60 THEN GRADE :='D';
   ELSE GRADE := 'F';
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');
END;
/

DECLARE 
    VEMPNO EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTNO EMPLOYEE.DEPT_CODE%TYPE;
    VDNAME VARCHAR2(20) := NULL;
BEGIN
    SELECT E.EMP_ID
         , E.EMP_NAME
         , E.DEPT_CODE
      INTO VEMPNO
         , VENAME
         , VDEPTNO
      FROM EMPLOYEE E
     WHERE E.EMP_ID = '&사번';
     
     IF(VDEPTNO = 'D1') THEN VDNAME := '인사관리부';
     END IF;
     IF(VDEPTNO = 'D2') THEN VDNAME := '회계관리부';
     END IF;
     IF(VDEPTNO = 'D3') THEN VDNAME := '마케팅부';
     END IF;
     IF(VDEPTNO = 'D4') THEN VDNAME := '국내영업부';
     END IF;
     IF(VDEPTNO = 'D5') THEN VDNAME := '해외영업1부';
     END IF;
     IF(VDEPTNO = 'D6') THEN VDNAME := '해외영업2부';
     END IF;
     IF(VDEPTNO = 'D7') THEN VDNAME := '해외영업3부';
     END IF;
     IF(VDEPTNO = 'D8') THEN VDNAME := '기술지원부';
     END IF;
     IF(VDEPTNO = 'D9') THEN VDNAME := '총무부';
     END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번       이름       부서명'); 
    DBMS_OUTPUT.PUT_LINE('---------------------------'); 
    DBMS_OUTPUT.PUT_LINE(VEMPNO || '       ' || VENAME || '      '|| VDNAME ); 
END;
/

DECLARE 
    VEMPNO EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTNO EMPLOYEE.DEPT_CODE%TYPE;
    VDNAME VARCHAR2(20) := NULL;
BEGIN
    SELECT E.EMP_ID
         , E.EMP_NAME
         , E.DEPT_CODE
      INTO VEMPNO
         , VENAME
         , VDEPTNO
      FROM EMPLOYEE E
     WHERE E.EMP_ID = '&사번';
     
     VDNAME := CASE VDEPTNO
                 WHEN 'D1' THEN '인사관리부'
                 WHEN 'D2' THEN '회계관리부'
                 WHEN 'D3' THEN '마케팅부'
                 WHEN 'D4' THEN '국내영업부'
                 WHEN 'D5' THEN '해외영업1부'
                 WHEN 'D6' THEN '해외영업2부'
                 WHEN 'D7' THEN '해외영업3부'
                 WHEN 'D8' THEN '기술지원부'
                 WHEN 'D9' THEN '총무부'
              END;
    DBMS_OUTPUT.PUT_LINE('사번       이름       부서명'); 
    DBMS_OUTPUT.PUT_LINE('---------------------------'); 
    DBMS_OUTPUT.PUT_LINE(VEMPNO || '       ' || VENAME || '      '|| VDNAME ); 
END;
/

-- 반복문(LOOP)
DECLARE
   N NUMBER :=1;
BEGIN
   LOOP
     DBMS_OUTPUT.PUT_LINE(N);
     N := N + 1;
     IF N > 5 THEN EXIT;
     END IF;
   END LOOP;
END;
/

CREATE TABLE TEST1(
  BUNHO NUMBER(3),
  NALJJA DATE
);

BEGIN 
   FOR I IN 1..10
     LOOP
       INSERT 
         INTO TEST1(BUNHO,NALJJA)
         VALUES (I, SYSDATE);
     END LOOP;
END;
/

SELECT * FROM TEST1;

-- 구구단 짝수단 출력하기
DECLARE 
  RESULT NUMBER;
BEGIN
    FOR DAN IN 2..9
      LOOP
        IF MOD(DAN, 2) = 0
            THEN FOR SU IN 1..9
                 LOOP 
                   RESULT := DAN * SU;
                   DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
                 END LOOP;
                 DBMS_OUTPUT.PUT_LINE(' ');
        END IF;    
    END LOOP;
END;
/

DECLARE 
   RESULT NUMBER;
   DAN NUMBER := 2;
   SU NUMBER;
BEGIN
   WHILE DAN <= 9
   LOOP
     SU := 1;
     IF MOD(DAN, 2) = 0
        THEN WHILE SU <= 9
        LOOP
          RESULT := DAN * SU;
          DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
          SU := SU + 1;
        END LOOP;
     END IF;   
     DAN := DAN + 1;
     DBMS_OUTPUT.PUT_LINE(' ');
   END LOOP; 
END;
/

-- 레코드 타입의 변수 선언 및 값 대입 출력
DECLARE 
  TYPE EMP_RECORD_TYPE IS RECORD(
    EMP_ID EMPLOYEE.EMP_ID%TYPE,
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
    JOB_NAME JOB.JOB_NAME%TYPE
  );

  EMP_RECORD EMP_RECORD_TYPE; -- 변수선언
 BEGIN
   SELECT E.EMP_ID
        , E.EMP_NAME
        , D.DEPT_TITLE
        ,J.JOB_NAME
    INTO EMP_RECORD
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
    LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
    WHERE E.EMP_NAME = '&EMP_NAME'; 
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : '|| EMP_RECORD.JOB_NAME);
 END;
/
-- 예외처리
BEGIN
  UPDATE EMPLOYEE E
     SET E.EMP_ID = '&사번'
   WHERE E.EMP_ID = '200' ;
  EXCEPTION 
     WHEN DUP_VAL_ON_INDEX
     THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/

-- 정의되지 않은 예외처리
DECLARE 
    DUP_EMPNO EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUP_EMPNO, -00001);
BEGIN
   UPDATE EMPLOYEE E
      SET E.EMP_ID = '&사번'
    WHERE E.EMP_ID = '200';
    EXCEPTION 
     WHEN DUP_EMPNO
     THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/


