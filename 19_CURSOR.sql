-- CURSOR
-- 처리결과가 여러개의 행으로 구해지는 SELECT 문을 처리하기 위해 처리결과를 저장해놓은 객체이다.
-- CURSOR ~ OPEN ~ FETCH~CLOSE 단계로 진행


-- CURSOR의 상태
-- %NOTFOUND : 커서 영역의 자료가 모두 인출(FETCH)되어 다음영역이 존재하지 않으면 FALSE
-- %FOUND : 커서 영역에 자료가 아직 있다면 TRUE
-- %ISOPEN : 커서가 OPEN된 상태이면 TRUE
-- %ROWCOUNT : 커서가 얻어온 레코드의 갯수

SELECT * FROM EMPLOYEE;

CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
   V_DEPT DEPARTMENT%ROWTYPE; -- 내부에서 사용할 변수
   CURSOR C1
   IS
   SELECT D.* 
     FROM DEPARTMENT D;
BEGIN 
  OPEN C1;
  LOOP 
    FETCH C1
     INTO V_DEPT.DEPT_ID
        , V_DEPT.DEPT_TITLE
        , V_DEPT.LOCATION_ID;
      EXIT WHEN C1%NOTFOUND;
      
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID || ', 부서명 : ' || V_DEPT.DEPT_TITLE || ', 지역 : ' || V_DEPT.LOCATION_ID);
  END LOOP;
  CLOSE C1;
END;
/

EXEC CURSOR_DEPT;
SET SERVEROUTPUT ON;

-- FOR IN LOOP를 이용하면 반복시에 자동으로 CURSOR OPEN 하고 
-- 인출(FETCH)도 자동으로 한다.
-- LOOP종료할 때 자동으로 CLOSE한다.
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
   V_DEPT DEPARTMENT%ROWTYPE; -- 내부에서 사용할 변수
   CURSOR C1
   IS
   SELECT D.* 
     FROM DEPARTMENT D;
BEGIN 
  FOR V_DEPT IN C1 LOOP 
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID
                || ', 부서명 : ' || V_DEPT.DEPT_TITLE || ', 지역 : ' || V_DEPT.LOCATION_ID);
  END LOOP;
END;
/
EXEC CURSOR_DEPT;

CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
   V_DEPT DEPARTMENT%ROWTYPE; -- 내부에서 사용할 변수
BEGIN 
  FOR V_DEPT IN (SELECT * FROM DEPARTMENT) LOOP  -- 서브쿼리 형식으로 적어줌 
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID
                || ', 부서명 : ' || V_DEPT.DEPT_TITLE || ', 지역 : ' || V_DEPT.LOCATION_ID);
  END LOOP;
END;
/
EXEC CURSOR_DEPT;









