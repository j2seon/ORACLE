-- SUBQUERY(서브쿼리)
-- 서브 쿼리 : 쿼리문 안에서 사용된 쿼리문

-- 사원명이 노옹철인 사람의 부서 조회
SELECT 
       E.DEPT_CODE
   FROM EMPLOYEE E
 WHERE E.EMP_NAME = '노옹철';
 
 
-- 부서코드가 D9인 직원을 조회하세요
SELECT 
       E.EMP_NAME
   FROM EMPLOYEE E
  WHERE E.DEPT_CODE ='D9';

-- 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
SELECT 
       E.EMP_NAME
   FROM EMPLOYEE E
  WHERE E.DEPT_CODE =(SELECT E.DEPT_CODE
                      FROM EMPLOYEE E
                      WHERE E.EMP_NAME = '노옹철'
                      );

-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번 이름 직급코드 급여를 조회하세요
SELECT 
        EMP_ID
      , EMP_NAME
      , JOB_CODE
      , SALARY
   FROM EMPLOYEE
   WHERE SALARY > (SELECT AVG(E.SALARY)
                   FROM EMPLOYEE E
                   );

-- 서브쿼리의 유형
-- 단일행 서브쿼리 : 서브쿼리의 조회결과 값이 1개 행일 때
-- 다중행 서브쿼리 : 서브쿼리의 조회 결과값의 행이 여러개 일 때 
-- 다중열 서브쿼리 : 서브쿼리의 조회 결과값의 컬럼이 여러개 일 때
-- 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수 가 여러개 일 때

-- 서브쿼리의 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름
-- 단일 행 서브쿼리 앞에는 일반 비교 연산자 사용
-- >,<, >=, <=, !=/<>/^= (서브쿼리)

-- 노옹철 사원의 급여보다 많이 받는 직원의 사번 이름 부서 직급 급여를 조회하세요
SELECT 
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , SALARY
   FROM EMPLOYEE
  WHERE SALARY > (SELECT E.SALARY
                  FROM EMPLOYEE E
                  WHERE E.EMP_NAME = '노옹철'
                  );

-- 가장 적은 급여를 받는 직원의 사번, 이름 부서 급여 입사일을 조회하세요
SELECT 
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.DEPT_CODE
     , E1.SALARY
     , E1.HIRE_DATE
   FROM EMPLOYEE E1
  WHERE E1.SALARY = (SELECT MIN(E2.SALARY)
                  FROM EMPLOYEE E2
                  );
                  
-- 서브쿼리 SELECT, FROM WHERE HAVING GROUP BY 절에도 사용할 수 있다.

SELECT 
       D.DEPT_TITLE
     , SUM(E.SALARY)
   FROM EMPLOYEE E
   LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  GROUP BY D.DEPT_TITLE
 HAVING SUM(E.SALARY) = (SELECT MAX(SUM(E2.SALARY))
                         FROM EMPLOYEE E2
                         GROUP BY E2.DEPT_CODE);
                
                   
                   
                   
                   