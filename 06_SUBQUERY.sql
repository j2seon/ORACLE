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
                
-- 다중행 서브쿼리
-- 다중행 서브쿼리 앞에서는 일반 비교연산자를 사용하지 못한다
-- IN / NOT IN : 여러개의 결과 값 중에서 한개라도 일치하는 값이 있다면 혹은 없다면의 의미
-- > ANY, < ANY : 여러개의 결과 값 중에서 한개라도 큰/작은 경우 

-- > ALL, < ALL : 모든 값보다 큰/작은 경우
--                가장 큰 값보다 크니? / 가장 작은값보다 작니?
-- EXISTS / NOT EXISTS : 서브쿼리에만 사용하는 연산자로 값이 존재하니/존재하지 않니?
       
-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
SELECT 
       E.DEPT_CODE
     , MAX(SALARY)
   FROM EMPLOYEE E
   GROUP BY E.DEPT_CODE;

SELECT 
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY IN (SELECT MAX(E2.SALARY)
                       FROM EMPLOYEE E2
                       GROUP BY E2.DEPT_CODE
                     );

-- 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의 정보를 추출하여 조회
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분, / '직원' AS 구분
SELECT 
       DISTINCT MANAGER_ID
   FROM EMPLOYEE E
  WHERE E.MANAGER_ID IS NOT NULL;

SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 이름
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급
     , '관리자' AS 구분
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE E.EMP_ID IN (SELECT DISTINCT E2.MANAGER_ID
                     FROM EMPLOYEE E2
                     WHERE E2.MANAGER_ID IS NOT NULL
                     )
 UNION
SELECT 
       E3.EMP_ID 사번
     , E3.EMP_NAME 이름
     , D3.DEPT_TITLE 부서명
     , J3.JOB_NAME 직급
     , '직원' AS 구분
  FROM EMPLOYEE E3
  LEFT JOIN DEPARTMENT D3 ON(E3.DEPT_CODE = D3.DEPT_ID)
  LEFT JOIN JOB J3 ON(E3.JOB_CODE = J3.JOB_CODE)
  WHERE E3.EMP_ID NOT IN (SELECT DISTINCT E4.MANAGER_ID
                     FROM EMPLOYEE E4
                     WHERE E4.MANAGER_ID IS NOT NULL
                     );

-- SELECT 절에도 서브쿼리를 사용할 수 있다.
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
     , CASE 
         WHEN E.EMP_ID IN (SELECT DISTINCT E2.MANAGER_ID
                             FROM EMPLOYEE E2
                             WHERE E2.MANAGER_ID IS NOT NULL
                             )
         THEN '관리자'
         ELSE '직원'
        END AS 구분
   FROM EMPLOYEE E
   LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여를 조회하세요
-- 단 > ANY < ANY 연산자 사용

SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SAL_LEVEL
     , E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '과장';
       
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SAL_LEVEL
     , E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '대리';
  
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '대리'
    AND E.SALARY > ANY(SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '과장'
                       );
-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 사번 이름 직급 급여를 조회하세요
-- 단 > ALL 혹은 < ALL 연산자를 사용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '과장' 
    AND E.SALARY > ALL(SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '차장'
                       );
SELECT 
       E.*
   FROM EMPLOYEE E
  WHERE NOT EXISTS (SELECT E2.*
                      FROM EMPLOYEE E2
                     WHERE E2.EMP_ID ='100'
                    );
-- 자기 직급의 평균 급여를 받고있는 직원의
-- 사번, 이름 직급코드 급여를 조회하세요
-- 단 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -5)
SELECT 
       E.JOB_CODE
     , TRUNC(AVG(E.SALARY), -5)
   FROM EMPLOYEE E
  GROUP BY E.JOB_CODE;

SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY IN (SELECT TRUNC(AVG(E2.SALARY),-5)
                      FROM EMPLOYEE E2
                      GROUP BY E2.JOB_CODE
                    );
                    
-- 다중행 다중열 서브쿼리를 이용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
   FROM EMPLOYEE E      
  WHERE (E.JOB_CODE, E.SALARY) IN (SELECT TRUNC(AVG(E2.SALARY),-5)
                                     FROM EMPLOYEE E2
                                    GROUP BY E2.JOB_CODE
                                  );                     
-- 다중열 서브쿼리
-- 퇴사한 여직원과 같은 부서 같은 직급에 해당하는 
-- 사원의 이름, 직급, 부서, 입사일
SELECT 
       E.DEPT_CODE
   FROM EMPLOYEE E
  WHERE SUBSTR(E.EMP_NO, 8, 1) = 2
    AND E.ENT_YN = 'Y';
       
SELECT 
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.HIRE_DATE
   FROM EMPLOYEE E
  WHERE E.DEPT_CODE IN (SELECT E2.DEPT_CODE
                         FROM EMPLOYEE E2
                        WHERE SUBSTR(E2.EMP_NO, 8, 1) = 2
                          AND E2.ENT_YN = 'Y'
                        )
    AND E.JOB_CODE IN (SELECT E3.JOB_CODE
                         FROM EMPLOYEE E3
                        WHERE SUBSTR(E3.EMP_NO, 8, 1) = 2
                          AND E3.ENT_YN = 'Y'
                       )
    AND E.EMP_ID NOT IN (SELECT E4.EMP_ID
                         FROM EMPLOYEE E4
                        WHERE SUBSTR(E4.EMP_NO, 8, 1) = 2
                          AND E4.ENT_YN = 'Y'
                     );

-- 다중열 서브쿼리로 변경      
SELECT 
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.HIRE_DATE
   FROM EMPLOYEE E
  WHERE (E.DEPT_CODE, E.JOB_CODE) IN (SELECT E2.DEPT_CODE
                                           , E2.JOB_CODE
                                        FROM EMPLOYEE E2
                                       WHERE SUBSTR(E2.EMP_NO, 8, 1) = 2
                                         AND E2.ENT_YN = 'Y'
                                      )
    AND E.EMP_ID NOT IN (SELECT E4.EMP_ID
                         FROM EMPLOYEE E4
                        WHERE SUBSTR(E4.EMP_NO, 8, 1) = 2
                          AND E4.ENT_YN = 'Y'
                     );       
 
-- 서브쿼리의 사용 위치 :
-- SELECT절 FROM 절 WHERE절 HAVING절 GROUP BY절 ORDER BY절
-- DML : INSERT문 UPDATE문
-- DDL : CREATE TABLE 문 CREATE VIEW문 

-- FROM 절에서 서브쿼리를 사용할 수 있다. : 테이블 대신에 사용 
-- 인라인 뷰(INLINE VIEW)라고 한다.
-- 서브쿼리가 만든 결과집합(RESULT SET)에 대한 출력 화면
                   
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
   FROM (SELECT E2.JOB_CODE
              , TRUNC(AVG(E2.SALARY),-5) AS JOBAVG
           FROM EMPLOYEE E2
          GROUP BY E2.JOB_CODE
        ) V
    JOIN EMPLOYEE E ON(V.JOBAVG = E.SALARY AND V.JOB_CODE = E.JOB_CODE)
    JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
    ORDER BY J.JOB_NAME;

SELECT 
        V.EMP_NAME
      , V.부서명
      , V.직급이름
   FROM (SELECT E.EMP_NAME
              , D.DEPT_TITLE AS 부서명
              , J.JOB_NAME 직급이름
            FROM EMPLOYEE E
            LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
            JOIN JOB J ON(E.JOB_CODE =J.JOB_CODE)
         ) V
  WHERE V.부서명 = '인사관리부';
                   
-- 인라인뷰를 활용한 TOP-N분석
-- ROWNUM : 행번호를 의미한다.
-- ROWNUM을 ORDER BY 후에 적용

SELECT 
       ROWNUM
     , E.EMP_NAME
     , E.SALARY
  FROM EMPLOYEE E
 ORDER BY E.SALARY;
                   
SELECT 
       ROWNUM
     , V.EMP_NAME
     , V.SALARY
  FROM (SELECT E.*
          FROM EMPLOYEE E
         ORDER BY E.SALARY DESC 
         ) V
  WHERE ROWNUM <=5;
  
-- 급여 평균 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회하세요

SELECT 
      ROWNUM
    , V.DEPT_CODE
    , V.DEPT_TITLE
    , V.평균급여
   FROM (SELECT E.DEPT_CODE
              , D.DEPT_TITLE
              , AVG(E.SALARY) 평균급여
            FROM EMPLOYEE E
            JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
            GROUP BY E.DEPT_CODE, D.DEPT_TITLE
            ORDER BY 평균급여 DESC
         ) V
  WHERE ROWNUM <=3;
                   
-- 직원 정보에서 급여를 가장 많이 받는 순으로 이름 급여 순위 조회
-- RANK()함수 : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너 뛰고 다음 순위를 계산하는 방식
SELECT 
       E.EMP_NAME
     , E.SALARY
     , RANK() OVER(ORDER BY E.SALARY DESC) 순위
   FROM EMPLOYEE E;
   
-- DENSE_RANK() : 중복되는 순위 이후의 등수를 이후 등수로 처리
SELECT 
       E.EMP_NAME
     , E.SALARY
     , DENSE_RANK() OVER(ORDER BY E.SALARY DESC) 순위
   FROM EMPLOYEE E;

-- 직원 테이블에서 보너스 포함한 연봉이 높은 5명의
-- 사번, 이름, 부서명, 직급명, 입사일을 조회하세요
SELECT 
       ROWNUM 
     , V.EMP_ID
     , V.EMP_NAME
     , V.DEPT_TITLE
     , V.JOB_NAME
     , V.HIRE_DATE
     , 순위
  FROM (SELECT E.EMP_ID
             , E.EMP_NAME
             , D.DEPT_TITLE
             , J.JOB_NAME
             , E.HIRE_DATE
             , E.DEPT_CODE
             , E.JOB_CODE
             , (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12 연봉
             , RANK() OVER(ORDER BY ((E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12) DESC) 순위
        FROM EMPLOYEE E
        JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
        JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
        ) V
  WHERE 순위 < 6;

-- WITH 이름 AS (쿼리문)
-- 서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게됨
-- 인라인 뷰로 사용될 서브쿼리에서 이용된다.
-- 같은 서브쿼리가 여러번 사용될 경우 중복작성을 줄일 수 있다.
-- 실행속도도 빨라진다.
WITH 
     TOPN_SAL
  AS (SELECT E.EMP_ID
           , E.EMP_NAME
           , E.SALARY
        FROM EMPLOYEE E
       ORDER BY E.SALARY DESC
      )
SELECT ROWNUM
     , T.EMP_NAME
     , T.SALARY
   FROM TOPN_SAL T;
   
-- 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은 부서의 부서명과 부서별 급여 합계 조회
SELECT 
       D.DEPT_TITLE
     , SUM(E.SALARY)
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  GROUP BY D.DEPT_TITLE
 HAVING SUM(E.SALARY) > (SELECT SUM(E2.SALARY) * 0.2
                           FROM EMPLOYEE E2
                        );
-- 인라인뷰 사용
SELECT 
       V.DEPT_TITLE
     , V.SSAL
  FROM (SELECT 
               D.DEPT_TITLE
             , SUM(E.SALARY)SSAL
          FROM EMPLOYEE E
          JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
         GROUP BY D.DEPT_TITLE
        ) V
  WHERE V.SSAL > (SELECT SUM(E2.SALARY) * 0.2
                      FROM EMPLOYEE E2
                );
                
--WITH 
WITH
     TOTAL_SAL
  AS(SELECT 
               D.DEPT_TITLE
             , SUM(E.SALARY) SSAL
          FROM EMPLOYEE E
          JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
         GROUP BY D.DEPT_TITLE
  )
SELECT 
       DEPT_TITLE
     , SSAL
  FROM TOTAL_SAL
  WHERE SSAL > (SELECT SUM(E2.SALARY) * 0.2
                      FROM EMPLOYEE E2
                );

 
-- WITH로 서브쿼리 여러 개 저장
WITH 
     SUM_SAL 
  AS(SELECT SUM(E.SALARY)
       FROM EMPLOYEE E
    )
  , AVG_SAL
  AS (SELECT AVG(E2.SALARY)
        FROM EMPLOYEE E2
      )
SELECT 
     S.*
    FROM SUM_SAL S
  UNION
SELECT 
     A.*
  FROM AVG_SAL A;

-- 상[호연]관 서브쿼리
-- 일반적으로는 서브쿼리가 만든 결과 값을 메인쿼리가 비교연산
-- 메인쿼리가 사용하는 테이블의 값을 서브쿼리가 이용해서 결과를 만든다.
-- 즉, 메인 쿼리의 테이블값이 변경되면, 서브쿼리의 결과값도 바뀌게된다.
                   
-- 관리자 사번이 EMPLOYEE 테이블에 존재하는 직원에 대한 조회
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.MANAGER_ID
   FROM EMPLOYEE E
  WHERE EXISTS (SELECT E2.EMP_ID
                  FROM EMPLOYEE E2
                 WHERE E.MANAGER_ID = E2.EMP_ID
                );
                
-- 스칼라 서브쿼리
-- 단일행 서브쿼리 + 상관쿼리
-- SELECT절, WHERE절, ORDER BY절 사용가능

-- 동일 직급의 급여 평균보다 급여를 많이 받고 있는 직원의 사번, 직급코드, 급여를 조회하세요
-- WHERE 절에서 스칼라 서브쿼리
SELECT 
       E.EMP_ID
     , E.JOB_CODE
     , E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY > (SELECT TRUNC(AVG(M.SALARY), -5)
                      FROM EMPLOYEE M
                     WHERE E.JOB_CODE = M.JOB_CODE
                   );

-- SELECT절에서 스칼라서브쿼리
-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회하세요
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
     , NVL((SELECT M.EMP_NAME
              FROM EMPLOYEE M
             WHERE E.MANAGER_ID = M.EMP_ID
             ), '없음')
    FROM EMPLOYEE E;    
  
-- ORDER BY 절에서 스칼라 서브쿼리 이용
-- 모든 직원의 사번, 이름, 소속부서 조회
-- 단, 부서명 내림차순 정렬
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
   FROM EMPLOYEE E
  ORDER BY (SELECT D.DEPT_TITLE
              FROM DEPARTMENT D
             WHERE E.DEPT_CODE = D.DEPT_ID
            ) DESC NULLS LAST;
  
  
  
                   