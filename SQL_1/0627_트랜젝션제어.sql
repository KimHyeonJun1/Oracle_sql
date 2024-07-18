--11장. 트랜잭션 제어와 세션

-- I. 트랜잭션 : 거래
-- 데이터베이스 에서는 트랜잭션은 모두 수행되거나 모두 수행되지 않는 상태 (ALL Or NOTHING)

--2). 트랜잭션 제어 언어 (TCL)
-- 2-1) ROLLBACK : 취소
-- 2-2) COMMIT : 확정
-- ※ 트랜잭션은 SCOTT 같은 데이터베이스 계정을 통해, 접속하는 동시에 시작됩니다.
-- 트랜잭션이 종료되기 전까지 (A라는 계정을 국내, 해외에서 접속한다고 하면?)

-- p. 294 트랜잭션 제어하는 명령어 실습
-- 하나의 트랜잭션에 묶여 있는 데이터 조작어(DML) 수행 상태는 모든 명령어가 정상적으로 수행완료된 상태 또는
-- 모든 명령어가 수행되지 않아 취소된 상태 두가지로만 존재할 수 있습니다.
-- 모두 적용 ==> 데이터 수정 확정 : COMMIT
-- 모두 취소 ==> 데이터 수정 취소 : ROLLBACK

--p. 294 실습 11-1. DEPT 테이블을 복사해서 DEPT_TCL 테이블 만들기
-- CTAS : CREATE TABLE 테이블명 AS SELECT 이하 문장
-- 1) 구조와 데이터 복사
-- 2) 구조만 복사 : WHERE 조건절을 거짓으로~~!

CREATE TABLE dept_tcl AS
SELECT *
FROM    hr.departments
WHERE   department_id BETWEEN 10 AND 40;

--실습 11-2. 테이블 데이터 입력/수정/삭제하기
INSERT INTO dept_tcl
VALUES (50, 'DATABASE', NULL, 1800);

SELECT *
FROM    dept_tcl;

UPDATE dept_tcl
SET manager_id = 100
WHERE   department_id = 50;

DELETE FROM dept_tcl
WHERE   department_id = 50;

COMMIT;

SELECT *
FROM    dept_tcl;


-- p.296 실무에서 COMMIT을 잘못 실행해서 낭패를 보는 상황이 꽤 자주 발생 ==> UPDATE, DELETE를 잘못 작성해서
-- 실수로 데이터를 몇만건, 몇십만건 이상 날려버리는 상황
-- 1) SELECT로 먼저 해당되는 데이터를 확인하는 습관
-- 2) 백업된 DB로 복구(며칠 전, 몇달전으로 되돌아갈 수 있음)
-- ※ COMMIT은 트랜잭션 작업이 정상적으로 수행되었다고 확실할때 사용합니다.

--p.297 SAVEPOINT
-- 작업을 취소할 지점을 지정하는 명령
-- SAVEPOINT 포인트명;
SELECT *
FROM    dept_tcl;

SAVEPOINT p1; -- point1

INSERT INTO dept_tcl
VALUES (55, 'DEVELOPMENT', NULL, 1700);

SAVEPOINT p2;

UPDATE  dept_tcl
SET manager_id = 200
WHERE   department_id = 55;

SAVEPOINT p3;

ROLLBACK TO SAVEPOINT p2;

COMMIT;
--p.303 LOCK (수정중인 데이터의 접근을 막는다)
