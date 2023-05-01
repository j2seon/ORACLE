-- 조인(JOIN)
-- JOIN : 두 개의 테이블을 하나로 합쳐서 결과를 조회한다.
-- 오라클 전용 구문 FROM 절에 ','로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시 

-- 연결에 사용할 두 컬럼명이 다른 경우
SELECT 
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
   FROM EMPLOYEE
      , DEPARTMENT
  WHERE DEPT_CODE = DEPT_ID;
  
-- 연결에 사용할 두 컬럼명이 같은 경우
SELECT 
       EMP_ID
     , EMP_NAME
     , EMPLOYEE.JOB_CODE 
   FROM EMPLOYEE 
      , JOB 
  WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE; 
  
-- 테이블에 별칭 사용
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE 
   FROM EMPLOYEE E
      , JOB J
  WHERE E.JOB_CODE = J.JOB_CODE; 

-- ANSI 표준 구문
-- 연결에 사용할 컬럼명이 같은 경우
-- USING(컬럼명)을 사용
SELECT 
       EMP_ID
     , EMP_NAME
     , JOB_CODE
     , JOB_NAME
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);

-- 연결에 사용할 컬럼명이 다른 경우 ON을 사용
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
   FROM EMPLOYEE
   JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 연결에 사용할 컬럼명이 같은 경우에도 ON()을 사용할 수 있다.
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , J.JOB_NAME
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 부서 테이블과 지역 테이블을 조인하여 테이블에 모든 데이터를 조회하세요
-- 오라클 전용 
SELECT 
       *
   FROM DEPARTMENT
      , LOCATION
  WHERE LOCATION_ID = LOCAL_CODE;
  
-- ANSI 전용
SELECT 
        *
   FROM DEPARTMENT D
   JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

-- 조인은 기본이 EQUAL JOIN(EQU JOIN)이라고 한다.
-- 연결되는 컬럼의 값이 일치하는 행들만 조인된다.


-- JOIN의 기본은 INNER JOIN & EQU JOIN이다.

-- OUTER JOIN : 두 테이블의 지정하는 컬럼 값이 일치하지 않는 행도 조인에 포함을 시킨다.
--            반드시 OUTER JOIN임을 명시해야한다.

-- 1. LEFT OUTER JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 행의 수를 기준으로 JOIN
-- 2. RIGHT OUTER JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 행의 수를 기준으로 JOIN
-- 3. FULL OYTER JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함하여 JOIN

SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
   JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID); -- INNER EQU JOIN

--LEFT OUTER JOIN
-- 오라클전용
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
      , DEPARTMENT
  WHERE DEPT_CODE = DEPT_ID(+);

-- ANSI 표준
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
   LEFT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- RIGHT OUTER JOIN 
-- 오라클 전용
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
      , DEPARTMENT
  WHERE DEPT_CODE(+) = DEPT_ID;

-- ANSI 표준
SELECT
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
--  RIGHT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
  RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- FULL OUTER JOIN
-- 오라클 전용 구문으로는 FULL OUTER JOIN을 하지 못한다.
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
      , DEPARTMENT
  WHERE DEPT_CODE(+) = DEPT_ID(+);

-- ANSI 표준
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
   FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- CROSS JOIN : 카테이션 곱이라고 한다. -> 모든 경우의 수 
-- 조인 되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법이다.
SELECT 
       EMP_NAME
     , DEPT_TITLE
   FROM EMPLOYEE
  CROSS JOIN DEPARTMENT;

-- NON EQUAL JOIN(NON EQU JOIN)
-- 지정한 컬럼 값이 일치하는 경우가 아닌 값의 범위에 포함되는 행동을 연결하는 방식
-- 오라클 전용
SELECT
       EMP_NAME
     , E.SALARY
     , E.SAL_LEVEL
     , S.SAL_LEVEL
  FROM EMPLOYEE E
     , SAL_GRADE S
 WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-- ANSI 표준
SELECT
       EMP_NAME
     , E.SALARY
     , E.SAL_LEVEL
     , S.SAL_LEVEL
  FROM EMPLOYEE E
 JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- SELF JOIN : 같은 테이블을 조인하는 경ㅇ
--             자기자신과 조인을 맺는 것이다.
-- 오라클 조인
SELECT
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.DEPT_CODE
     , E1.MANAGER_ID
     , E2.EMP_NAME
  FROM EMPLOYEE E1
     , EMPLOYEE E2
 WHERE E1.MANAGER_ID = E2.EMP_ID;
 
--ANSI 표준
SELECT
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.DEPT_CODE
     , E1.MANAGER_ID
     , E2.EMP_NAME
  FROM EMPLOYEE E1
  JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);

-- 다중 JOIN : N개의 테이블을 조회할 때 사용
-- ANSI 표준
-- 조인 순서 중요
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
     , LOCAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

--오라클 전용
-- 조인순서 상관없음.
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
     , LOCAL_NAME
  FROM EMPLOYEE
     , DEPARTMENT
     , LOCATION
 WHERE DEPT_CODE = DEPT_ID
   AND LOCATION_ID = LOCAL_CODE
   AND EMP_ID = 200;
  
-- 직급이 대리이면서 아시아 지역에 근무하는 직원을 조회한다.
-- 사번 이름 직급명 부서명 근무지역명 급여를 조회
-- 조회시에는 모든 컬럼에 테이블 별칭을 사용하는 것이 좋다.
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , L.LOCAL_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  WHERE L.LOCAL_NAME LIKE 'ASIA%'
    AND J.JOB_NAME = '대리';

-- 오라클 전용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , LOCAL_NAME
     , E.SALARY
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
     , LOCATION L
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND J.JOB_NAME = '대리'
   AND L.LOCAL_NAME LIKE 'ASIA%';


-- ------------- 연습문제 ---------------------------------------
-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
-- ANSI 표준

SELECT 
       E.EMP_NAME
     , E.EMP_NO
     , E.DEPT_CODE
     , J.JOB_NAME
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   WHERE E.EMP_NO LIKE '7%'
   AND SUBSTR(E.EMP_NO,8,1) = 2
   AND EMP_NAME LIKE '전%';

-- 오라클전용
SELECT 
       E.EMP_NAME
     , E.EMP_NO
     , E.DEPT_CODE
     , J.JOB_NAME
   FROM EMPLOYEE E
      , JOB J
  WHERE E.JOB_CODE = J.JOB_CODE
    AND E.EMP_NO LIKE '7%'
    AND SUBSTR(E.EMP_NO,8,1) = 2
    AND EMP_NAME LIKE '전%';

-- 2. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , TO_CHAR(SYSDATE, 'RRRR')- TO_CHAR(CONCAT(19,SUBSTR(E.EMP_NO,1,2))) AS 나이
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE SUBSTR(E.EMP_NO,1,2) = (
    SELECT MAX(SUBSTR(E.EMP_NO,1,2)) FROM EMPLOYEE E
  );



-- 오라클전용

-- 3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
-- ANSI 표준

SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  WHERE E.EMP_NAME LIKE '%형%';


-- 오라클전용
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
   FROM EMPLOYEE E
      , DEPARTMENT D
  WHERE E.DEPT_CODE = D.DEPT_ID
    AND E.EMP_NAME LIKE '%형%';
   
   
-- 4. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오
-- ANSI 표준

SELECT 
       E.EMP_ID
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
   WHERE D.DEPT_TITLE LIKE '해외영업%';
  
-- 오라클전용
SELECT 
       E.EMP_ID
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
   FROM EMPLOYEE E
      , JOB J
      , DEPARTMENT D
  WHERE E.JOB_CODE = J.JOB_CODE
    AND E.DEPT_CODE = D.DEPT_ID
    AND D.DEPT_TITLE LIKE '해외영업%';
    
-- 5. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  WHERE E.BONUS IS NOT NULL;

-- 오라클전용
SELECT 
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.BONUS IS NOT NULL;

-- 6. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
   JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
   WHERE E.DEPT_CODE = 'D2';

-- 오라클전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
   FROM EMPLOYEE E
      , JOB J
      , DEPARTMENT D
      , LOCATION L
  WHERE E.JOB_CODE = J.JOB_CODE
    AND E.DEPT_CODE = D.DEPT_ID
    AND D.LOCATION_ID = L.LOCAL_CODE
    AND E.DEPT_CODE = 'D2';

-- 7. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의 
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하시오.
--    단, 연봉에 보너스 포인트를 적용
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , (E.SALARY * 12) + ((E.SALARY * 12) * NVL(BONUS,0))
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   JOIN SAL_GRADE S ON(E.SAL_LEVEL = S.SAL_LEVEL)
   WHERE E.SALARY > S.MIN_SAL;
   
-- 오라클전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , (E.SALARY * 12) + ((E.SALARY * 12) * NVL(BONUS,0))
   FROM EMPLOYEE E
      , JOB J
      , SAL_GRADE S
  WHERE E.JOB_CODE = J.JOB_CODE
    AND E.SAL_LEVEL = S.SAL_LEVEL
    AND E.SALARY > S.MIN_SAL;

-- 8. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
 WHERE L.NATIONAL_CODE = 'KO'
    OR L.NATIONAL_CODE = 'JP';

-- 오라클전용
SELECT 
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     , NATIONAL N 
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND L.NATIONAL_CODE IN('KO', 'JP');

-- 9. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료 이름을 조회하시오
--    단, Self Join 사용
-- ANSI 표준
SELECT 
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME
  FROM EMPLOYEE E1
  JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
  WHERE E1.EMP_NAME <> E2.EMP_NAME;

-- 오라클전용


-- 10. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
--     단, join과 in을 사용할 것
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
   WHERE E.BONUS IS NULL
     AND E.JOB_CODE IN ('J4','J7');


-- 오라클전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
   FROM EMPLOYEE E
      , JOB J
  WHERE  
   E.JOB_CODE = J.JOB_CODE
     AND E.BONUS IS NULL
     AND E.JOB_CODE IN ('J4','J7');


  
  