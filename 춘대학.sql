--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 핚다.
SELECT 
      DEPARTMENT_NAME "학과 명"
     , CATEGORY 계열
   FROM TB_DEPARTMENT;
   
-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다
SELECT
       DEPARTMENT_NAME || '의 정원은 ' || CAPACITY ||'명입니다.' "학과정원"
   FROM TB_DEPARTMENT;

/*
    3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이
    들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서
    찾아 내도록 하자)
*/
SELECT 
       S.STUDENT_NAME 
    FROM TB_STUDENT S
   WHERE S.DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                              FROM TB_DEPARTMENT
                             WHERE DEPARTMENT_NAME = '국어국문학과'
                            )
     AND SUBSTR(S.STUDENT_SSN,8,1) = '2';    
     
/*
    4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다.
    그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
    A513079, A513090, A513091, A513110, A513119
*/

SELECT 
       S.STUDENT_NAME 
    FROM TB_STUDENT S
    WHERE S.STUDENT_NO IN('A513079','A513090','A513091','A513110','A513119');

/*
    5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.
*/

SELECT 
       D.DEPARTMENT_NAME
     , D.CATEGORY
   FROM TB_DEPARTMENT D
   WHERE D.CAPACITY BETWEEN 20 AND 30;

/*
    6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘
    기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
*/

SELECT 
       P.PROFESSOR_NAME
   FROM TB_PROFESSOR P
  WHERE P.DEPARTMENT_NO IS NULL;

/*
    7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 
    어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
*/





/*
10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이
출력되도록 하시오.
*/

SELECT
       DEPARTMENT_NO 
     , COUNT(*) "학생수(명)"
   FROM TB_STUDENT
   GROUP BY DEPARTMENT_NO
   ORDER BY DEPARTMENT_NO ;



/*
    12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단, 
    이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여
    소수점 이하 자리까지만 표시핚다.
*/










