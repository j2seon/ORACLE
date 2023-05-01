-- TCL(Transaction Controll Language)
-- 트렌젝션 제어 언어
-- COMMIT과 ROLLBACK이 있다.

-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말한다.
-- 논리적 작업 단위라고도 하며
-- 하나의 트랜잭션으로 이루어진 작업은 반드시 한꺼번에 완료 (COMMIT)
-- 되어야하며, 그렇지 않은 경우 한번에 취소(ROLLBACK) 되어야한다.

-- ATM기기 연결

-- 1. 카드를 삽입
-- 2. 메뉴 선택(인출)
-- 3. 금액 확인, 비밀번호 인증
-- 4. 금액입력
-- 5. 인출구에서 현금 수령
-- 6. 카드 받기 
-- 7. 명세표 받기

-- COMMIT 트랜잭션 작업이 정상완료되면 변경내용을 영구히 저장
-- ROLLBACK : 트랜잭션 작업을 취소하고 최근 COMMIT한 시점으로 이동
-- SAVEPOINT 세이브포인트명 : 현재 트랜잭션 작업 시점에 이름을 정해준다. 하나의 트랜잭션 안에 구역을 나눈다.
-- ROLLBACK TO 세이브포인트명 : 트랜잭션 작업을 취소하고 SAVEPOINT 시점으로 이동

CREATE TABLE TBL_USER(
     USERNO NUMBER PRIMARY KEY,
     ID VARCHAR2(20) UNIQUE,
     PASSWORD CHAR(20) NOT NULL
);

SELECT * FROM V$TRANSACTION;

INSERT
  INTO TBL_USER A
(
  A.USERNO
, A.ID
, A.PASSWORD
)
VALUES(
  1
, 'TEST1'
, 'PASS1'
);


INSERT
  INTO TBL_USER A
(
  A.USERNO
, A.ID
, A.PASSWORD
)
VALUES(
  2
, 'TEST2'
, 'PASS2'
);

INSERT
  INTO TBL_USER A
(
  A.USERNO
, A.ID
, A.PASSWORD
)
VALUES(
  3
, 'TEST3'
, 'PASS3'
);

INSERT
  INTO TBL_USER A
(
  A.USERNO
, A.ID
, A.PASSWORD
)
VALUES(
  4
, 'TEST4'
, 'PASS4'
);

SELECT 
      *
   FROM TBL_USER;
ROLLBACK;

SAVEPOINT SP1;

INSERT
  INTO TBL_USER A
(
  A.USERNO
, A.ID
, A.PASSWORD
)
VALUES(
  5
, 'TEST5'
, 'PASS5'
);

ROLLBACK TO SP1;
ROLLBACK;

