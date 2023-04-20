/* 그룹함수와 단일행함수  
    함수 (FUNCTION): 컬럼값을 읽어서 계산한 결과를 리턴한다.
    단일행(SINGLE ROW) 함수 : 컬럼에 기록된 N개의 값을 읽어서 N개의 결과를 리턴
    그룹(GROUP)함수 : 컬럼에 기록된 N개의 값을 읽어서 한개의 결과 리턴
*/

/* SELECT절에 단일행 함수와 그룹함수를 함께 사용 못함.
   결과 행의 갯수가 다르기 때문
*/

-- 함수를 사용할 수 있는 위치 : SELECT, WHERE, GROUP BY, HAVING, ORDER BY

-- 그룹함수 : SUM, AVG, MAX, MIN, COUNT
-- SUM(숫자가 기록된 컬럼명) : 합계를 구하여 리턴
SELECT 
        SUM(SALARY) AS 합계
    FROM EMPLOYEE;
    
-- AVG(숫자가 기록된 컬럼명) : 평균을 구하여 리턴
SELECT 
        AVG(SALARY) AS 평균
    FROM EMPLOYEE;
    
-- 기본평균, 중복제거평균, NULL포함 평균    
SELECT 
        AVG(BONUS) 기본평균
      , AVG(NVL(BONUS,0)) NULL포함평균
      , AVG(DISTINCT BONUS) 중복제거평균
    FROM EMPLOYEE;
    
/* MIN(컬럼명) : 컬럼에서 가장 작은 값 리턴
                취급하는 자료형은 ANY TYPE이다.
*/
SELECT 
        MIN(EMAIL) 
      , MIN(HIRE_DATE)
      , MIN(SALARY)
    FROM EMPLOYEE;

/* MAX(컬럼명) : 컬럼에서 가장 큰 값 리턴
                취급하는 자료형은 ANY TYPE이다.
*/
SELECT 
        MAX(EMAIL) 
      , MAX(HIRE_DATE)
      , MAX(SALARY)
    FROM EMPLOYEE;

-- COUNT( * | 컬럼명) : 행의 갯수를 헤아려서 리턴
-- COUNT(DISTINCT 컬럼명) : 중복을 제거한 행 갯수 리턴
-- COUNT(*) : NULL을 포함한 전체 행의 갯수 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제값이 기록된 행 갯수 리턴

SELECT 
        COUNT(*) "NULL포함 갯수"
      , COUNT(DEPT_CODE) "NULL미포함 갯수"
      , COUNT(DISTINCT DEPT_CODE) "중복제거 갯수"
    FROM EMPLOYEE;


/* 단일행 함수
    문자 관련 함수
    : LENGTH, LENGTHB->바이트, SUBSTR, UPPER, LOWER, INSTR
*/ 
SELECT
        LENGTH('오라클')
      , LENGTHB('오라클')
    FROM DUAL;
    
-- 한글이 3 바이트인걸 기억하자~
SELECT 
        LENGTH(EMAIL)
      , LENGTHB(EMAIL)
    FROM EMPLOYEE;

-- INSTR('문자열' | 컬럼명, '문자', 찾을 위치의 시작값, [빈도])
SELECT 
        EMAIL
      , INSTR(EMAIL,'@', 1) 위치
    FROM EMPLOYEE;
    
SELECT INSTR('AABAACAABBAA','B') FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',1) FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',-1) FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',-1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',1, 2) FROM DUAL;

-- LPAD / RPAD : 주어진 컬럼 문자열에 임의의 문자열을 덧붙여 길이 N의 문자열을 반환하는 함수
-- LPAD(문자열, 길이, '추가할문자') 
SELECT 
        LPAD(EMAIL, 20, '#')
    FROM EMPLOYEE;

SELECT 
        RPAD(EMAIL, 20, '#')
    FROM EMPLOYEE;

SELECT 
        LPAD(EMAIL, 10)
    FROM EMPLOYEE;
SELECT 
        RPAD(EMAIL, 10)
    FROM EMPLOYEE;

-- LTRIM / RTRIM : 주어진 컬럼이나 문자열 왼쪽/오른쪽에서 지정한 문자 혹은 문자열을 제거한 함수
SELECT LTRIM('     GREEDY') FROM DUAL;
SELECT RTRIM('  GREEDY     ') FROM DUAL;
SELECT LTRIM(RTRIM('     GREEDY       ')) FROM DUAL;

SELECT LTRIM('000012345','0') FROM DUAL;
SELECT LTRIM(RTRIM('000012345000000','0'),'0') FROM DUAL;

SELECT LTRIM('123123GREEDY123','123') FROM DUAL;
SELECT LTRIM('1223321113GREEDY123','123') FROM DUAL;
SELECT LTRIM('ACABACCGREEDY','ABC') FROM DUAL;

SELECT LTRIM('5289GREEDY','123456789') FROM DUAL;
SELECT RTRIM('12345000000', '0') FROM DUAL;
SELECT RTRIM('GREEDY5289', '123456789') FROM DUAL;
SELECT RTRIM('ACABACCGREEDYAAAAAB', 'ABC') FROM DUAL;

-- TRIM : 주어진 컬럼이나 문자열의 앞/뒤에 지정한 문자를 제거
SELECT TRIM('      GREEDY    ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZGREEDYZZZZZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZGREEDYZZZZZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZGREEDYZZZZZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZGREEDYZZZZZZZ') FROM DUAL;

-- SUBSTR : 컬럼이나 문자열에 지정한 위치로부터 지정한 갯수의 문자열을 잘라서 리턴하는 함수 
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

SELECT
        EMP_NAME
      , SUBSTR(EMP_NO, 8, 1)
    FROM EMPLOYEE;
    
-- EMPLOYEE 테이블에서 직원들이 주민번호를 조회하여 사원명, 생년, 생원, 생일을 각각 분리하여 조회
-- 컬럼 별칭은 사원명 생년 생월 생일로 한다.
SELECT
        EMP_NAME AS 사원명
      , SUBSTR(EMP_NO, 1, 2) AS 생년
      , SUBSTR(EMP_NO, 3, 2) AS 생월
      , SUBSTR(EMP_NO, 5, 2) AS 생일
    FROM EMPLOYEE;
    
-- 날짜 데이터에서 사용할 수 있다. 직원들의 입사년도, 입사월, 입사날짜를 분리조회
SELECT
        EMP_NAME AS 사원명
      , HIRE_DATE 
      , SUBSTR(HIRE_DATE, 1, 2) AS 입사년도
      , SUBSTR(HIRE_DATE, 4, 2) AS 입사월
      , SUBSTR(HIRE_DATE, 7, 2) AS 입사날짜
    FROM EMPLOYEE;
    
-- WHERE절에서 함수 사용도 가능하다.
-- 여직원들의 모든 컬럼 정보를 조회
SELECT
       *
    FROM EMPLOYEE
   WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- WHERE절에는 단일행 함수만 사용가능하다. 
SELECT 
        *
    FROM EMPLOYEE
   WHERE SALARY > AVG(SALARY); -- 그룹함수 사용하면 에러

-- 함수 중첩 사용 가능 : 함수안에서 함수를 사용할 수 있다.
-- EMPLOYEE 테이블에서 사원명, 주민번호 조회 단, 주민번호는 생년월일만 보이게 하고 '-' 다음값은 '*'로 바꿔서 출력
SELECT 
        EMP_NAME 사원명
      , RPAD(SUBSTR(EMP_NO,1 ,7), 14 ,'*') 주민번호
    FROM EMPLOYEE;
    
-- EMPLOYEE 테이블에서 사원명, 이메일,@이후를 제외한 아이디 조회
SELECT 
        EMP_NAME AS 사원명
      , EMAIL
      , SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1)
    FROM EMPLOYEE;
    
-- SUBSTRB : 바이트 단위로 추출하는 함수
SELECT 
        SUBSTR('ORACLE', 3, 2)
      , SUBSTRB('ORACLE', 3, 2)
    FROM DUAL;
    
SELECT 
        SUBSTR('오라클', 2, 2)
      , SUBSTRB('오라클', 4, 6)
    FROM DUAL;

-- LOWER / UPPER/ INITCAP : 대소문자 변경해주는 함수

-- LOWER(문자열 | 컬럼) : 소문자로 변경해주는 함수
SELECT 
        LOWER('Welcome To My World')
    FROM DUAL;

SELECT 
        UPPER('Welcome To My World')
    FROM DUAL;

-- INITCAP : 앞글자만 대문자로 변경해주는 함수
SELECT 
        INITCAP('welcome to my world')
    FROM DUAL;
    
-- CONCAT : 문자열 혹은 컬럼 두개를 입력 받아 하나로 합친 후 리턴
SELECT 
        CONCAT('가나다라', 'ABCD')
    FROM DUAL;

-- REPLACE : 컬럼 혹은 문자열을 입력받아 변경하고자 하는 문자열을 변경하려고 하는 문자열로 바꾼 후 리턴
SELECT 
        REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
    FROM DUAL;

-- 숫자 처리 함수 : ABS, MOD, ROUND, FLOOR, TRUNC, CEIL
-- ABS(숫자 | 숫자로 된 컬럼명) : 절대값 구하는 함수
SELECT 
        ABS(-10)
      , ABS(10)
    FROM DUAL;
    
/* MOD(숫자 | 숫자로 된 컬럼명, 숫자 | 숫자로 된 컬럼명)
   두수를 나누어서 나머지를 구하는 함수 
   처음 인자는 나누어지는 수, 두번째 인자는 나눌 수 
*/  
SELECT 
        MOD(10, 7)
      , MOD(10, 3)
    FROM DUAL;
    
-- ROUND(숫자 | 숫자로된 컬럼명, [위치]) : 반올림해서 리턴하는 함수
SELECT ROUND(123.56) FROM DUAL;
SELECT ROUND(123.561, 0) FROM DUAL;
SELECT ROUND(123.562, 1) FROM DUAL;
SELECT ROUND(123.569, 2) FROM DUAL;
SELECT ROUND(196.56, -2) FROM DUAL;
SELECT ROUND(186.56, -1) FROM DUAL;

-- FLOOR(숫자 | 숫자로 된 컬럼명) : 내림처리하는 함수
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.656) FROM DUAL;
SELECT FLOOR(123.456) FROM DUAL;

-- TRUNC(숫자 | 숫자로된 컬럼명, [위치]) : 내림처리(절삭)
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;
SELECT TRUNC(123.756, 2) FROM DUAL;

-- CEIL(숫자 | 숫자로 된 컬럼명) : 올림처리 함수
SELECT CEIL(123.567) FROM DUAL;
SELECT CEIL(123.367) FROM DUAL;

SELECT 
        ROUND(123.456) 반올림
      , FLOOR(123.456) 내림처리
      , TRUNC(123.456) "내림처리(절삭)"
      , CEIL(123.456) 올림
    FROM DUAL;

-- 날짜 처리 함수 : SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, EXTRACT
-- SYSDATE : 시스템에 저장되어 있는 날짜를 반환하는 함수
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(날짜, 날짜)
-- 두 날짜의 개월 수 차이를 숫자로 리턴하는 함수
SELECT 
        EMP_NAME
      , HIRE_DATE
      , CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
    FROM EMPLOYEE;
    
-- ADD_MONTHS(날짜, 숫자(개월수))
-- 날짜에 숫자만큼 개월 수 더해서 리턴
SELECT
        ADD_MONTHS(SYSDATE, 5)
    FROM DUAL;
    
-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사후 6개월이 되는 날짜를 조회
SELECT 
        EMP_NAME
      , HIRE_DATE
      , ADD_MONTHS(HIRE_DATE, 6)
    FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 근무년수가 20년이상인 직원 조회
SELECT 
        *
    FROM EMPLOYEE
--   WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;
   WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;

-- NEXT_DAY(기준날짜, 요일(문자 | 숫자)
-- 기준 날짜에서 구하려는 요일에 가장 가까운 날짜 리턴
-- 일(1),월(2),화(3),수(4),목(5),금(6),토(7)
SELECT SYSDATE, NEXT_DAY(SYSDATE, '토요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '토') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) FROM DUAL;
-- 한글버전이라서...
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;

-- 언어 설정이 변경된다.
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 구하여 리턴
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴하는 함수 
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 날짜만 추출

SELECT 
        SYSDATE
      , EXTRACT(YEAR FROM SYSDATE) 년
      , EXTRACT(MONTH FROM SYSDATE) 월
      , EXTRACT(DAY FROM SYSDATE) 일
    FROM DUAL;

-- EMPLOYEE 테이블에서 사원이름 입사년 입사월 입사일 조회
SELECT 
        EMP_NAME
      , EXTRACT(YEAR FROM HIRE_DATE) 입사년
      , EXTRACT(MONTH FROM HIRE_DATE) 입사월
      , EXTRACT(DAY FROM HIRE_DATE) 입사일
    FROM EMPLOYEE;
      
-- EMPLOYEE 테이블에서 직원의 이름, 입사일, 근무년수를 조회
-- 단, 근무년수는 현재년도 - 입사년도로 조회
SELECT 
        EMP_NAME
      , HIRE_DATE
      , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
    FROM EMPLOYEE;






      
      
      
      