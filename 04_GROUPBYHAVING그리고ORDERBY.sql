-- GROUP


-- ORDER BY : SELECT한 컬럼을 가지고 정렬을 할 때 사용한다.
-- ORDER BY 컬럼명 | 컬럼별칭 | 컬럼 나열 순번 [ASC] | DESC

-- ORDER BY 컬럼명 정렬방식, 컬럼명 정렬방식, 컬럼명 정렬방식...
--> 첫번재 기준으로 하는 컬럼에 대해 정렬하고 같은 값들에 대해 두번째 기준으로 하는 컬럼명에 대하여 다시정렬

-- SELECT 구문의 맨 마지막에 위치, 실행순서도 맨 마지막

/*
    수행순서
    5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
    1 : FROM 참조할 테이블명
    2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
    3 : GROUP BY 그룹을 묶을 컬럼명 
    4 : HAVING 그룹함수식 비교연산자 비교값
    6 : ORDER BY 컬럼명 | 별칭 | 컬럼순선정렬 방식 [NULLS FIRST | LAST]
*/

SELECT 
        DEPT_CODE
      , COUNT(*) 사원수
    FROM EMPLOYEE
   GROUP BY DEPT_CODE;
   
SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
      , COUNT(*)
    FROM EMPLOYEE
   GROUP BY DEPT_CODE, JOB_CODE;

-- 직원 테이블에서 부서 코드별 그룹을 지정하여 
-- 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 인원수 조회
-- 부서코드순으로 오름차순 정렬하세요

SELECT 
        DEPT_CODE
      , SUM(SALARY) 합계
      , FLOOR(AVG(SALARY)) 평균
      , COUNT(*) 인원수
    FROM EMPLOYEE
   GROUP BY DEPT_CODE
--   ORDER BY DEPT_CODE ASC;
--   ORDER BY DEPT_CODE DESC NULLS FIRST;
   ORDER BY 합계 ASC NULLS FIRST;

-- 직원테이블에서 직급코드, 보너스를 받는 사원 수를 조회하여
-- 직급코드 순으로 오름차순 정렬하세요
SELECT 
        JOB_CODE
      , COUNT(*)
    FROM EMPLOYEE
   WHERE BONUS IS NOT NULL
   GROUP BY JOB_CODE
   ORDER BY JOB_CODE;
      
SELECT 
        JOB_CODE
      , COUNT(*)
    FROM EMPLOYEE
   WHERE BONUS IS NOT NULL
   GROUP BY JOB_CODE
   ORDER BY JOB_CODE;
      
-- 직원 테이블에서 주민번호의 8번째 자리를 조회하여 1이면 남, 2면 여로 결과를 조회하고
-- 성별별 급여 평균(점수처리), 급여합계, 인원수를 조회한 뒤 인원수로 내림차순 정렬

SELECT 
        DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','여') 성별
      , FLOOR(AVG(SALARY)) 평균
      , SUM(SALARY) 합계
      , COUNT(*) 인원수
    FROM EMPLOYEE
   GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','여')
   ORDER BY 인원수 DESC;

-- HAVING절 : 그룹함수로 구해올 그룹에 대해 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

SELECT 
        DEPT_CODE
      , FLOOR(AVG(SALARY)) 평균
    FROM EMPLOYEE
   WHERE SALARY > 300000
   GROUP BY DEPT_CODE
   ORDER BY DEPT_CODE;
   
SELECT 
        DEPT_CODE
      , FLOOR(AVG(SALARY)) 평균
    FROM EMPLOYEE
   GROUP BY DEPT_CODE
   HAVING FLOOR(AVG(SALARY)) > 3000000
   ORDER BY DEPT_CODE;

-- 부서별 그룹의 급여 합계 중 9백만원을 초과하는 부서 코드와 급여 합계 조회
SELECT 
        DEPT_CODE
      , SUM(SALARY) 합계
    FROM EMPLOYEE
   GROUP BY DEPT_CODE
   HAVING SUM(SALARY) > 9000000;

-- 급여 합계가 가장 많은 부서의 부서코드와 급여 합계를 구하세요
SELECT
        MAX(SUM(SALARY))
    FROM EMPLOYEE
   GROUP BY DEPT_CODE;
   
SELECT 
        DEPT_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY DEPT_CODE
   HAVING SUM(SALARY) = 17700000;

SELECT 
        DEPT_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY DEPT_CODE
   HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                           FROM EMPLOYEE
                           GROUP BY DEPT_CODE);

-- 집계함수
-- ROLLUP 함수 : 그룹별로 중간 집계 처리하는 함수 
-- GROUP BY 절에서만 사용하는 함수 
-- 그룹별로 묶여진 값에 대한 중간 집계와 총 집계를 구할 때 사용
-- 그룹별로 계산된 결과값들에 대한 총 집계가 자동으로 추가된다.
SELECT 
        JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY ROLLUP(JOB_CODE)
   ORDER BY JOB_CODE;

-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수
SELECT 
        JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY CUBE(JOB_CODE)
   ORDER BY JOB_CODE;

-- 인자로 전달한 그룹 중에서 가장 먼저 지정한 그룹별 함계와 총 합계를 구하는 함수
SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
   ORDER BY JOB_CODE;
 
-- 그룹으로 지정된 모든 그룹에 대한 집계와 총 합계를 구하는 함수
SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY CUBE(DEPT_CODE, JOB_CODE)
   ORDER BY JOB_CODE;
 
-- GROUPING 함수 : ROLLUP이나 CUBE에 의한 산출물이 인자로 전달받은 컬럼의 
--                집합 산출물이면 0 반환, 아니면 1 반환
SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
      , GROUPING(DEPT_CODE) "직급별 그룹 묶은 상태"
      , GROUPING(JOB_CODE) "부서별그룹 묶인상태"
    FROM EMPLOYEE
   GROUP BY CUBE(DEPT_CODE, JOB_CODE)
   ORDER BY DEPT_CODE;

SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
      , CASE
          WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별합계'
          WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별합계'
          WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 0 THEN '그룹별합계'
          ELSE '총합계'
       END AS 구분  
    FROM EMPLOYEE
   GROUP BY CUBE(DEPT_CODE, JOB_CODE)
   ORDER BY DEPT_CODE;

-- SET OPERATION(집합연산)
-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
--         중복된 영역을 제외하여 하나로 합친다.

SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
    FROM EMPLOYEE
   WHERE DEPT_CODE = 'D5'
   UNION
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
    FROM EMPLOYEE
   WHERE SALARY > 3000000;


-- UNION ALL : 여러개의 쿼리 결과를 하나로 합치는 연산자
--             
 
 SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
    FROM EMPLOYEE
   WHERE DEPT_CODE = 'D5'
   UNION ALL
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
    FROM EMPLOYEE
   WHERE SALARY > 3000000;

SELECT 
        DEPT_CODE
      , JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
   UNION
SELECT 
        ''
      , JOB_CODE
      , SUM(SALARY)
    FROM EMPLOYEE
   GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);

-- INTERSECT : 여러개의 SELECT한 결과에서 공통 부분만 결과로추출
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
 
-- MINUS : 선행 SELECT결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분만 추출(수학에서의 차집합과 비슷하다)
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
MINUS
SELECT 
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;















