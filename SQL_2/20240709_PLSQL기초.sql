-- 16장. PL/SQL 기초
-- ============================================================================
-- PL/SQL : Procedural Language extension to SQL (SQL을 확장한 절차적인 언어)
-- 오라클에서 PL/SQL, MS에서는 TSQL(Transact SQL), ..postgreSQL에서는 PL/pgSQL
-- ============================================================================
-- 절차 지향 언어 : 순서대로 실행~ GW BASIC, COBOL, ...
-- Java : 객체 지향 언어
-- 함수형 프로그래밍 언어 : Javascript

-- I. PL/SQL 구조
-- Block(블록) : 명령블록~ (1) 익명 블록(Anonymous Block)   (2) 명명 블록(Named Block) 
-- PL/SQL 프로그램의 기본 단위

-- DECLARE : 선언부 - 변수, 상수, 커서
-- BEGIN : 실행부
--  데이터처리나, 조작, DML등이 오는 곳 - 조건문, 반복문, SELECT, 함수..
--  EXCEPTION : 예외처리부 - 오류코드 제어
-- END;

-- ※ 보기 > DBMS 출력 창을 선택해서 꺼내어 두기


-- p.418 Hello, PL/SQL 출력하기
-- 실습16-1. 문장 출력
-- PL/SQL 프로그램 단위 : 블록

-- ※ 선언부, 예외처리부는 생략가능하지만, 실행부는 반드시 존재해야함
--SET SERVEROUTPUT ON; --SQLPLUS에서 사용
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL 1!');
    /*DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL 2!');
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL 3 !');*/
--    EXCEPTION
END;

-- =============================================================================
-- DECLARE, BEGIN, EXCEPTION 키워드에는 세미콜론(;) 사용하지 않는다.
-- PL/SQL 블럭의 각 부분(실행부)에서 문장 끝에 세미콜론(;)을 입력한다.
-- PL/SQL 내부에는 한줄 주석과 여러줄 주석(/* ... */)을 사용할 수 있다.
-- PL/SQL 문장을 마치고 실행하기 위해서 슬래쉬(/)를 사용한다 ==> SQL PLUS에서만!
-- =============================================================================


-- p.421 실습16-2. 한줄 주석 사용하기
DECLARE
    -- 변수, 상수, 커서 선언
    -- 상수는 선언과 동시에 반드시 초기화
    -- 변수명 자료형(길이) := 초깃값;
    V_EMPNO NUMBER(4) := 100;
    V_ENAME VARCHAR2(10);
BEGIN
    V_ENAME := 'SCOTT';
    /*
    DBMS_OUTPUT.PUT_LINE('V_EMPNO : ' || V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_ENAME : ' || V_ENAME1);
    */
    DBMS_OUTPUT.PUT_LINE('================== 실행 완료=================');
    -- 변수는 선언 후 실행부에서 초기화
    --EXCEPTION
END;

-- SQL에서 =: 은 바인드 변수(기호)라고 하며, PL/SQL에서 := 은 대입 연산자(=) 라고 한다.
-- 동적 SQL에서 값이 바뀌어 쿼리가 실행될때, 바인드(Bind) 되는 값에 따라서 결과값이 다르게 조회/처리됨.


-- 16-2. 변수와 상수
-- 선언부(DECLARE)에 정의
-- 초기화는 변수의 경우, 선언부와 실행부에서 가능
-- 상수는 선언부에서만 가능
-- ※ 상수는 CONSTANT 키워드를 붙여서 정의 

-- [상수] 상수이름 CONSTANT 자료형(길이) := 초깃값
-- [변수] 변수이름 자료형(길이) := 초깃값
-- ※ NOT NULL : 변수에 NULL값 저장 막기  ==> 변수이름 자료형(길이) NOT NULL := 초깃값

-- 실습16-7. 변수에 NOT NULL을 설정하고 값을 대입한 후 출력하기
DECLARE
    V_DEPTNO NUMBER(2) NOT NULL := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('V_DEPTNO : ' || V_DEPTNO);
    --EXCEPTION
END;

-- =============================================================================
-- 변수 네이밍 규칙: PL/SQL 객체 이름 식별자 --> 식별자 이름 규칙
-- 1. 같은 블럭 안에서 식별자는 고유해야 하며~ 중복될 수 없다.
-- 2. 대,소문자를 구별하지 않는다 vs 데이터베이스 개체:테이블, 뷰...대/소 구분함)
-- 3. 이름은 문자로 시작한다(한글도 가능, 숫자로 시작할 수 없다)
-- 4. 이름은 30byte이하여야 하며, 한글은 10자까지 사용가능)
-- 5. 영문자, 숫자, 특수문자($,#,_) 사용할 수 있다.
-- 6. SQL 예약어(RESERVED KEYWORD)는 사용할 수 없다 (SELECT, FROM, WHERE...)
-- =============================================================================
-- 변수의 자료형
-- 1) 스칼라(scalar) : 숫자(NUMBER), 문자(CHAR, VARCHAR2), 날짜(DATE), 논리(BOOLEAN) <-- PL/SQL 에서만 사용가능한 논리값
-- ※ 벡터(vector) : 크기와 방향을 동시에 갖는 값을 뜻함
-- 2) 복합(composite): 컬렉션, 레코드 <17장. 레코드와 컬렉션 (p.446)>
-- 3) 참조(reference) : 데이터베이스에 존재하는 특정 테이블의 열의 자료형%TYPE 또는 하나의 행 구조를 참조하는 자료형%ROWTYPE
-- 4) LOB(Large OBject):  [SQL:  CLOB, BLOB, FILE, TEXT | 2~4GB / 이상] 텍스트,동영상,이미지,사운드..



-- p.428 실습16-9. 참조형(열)의 변수에 값을 대입한 후 출력하기
-- HR 스키마(계정) 으로 변경해서 진행
DESC departments;

DECLARE
    V_DEPTNO departments.department_id%TYPE := 50;
    V_DEPTNO NUMBER(4) := 50;
BEGIN
    DBMS_OUTPUT.PUT_LINE('V_DEPTNO : ' || V_DEPTNO);
END;



-- p.429 실습16-10. 참조형(행) 변수에 값을 대입한 후 출력하기
DECLARE
    V_DEPT_ROW departments%ROWTYPE;    
BEGIN
    SELECT  department_id, department_name, manager_id, location_id INTO V_DEPT_ROW
    FROM    departments
    WHERE   department_id = 40;
    DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || V_DEPT_ROW.department_id);
    DBMS_OUTPUT.PUT_LINE('DNAME : ' || V_DEPT_ROW.department_name);
    DBMS_OUTPUT.PUT_LINE('MANGERNO : ' || V_DEPT_ROW.manager_id);
    DBMS_OUTPUT.PUT_LINE('LOCNO : ' || V_DEPT_ROW.location_id);
    --EXCEPTION
END;


-- p.431 16-3. 조건 제어문
-- 1) IF 문 : IF ~ THEN, IF ~ THEN ~ ELSE, IF ~ THEN ~ ELSIF
-- 1-1) IF ~ THEN : 단순 IF문,
-- IF 조건식 THEN
--  수행할 명령어;
-- END IF;

--p.432 실습16-11. 변수에 입력한 값이 홀수인지 알아보기(입력값이 홀수 일때)
DECLARE
    V_NUMBER NUMBER := 14;
BEGIN
    IF MOD(V_NUMBER, 2) = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('V_NUMBER는 홀수 입니다');
    END IF;
    --EXCEPTION
END;


-- p.433 실습 16-13. 변수에 입력된 값이 홀수인지 짝수인지 알아보기(입력값이 짝수일때)
DECLARE
    V_NUMBER NUMBER NOT NULL := 14;
    -- V_NUMBER NUMBER DEFAULT 14
BEGIN
    IF  MOD(V_NUMBER, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('V_NUMBER는 홀수 입니다');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('V_NUMBER는 짝수 입니다');
    END IF;
    --EXCEPTION
END;


-- p.434 실습16-14. 입력한 점수가 어느 학점인지 출력하기
-- 90점 이상 : A학점
-- 80점 이상 ~ 90점 미만 : B학점
-- ...

DECLARE
    V_SCORE NUMBER := 87;
BEGIN
    IF V_SCORE >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('A학점 입니다');
    ELSIF V_SCORE >= 80 THEN
        DBMS_OUTPUT.PUT_LINE('B학점 입니다');
    ELSIF V_SCORE >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('C학점 입니다');
    ELSIF V_SCORE >= 60 THEN
        DBMS_OUTPUT.PUT_LINE('D학점 입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('F학점 입니다');
    END IF;
    --EXCEPTION
END;



-- CASE 문
-- p.171 DECODE 함수, CASE 문(또는 표현식) : 등가비교 vs 등가비교,범위비교
-- 단순 CASE: 등가비교
-- 검색 CASE: 범위비교

-- 실습 16-15. 입력 점수에 따른 학점 출력하기(단순 CASE, 등가비교)
--  I.단순 CASE
DECLARE
    V_SCORE NUMBER := 87;
BEGIN
    CASE TRUNC(V_SCORE/10)
        WHEN 10 THEN DBMS_OUTPUT.PUT_LINE('A학점 입니다');
        WHEN 9 THEN DBMS_OUTPUT.PUT_LINE('B학점 입니다');
        WHEN 8 THEN DBMS_OUTPUT.PUT_LINE('C학점 입니다');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('D학점 입니다');
        ELSE DBMS_OUTPUT.PUT_LINE('F학점 입니다');
    END CASE;
    --EXCEPTION
END;


-- II.검색 CASE : 범위 비교 연산자, 등가비교 이외의 연산자 BETWEEN등을 사용할 수 있음
-- p.437 실습16-16. 입력 점수에 따른 학점 출력하기
DECLARE
    V_SCORE NUMBER := 87;
BEGIN
    CASE
        WHEN V_SCORE >= 90 THEN DBMS_OUTPUT.PUT_LINE('A학점 입니다');
        WHEN V_SCORE >= 80 THEN DBMS_OUTPUT.PUT_LINE('B학점 입니다');
        WHEN V_SCORE >= 70 THEN DBMS_OUTPUT.PUT_LINE('C학점 입니다');
        WHEN V_SCORE >= 60 THEN DBMS_OUTPUT.PUT_LINE('D학점 입니다');
        ELSE DBMS_OUTPUT.PUT_LINE('F학점 입니다');
    END CASE;
    --EXCEPTION
END;


-- 제어문 : 조건문(IF), 선택문(CASE), 반복문(FOR/WHILE)

-- =============================================================================
-- p.438 16-4. 반복 제어문
-- 반복문은 특정 작업을 반복하여 수행하고자 할 때 사용하며, PL/SQL에서는 
-- 1) 기본 LOOP : 반복 종료에 따른 조건을 따로 명시하지 않는 방식
-- 2) WHILE LOOP : 조건식이 true일때 반복 (거짓이면 반복 중단, 증감식이 빠지면..무한LOOP)
-- 3) FOR LOOP : 원하는 만큼 반복횟수를 지정하여 반복 수행
-- 4) Cursor FOR LOOP : < 18장.커서와 예외처리 (p.460) >
-- =============================================================================


-- 반복수행을 중단시키거나 특정 반복 주기를 건너띄는 (BREAK, CONTINUE 처럼) 명령어
-- EXIT : 수행중인 반복 종료
-- EXIT-WHEN : 조건이 일치하면 반복 종료
-- CONTINUE : 수행중인 반복 주기를 건너띔
-- CONTINUE-WHEN : 조건이 일치하면 반복 주기를 건너띔



-- p.439 실습 16-17. 기본 LOOP사용하기 
-- V_ : 접두어 ==> 타입 약어로 관례,
-- ex> nSalary , V_ : VARCHAR2 타입...
DECLARE
    V_NUM NUMBER := 0;
BEGIN
    LOOP    
        DBMS_OUTPUT.PUT_LINE('현재 V_NUM : ' || V_NUM);
        -- 일반적인 프로그래밍 언어에서는 ++, -- (증감 연산자)
        V_NUM := V_NUM + 1;
        EXIT WHEN V_NUM > 4;
    END LOOP;
    --EXCEPTION
END;


-- p.440 WHILE LOOP
-- 실습 16-18. 0부터  n까지 값을 출력
DECLARE
    V_NUM NUMBER := 0;
BEGIN
    WHILE V_NUM < 4 LOOP
        DBMS_OUTPUT.PUT_LINE('현재 V_NUM : ' || V_NUM);
        V_NUM := V_NUM + 1;
    END LOOP;
    --EXCEPTION
END;


-- p.441 FOR LOOP
-- Java      for(int i = 0; i < 10; i++) { ... }
-- PL/SQL    FOR i IN 시작값..종료값  LOOP
--              반복 수행할 명령
--           END LOOP;

-- 실습 16-19. FOR LOOP 사용하기
-- ============================================================================
-- DECLARE : 선언부는 생략할 수 있다!
--    V_NUM NUMBER := 0;
-- ※ 실행부(BEGIN ~ END)는 반드시 존재해야 한다.
-- ============================================================================
BEGIN
    FOR i IN 0..4 LOOP
        DBMS_OUTPUT.PUT_LINE('현재 i의 값 : ' || i);
    END LOOP;
    --EXCEPTION
END;



-- p.444 잊기전에 한번더

-- Q1. 1부터 10까지 숫자중 홀수만 출력하는 PL/SQL 프로그램 작성
BEGIN
    FOR i IN 1..10 LOOP
        IF MOD(i, 2) = 1 THEN
            DBMS_OUTPUT.PUT_LINE('현재 i의 값 : ' || i);
        END IF;
    END LOOP;
END;

-- Q2. DEPT 테이블의 DEPTNO와 자료형이 같은 변수 V_DEPTNO를 선언한다. 그리고 V_DEPTNO
-- 변수값에 10, 20, 30, 40을 대입했을 때 다음과 같이 부서이름을 출력하는 프로그램을 작성한다
-- 단, 부서번호가 10,20,30,40이 아니면 N/A로 출력한다.
-- ※ Not Available, No Answer..를 줄여서 N/A (해당사항 없음)

-- HR 계정으로 ==> DEPT 테이블이 아닌 departments 테이블을 참조!
-- %TYPE : 특정 열 참조 타입
-- %ROWTYPE : 특정 행(=열 전체)
-- INTO 절 (INTO 키워드)
DECLARE
    V_DEPTNO departments.department_id%TYPE;
    V_DNAME departments.department_name%TYPE;
BEGIN
    FOR i IN 1..4 LOOP
        V_DEPTNO := i * 10;
        SELECT department_name INTO V_DNAME
        FROM    departments
        WHERE   department_id = V_DEPTNO;
        DBMS_OUTPUT.PUT_LINE(V_DEPTNO || '번 부서 이름 : ' || V_DNAME);
    END LOOP;
    --EXCEPTION
END;

-- =============================================================================
-- 17-1. 레코드 : 자료형이 다른 여러 데이터를 저장하는 자료형(p.446)
-- =============================================================================
-- ※ 다른 변수처럼 레코드를 사용할 수 있는데, 레코드에 포함된 변수는 이름과 마침표(.)로
--   사용할 수 있다.
-- TYPE 레코드 이름 IS RECORD(
--    변수이름 자료형 [NOT NULL] := 값 또는 값이 도출되는 표현식
-- )

-- p.447 실습 17-1. 레코드 정의해서 사용
DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno departments.department_id%TYPE,
        dname  departments.department_name%TYPE,
        mgr    departments.manager_id%TYPE,
        loc    departments.location_id%TYPE
    );
    dept_rec REC_DEPT;
BEGIN
    dept_rec.deptno := 280;
    dept_rec.dname  := 'DEVELOPMENT';
    dept_rec.mgr := 100;
    dept_rec.loc := 1500;
    
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || dept_rec.deptno);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || dept_rec.dname);
    DBMS_OUTPUT.PUT_LINE('담당매니저 : ' || dept_rec.mgr);
    DBMS_OUTPUT.PUT_LINE('부서위치 : ' || dept_rec.loc);
    --EXCEPTION
END;


-- p.447 실습17-2. 레코드를 사용한 INSERT
-- 사원/부서 새롭게 등록하는 업무(INSERT)
-- hanul 계정으로 실습

-- 1) CTAS : DEPT_RECORD 테이블을 HR의 부서테이블을 참조해서
CREATE TABLE dept_record  AS
SELECT *
FROM    hr.departments;
-- Table DEPT_RECORD이(가) 생성되었습니다.

-- 2) 데이터 확인
SELECT *
FROM dept_record;

DESC dept_record;

--이름              널?       유형           
----------------- -------- ------------ 
--DEPARTMENT_ID            NUMBER(4)    
--DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
--MANAGER_ID               NUMBER(6)    
--LOCATION_ID              NUMBER(4) 

-- 3) 레코드를 생성, 데이터를 처리

DECLARE
    TYPE REC_DEPT IS RECORD (
        dept_id dept_record.department_id%TYPE,
        dname dept_record.department_name%TYPE,
        mgr_id dept_record.manager_id%TYPE,
        loc_id dept_record.location_id%TYPE
    );
    dept_rec REC_DEPT;
BEGIN
    -- 레코드 변수 초기화
    dept_rec.dept_id := 290;
    dept_rec.dname := 'Ai Analysis';
    dept_rec.mgr_id := NULL;
    dept_rec.loc_id := 1800;
    
    -- DML : 테이블에 데이터를 입력
    INSERT INTO dept_record
    VALUES dept_rec;
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('에러 발생, 확인하세요!');
        ROLLBACK;
END;

-- 4) 입력된 데이터를 확인
SELECT *
FROM    dept_record;

ROLLBACK;


-- p.449 실습17-4. 레코드를 사용한 UPDATE
-- 인사이동/보직변경 관련 업무 ==> 명령 블록으로 작성 ===> 프로시저, 함수로 구현

DECLARE
    TYPE REC_DEPT IS RECORD (
        dept_id dept_record.department_id%TYPE,
        dname dept_record.department_name%TYPE,
        mgr_id dept_record.manager_id%TYPE,
        loc_id dept_record.location_id%TYPE
    );
    dept_rec REC_DEPT;
BEGIN
    dept_rec.dept_id := 300;
    dept_rec.dname := 'Research/Development';
    dept_rec.mgr_id := NULL;
    dept_rec.loc_id := 1500;
    
    UPDATE dept_record
    SET ROW = dept_rec
    WHERE department_id = 290;
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외발생, 확인하세요!');
        ROLLBACK;    
    --EXCEPTION
END;

-- 데이터 확인
SELECT *
FROM    dept_record;


-- =============================================================================
-- 17-2. 컬렉션 : 자료형이 같은 데이터를 저장하는 자료형 (p.452) ==> 배열(Array)
-- 1. VARRAY(Variable-size Array) : 고정 크기 배열
-- 2. 중첩테이블(Nested Table) : 가변 크기 배열
-- 3. 연관배열(Associative Array) : 연관배열(key-value) ★: 사용 빈도가 가장높음
-- ※ 배열 : 나누다 + 열거하다 ==> 메모리 공간을 나누어 여러 데이터를 저장
-- 배열[인덱스번호] --> 데이터 접근, [VARRAY, 중첩배열]
-- 배열(키:숫자, 문자) --> 데이터 접근 [연관배열]
-- =============================================================================
-- 연관배열 기본형식
TYPE 연관배열이름 IS TABLE OF 자료형 [NOT NULL]
INDEX BY 인덱스형; -- BINARY_INTEGER, PLS_INTEGER: 정수타입, VARCHAR2: 문자타입

-- ※ 속도차이 존재하고, 가장 빠른게 성능상 PLS_INTEGER;
-- ※ 연관배열이 레코드와 마찬가지로, 특정 변수의 자료형으로 사용

-- 실습17-6. 연관배열 사용하기

DECLARE
    -- 선언부: 여러가지 자료형, 변수 선언, 상수, 커서..
    -- 연관배열(Associative Array, Index Table, EX : Example)
    TYPE ITAB_EX IS TABLE OF VARCHAR2(20)
    INDEX BY VARCHAR2(1); -- 인덱스 : 정수자료형 (1), (2), .. 또는 문자타입의 경우 (길이)를 지정
    
    text_arr ITAB_EX;
BEGIN
    text_arr('a') := '1st data';
    text_arr('b') := '2nd data';
    text_arr('c') := '3rd data';
    text_arr('d') := '4th data';
    
    DBMS_OUTPUT.PUT_LINE('text_arr(1) : ' || text_arr('a'));
    DBMS_OUTPUT.PUT_LINE('text_arr(2) : ' || text_arr('b'));
    DBMS_OUTPUT.PUT_LINE('text_arr(3) : ' || text_arr('c'));
    DBMS_OUTPUT.PUT_LINE('text_arr(4) : ' || text_arr('d'));
    -- EXCEPTION
END;


-- 레코드를 이용한 연관배열
-- 레코드 : 데이터 타입이 각기 다른 자료형  vs 컬렉션 : VARRAY, 중첩테이블, 연관배열
-- DEPT_DDL 
SELECT *
FROM dept_ddl;

-- 실습 17-7. 연관 배열 자료형에 레코드 사용하기
DECLARE
    -- 레코드 선언
    TYPE REC_DEPT IS RECORD (
        deptno DEPT_DDL.department_id%TYPE,
        dname DEPT_DDL.department_name%TYPE
    );
    -- 연관배열
    TYPE ITAB_DEPT IS TABLE OF REC_DEPT
    INDEX BY PLS_INTEGER;
    
    -- 변수, 자료형
    dept_arr ITAB_DEPT;
    idx PLS_INTEGER := 0;
BEGIN
    -- (암시적:PL/SQL엔진이 생성하는) 커서 FOR LOOP 구문 : 17장, 커서와 예외처리 
--    DBMS_OUTPUT.PUT_LINE('==============================================');
--    DBMS_OUTPUT.PUT_LINE('deptno' || CHR(9) || ' dname ');
--    DBMS_OUTPUT.PUT_LINE('==============================================');

    FOR i IN (SELECT department_id, department_name FROM dept_ddl) LOOP
    --데이터 접근 : 배열명.키
    idx := idx + 1;
    dept_arr(idx).deptno := i.department_id;
    dept_arr(idx).dname := i.department_name;
    DBMS_OUTPUT.PUT_LINE(dept_arr(idx).deptno || ' : ' || dept_arr(idx).dname);
    END LOOP;
    --EXCEPTION
END;


-- 실습 17-8. %ROWTYPE으로 연관배열 자료형 지정하기
CREATE TABLE dept_ddl2 AS
SELECT department_id AS deptno,
       department_name AS dname
FROM    hr.departments;       

SELECT *
FROM dept_ddl2;


-- ============================================================================
-- %ROWTYPE : 테이블의 전체 행 구조를 참조 (컬럼 갯수, 컬럼 이름을 그대로 사용)
-- ============================================================================
DECLARE
    -- 연관배열
    TYPE ITAB_DEPT IS TABLE OF DEPT_DDL%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    -- 변수, 자료형
    dept_arr ITAB_DEPT;
    idx PLS_INTEGER := 0;
BEGIN
    FOR i IN (SELECT * FROM DEPT_DDL) LOOP
        idx := idx + 1;
        dept_arr(idx).department_id := i.department_id;
        dept_arr(idx).department_name := i.department_name;
        dept_arr(idx).location_id := i.location_id;
        DBMS_OUTPUT.PUT_LINE(dept_arr(idx).department_id || ' : ' || dept_arr(idx).department_name || ' : ' || dept_arr(idx).location_id);
        
        -- 17.9 컬렉션 메소드 
    END LOOP;
    --EXCEPTION
END;
-- =============================================================================
-- PL/SQL 메소드 : 다른 언어의 배열(Array)에서 제공하는 메소드처럼, PL/SQL도 몇가지
-- 메소드를 제공한다 (데이터 조회, 삭제, 크기 조절을 위한 특정 조작)
-- ex> 자바스크립트 배열.length : 프로퍼티, 배열.sort() : 메소드
-- =============================================================================



-- 18.커서와 예외처리

-- 18-1. 커서(CURSOR) : SQL 문을 처리하는 정보를(=결과) 저장한 메모리 공간 (C언어 --> 포인터)
-- ※ Private SQL Area : 메모리 공간 

-- 18-1-1. 암(묵)시적 커서 : PL/SQL 엔진이 자동으로 생성, 메모리에 로드 --> 접근할 수 있게
-- SELECT INTO : SQL 실행 결과가 단 하나의 행 일때

-- 실습18-1. 부서 테이블의 40번 부서에 해당하는 데이터를 조회 (40번 부서 이름, 부서의 위치 코드)

SELECT *
FROM    dept_ddl
WHERE   deptno = 30;

DECLARE
    V_DEPT dept_ddl%ROWTYPE; -- deptno, dname
BEGIN
    SELECT * INTO V_DEPT
    FROM    dept_ddl
    WHERE   department_id = 40;
    
    DBMS_OUTPUT.PUT_LINE('deptno : ' || V_DEPT.department_id);
    DBMS_OUTPUT.PUT_LINE('dname : ' || V_DEPT.department_name);
    DBMS_OUTPUT.PUT_LINE('loc : ' || V_DEPT.location_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('===== 예외 발생, 확인하세요 =======');
END;






-- 18-1-2. 명시적 커서 : 커서를 개발자,DBA 가 정의하고 메모리에 로드 --> 커서 이름을 기준으로 접근
--                       ※ 커서에 담긴 결과행의 갯수가 많으면 FOR LOOP을 사용해 반복/순회
-- 커서 FOR LOOP : SQL 처리 결과가 여러개일때
-- I. 커서 선언 : (선언부에) 커서 이름, SQL문장을 함께 정의
-- II. 커서 열기 : OPEN, 커서를 사용할때
-- III. 데이터 읽기 : FETCH, SQL 문장의 실행 결과를 하나씩 읽어와서 변수에 저장한 후 필요한 작업(명령)
-- IV. 커서 닫기 : CLOSE, 모든 커서의 결과행 사용이 끝나면 커서를 종료

-- 명시적 커서 기본형식
DECLARE
    CURSOR 커서명 IS 
    SQL문장;
BEGIN
    OPEN 커서명;
    FETCH 커서명 INTO 변수;
    -- 수행할 작업을 나열
    CLOSE 커서명;
    --EXCEPTION
END;


-- 명시적커서 / 단일 행 데이터가 조회되는 경우
-- 실습18-2.단일 행 데이터를 저장하는 커서
DECLARE
    CURSOR c1 IS
    SELECT *
    FROM    dept_ddl2
    WHERE   deptno = 40;
    
    V_DEPT dept_ddl2%ROWTYPE;
BEGIN
    OPEN c1;
    FETCH c1 INTO V_DEPT;
    DBMS_OUTPUT.PUT_LINE('================================');    
    DBMS_OUTPUT.PUT_LINE('부서번호' || CHR(9) || '부서이름');       
    DBMS_OUTPUT.PUT_LINE('================================');    
    DBMS_OUTPUT.PUT_LINE(V_DEPT.deptno || CHR(9) || V_DEPT.dname);    
    CLOSE c1;
END;

-- 명시적커서 / 여러 행이 조회되는 경우 ==> LOOP 사용
-- 실습18-3.커서 FOR LOOP

DECLARE
    CURSOR c1 IS
    SELECT  *
    FROM    dept_ddl;
    --변수 자료형;
BEGIN
    -- OPEN 커서명;
    -- FETCH 커서명 INTO 변수; : 조회된 결과행이 하나일때
    -- CLOSE 커서명;
    
    -- 커서 FOR LOOP 시작 (자동 OPEN, FETCH, CLOSE)
    DBMS_OUTPUT.PUT_LINE('================================');    
    DBMS_OUTPUT.PUT_LINE('no' || CHR(9) || 'name' || CHR(9) || 'loc');       
    DBMS_OUTPUT.PUT_LINE('================================');  
    FOR c1_rec IN c1 LOOP    
        DBMS_OUTPUT.PUT_LINE(c1_rec.department_id || CHR(9) || c1_rec.department_name || CHR(9) || c1_rec.location_id);
    END LOOP;
    
    --EXCEPTION
END;


-- 커서에 파라미터 사용하기 : 고정값이 아닌 직접 입력한 값 또는 상황에 따라 여러 값을 번갈아 사용할때
CURSOR 커서이름(파라미터명 자료형,...) IS
SQL 문장;

-- 실습18-5. 파라미터를 이용하는 커서 알아보기

DECLARE
    CURSOR c1 (p_deptno dept_ddl2.deptno%TYPE) IS
    SELECT *
    FROM    dept_ddl2
    WHERE   deptno = p_deptno;
    V_DEPT_ROW dept_ddl2%ROWTYPE;
BEGIN
    OPEN c1(10);
    FETCH c1 INTO V_DEPT_ROW;
        DBMS_OUTPUT.PUT_LINE('================================');    
        DBMS_OUTPUT.PUT_LINE('no' || CHR(9) || 'name');       
        DBMS_OUTPUT.PUT_LINE('================================');  
        DBMS_OUTPUT.PUT_LINE(V_DEPT_ROW.deptno || CHR(9) || V_DEPT_ROW.dname);
    CLOSE c1;
    
    OPEN c1(20);
    FETCH c1 INTO V_DEPT_ROW;
        DBMS_OUTPUT.PUT_LINE('================================');    
        DBMS_OUTPUT.PUT_LINE('no' || CHR(9) || 'name');       
        DBMS_OUTPUT.PUT_LINE('================================');  
        DBMS_OUTPUT.PUT_LINE(V_DEPT_ROW.deptno || CHR(9) || V_DEPT_ROW.dname);
    CLOSE c1;
    --EXCEPTION
END;


-- 커서에 파라미터 값을 사용자에게 입력받는 & 기호, 치환변수 사용하기
--

DECLARE
    CURSOR c1 (p_deptno dept_ddl2.deptno%TYPE) IS
    SELECT *
    FROM    dept_ddl2
    WHERE   deptno = p_deptno;
    -- 사용자가 입력할 부서번호를 저장하는 변수
    v_deptno dept_ddl2.deptno%TYPE;

BEGIN
    -- &사용자입력변수    
    -- 커서 FOR LOOP 시작, c1 커서에 v_deptno를 대입
    v_deptno := &INPUT_DEPTNO;
    DBMS_OUTPUT.PUT_LINE('================================');    
    DBMS_OUTPUT.PUT_LINE('no' || CHR(9) || 'name');       
    DBMS_OUTPUT.PUT_LINE('================================'); 
    FOR c1_rec IN c1(v_deptno) LOOP
        DBMS_OUTPUT.PUT_LINE(c1_rec.deptno || CHR(9) || c1_rec.dname);
    END LOOP;
END;



-- 18-2. 예외처리(EXCEPTION) : try ~ catch ~ finally
-- 오류 (error) : SQL 또는 PL/SQL이 정상적으로 수행되지 못하는 상황 [문법오류, 런타임 오류]
-- ※ 오라클에서는 런타임오류 ==> 예외처리 , EXCEPTION

-- 실습18-9. 예외처리 PL/SQL 추가
DECLARE
    v_wrong NUMBER; -- Type Missmatch ==> 오류 발생 ==> 예외 처리 필요!
BEGIN
    SELECT  dname   INTO v_wrong --Aministration
    FROM    dept_ddl2
    WHERE   deptno = 10;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('예외 발생: 수치 또는 값 오류 발생!');
--        WHEN OTHERS THEN
--            DBMS_OUTPUT.PUT_LINE('예외 발생: 알수 없는 이유로 오류 발생!');
END;
-- 18-2-1. 시스템 오류 ==> 사전 정의된 예외 , 이름이 없는 예외
-- 18-2-2. 사용자 오류 ==> 개발자가 직접 정의한 예외

-- =============================================================================
-- ↑↑ PL/SQL 익명 블록(Anonynous Block) - 일회성
-- ↓↓ PL/SQL 명명 블록(Named Block) - 다회성 ===> 함수/메소드★
-- =============================================================================
-- 19.서브프로그램

-- 1) 프로시저 : 특정 처리 작업 수행을 위한 서브프로그램, SQL문에서는 사용 불가
-- 2) 함수 : 특정 연산을 처리한 결과값을 반환하는 서브프로그램, SQL에서 사용가능
-- 3) 패키지: 서브프로그램을 그룹화 하는데 사용함
-- 4) 트리거 : 특정 상황(Event)이 발생할때 자동으로 연달아 수행할 기능을 구현

-- 익명 블록 : 오라클에 저장이 안됨 ==> 필요할때마다 작성 ==> 반복되는 작업에서는 비효율적인 과정
-- 명명 블록 or 서브프로그램 ==> 저장이 됨 ==> 데이터베이스 객체 (함수, 프로시저)
-- ※ 함수(FUNCTION) : 반드시 RETURN 값이 존재, 프로시저(PROCEDURE) : RETURN이 없음

SELECT SUM(salary)
FROM hr.employees;

EXEC MOVE_EMP(emp_id, new_dept_id); -- emp_id 사원을 new_dept_id 부서로 이동하라는 프로시저
EXECUTE MOVE_EMP(10, 100); -- 10번 사원을 100번 부서로 옮겨 (DML - UPDATE 문장)


-- 19-2. 프로시저 : 특정 처리 작업을 수행하는 용도, 파라미터를 사용할수도 있고 사용하지 않을수도 있음.
-- 뷰 (VIEW): 임시성 테이블( 테이블 처럼 조회, 입력/수정/삭제하지 않게 READ ONLY)
--프로시저
CREATE [OR REPLACE] PROCEDURE 프로시저명 IS[AS]
선언부 : 변수, 상수, 커서
BEGIN
    DML --신인사원 등록, 부서이동 업무에 관한 처리로직
    EXCEPTION --예외처리, 문제 발생시 ROLLBACK;
END;

--프로시저 호출(=실행)
EXECUTE 프로시저명;
EXEC 프로시저명;

-- 프로시저 삭제
DROP PROCEDURE 프로시저명;

--실습 19-1. 파라미터가 없는 프로시저 생성
CREATE OR REPLACE PROCEDURE pro_noparam 
IS
    V_EMPNO NUMBER(4) := 7788;
    V_ENAME VARCHAR2(10);

BEGIN
    V_ENAME := 'SCOTT';
    DBMS_OUTPUT.PUT_LINE('V_EMPNO : ' || V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_ENAME : ' || V_ENAME);
END;

DROP PROCEDURE PRO_NOPARAM;

EXEC pro_noparam;


-- 프로시저 정보 조회
SELECT TEXT
FROM user_source;

--p. 487 파라미터를 사용하는 프로시저

-- IN 모드 : 기본값, 프로시저를 호출할때 값을 입력받는다
-- OUT 모드 : 프로시저를 호출할때 값을 반환한다.
-- IN OUT 모드 : 프로시저를 호출할때 값을 입력받고, 실행결과를 반환한다.
-- ex>
-- 신입사원 등록 ==> 이름, 급여, 직책/직무 + [오늘날짜] -- 등록일은 SYSDATE 처리
-- 부서이동 ==> EXEC 부서이동(사번, 이동할부서, 직책)
-- 퇴사 처리 ==> EXEC 퇴사명령(사번)
-- 신규 부서등록 ==> EXEC 부서등록(부서명)
-- 부서 정보변경 ==> EXEC 부서정보변경(부서번호, 매니저번호, 위치코드);


-- ===================================================================
-- 1) IN 모드 파라미터
-- ===================================================================
-- 실습 19-7. 프로시저에 파라미터 지정하기
CREATE OR REPLACE PROCEDURE pro_param 

    (
        param1 NUMBER,
        param2 NUMBER,
        param3 NUMBER := 3,
        param4 NUMBER DEFAULT 4
    )
    IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('param1 : ' || param1);
    DBMS_OUTPUT.PUT_LINE('param2 : ' || param2);
    DBMS_OUTPUT.PUT_LINE('param3 : ' || param3);
    DBMS_OUTPUT.PUT_LINE('param4 : ' || param4);
END;

EXEC pro_param(1,2,9,8);

EXEC pro_param(1,2); --최소 2개, 나머지 2개는 초깃값 또는 기본값 

EXEC pro_param(1); 

-- ORA-06550: 줄 1, 열74:PLS-00306: 'PRO_PARAM' 호출 시 인수의 갯수나 유형이 잘못되었습니다
-- ※ 기본값이 지정된 파라미터와 지정되지 않은 파라미터의 순서가 섞여 있다면, 기본값이 지정되지 않는
-- 파라미터까지 값을 입력해 주어야 한다.


--p.490. 파라미터의 종류나 갯수가 많아지면 불편, =>[JS: 화살표 함수] 사용해서 파라미터 이름에
-- 값을 직접 대입하는 방식도 있다.
EXEC pro_param(param1 => 10, param2 => 20);

-- 프로시저는 반환값 x <----> OUT 모드로 가능!
-- 함수(FUNCTION)는 반드시 반환값 존재


--p.490 OUT 모드 파라미터 정의하기
-- 실습 19-12. 사원의 번호를 입력받아 사원의 이름, 사원의 급여를 출력하는 프로시저
CREATE OR REPLACE PROCEDURE emp_info 
    ( in_empno IN emp_ddl_30.employee_id%TYPE,
      out_ename OUT emp_ddl_30.first_name%TYPE,
      out_sal OUT emp_ddl_30.salary%TYPE   
    )
    IS
BEGIN
    --select, dml ==> commit or rollback
    SELECT  first_name, salary INTO out_ename, out_sal
    FROM    emp_ddl_30
    WHERE   employee_id = in_empno;
    
END;

-- EXEC emp_info(114);
-- ORA-06550: 줄 1, 열74:PLS-00306: 'EMP_INFO' 호출 시 인수의 갯수나 유형이 잘못되었습니다

-- 실습 19-13. 익명 블록에서 out 모드 파라미터 프로시저 사용
DECLARE
    v_ename emp_ddl_30.first_name%TYPE;
    v_sal emp_ddl_30.salary%TYPE;
BEGIN
    emp_info(114, v_ename, v_sal);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || v_sal);
END;

--19-3. 함수(FUNCTION)
-- 함수 : 내장 함수(Built-in Function, 숫자함수/문자함수/날짜함수/변환함수/그룹함수/분석함수)
--        사용자정의함수(User defined Function)

--          함수      vs          프로시저 차이
--호출    SQL문장               EXEC 프로시저명, begin~ end 사이
-- 파라미터   o                         o
-- 값의반환  필수                     선택

--함수 기본형식
CREATE OR REPLACE FUNCTION 함수명 (
    param1 자료형1,
    param2 자료형2,
    ..계속..
) RETURN 자료형
BEGIN
    --EXCEPTION
END;

-- 실습 19-19. 세후 급여 계산 함수 정의
CREATE OR REPLACE FUNCTION func_aftertax (
    sal NUMBER
)
RETURN NUMBER
IS
tax NUMBER := 0.05; --5% 세율
BEGIN
    -- 세후 급여 = 지급받은 급여 - (지급받은 급여 * 5%)
    RETURN ROUND(sal - (sal * tax));
END;
--함수는 SQL 문장에서 사용할 수 있다.

SELECT SUM(salary), AVG(salary)
FROM    emp_ddl_30;

SELECT employee_id, first_name, salary AS 세전급여, func_aftertax(salary) AS 세후급여,
        TO_CHAR(salary * 12, '999,999')AS 연봉
FROM    emp_ddl_30;

-- 함수 객체 삭제
-- DROP FUNCTION 함수명;

-- HR 신규 사원 등록 : 테이블 데이터 등록
-- 트리거 실행 ==> 업무 이력 테이블(JOB_HISTORY)를 업데이트

--p.508 예를들어 어떤 테이블의 데이터를 특정 사용자가 변경 ===> 해당 데이터나 사용자 기록을 상황에 따라 막거나,
-- 관리자에게 업무 메일을 보내거 하는 기능을 구현
-- 1) 데이터와 연관된 여러 작업을 일일이 실행하는 번거로움을 줄일 수 있다 ==> 이벤트 발생시 자동실행 ==> 간편한 업무처리
-- 2) 제약조건만으로 되지 않는 경우 구현이 어렵거나 불가능한 더 복잡한 데이터 규칙을 처리할 수 있음
-- 3) 데이터 변경과 관련된 일련의 정보를 기록해둘수 있어서 데이터 보안과 안정성 그리고 문제 발생시 대처능력을 높일수 있다.

-- ※ 트리거는 특정 작업 또는 이벤트 발생에 따라 추가 작업을 진행 ==> 무분별하게 사용하면 데이터베이스 성능이 저하될수 있다.

-- DML 트리거
-- FUNC..
-- PRO..
-- TRIG..
CREATE OR REPLACE TRIGGER 트리거 이름
BEFORE | AFTER
INSERT | UPDATE | DELETE ON 대상 테이블 이름
REFERENCE OLD as old | New as new
FOR EACH ROW WHEN 조건식
FOLLOWS 트리거2, 트리거3,...
ENABLE | DISABLE

DECLARE
-- 선언부
BEGIN
-- 실행부
-- EXCEPTION : 예외처리부
END;



SELECT *
FROM    employees;

DESC employees;

select *
from    job_history;

update employees
set job_id = 'SA_MAN',
    department_id = 80
where   employee_id = 318;    


-- P.510. 실습 19-31. EMP_TRG 테이블을 CTAS 문법으로 복사/생성
CREATE TABLE emp_trg AS
SELECT *
FROM    hr.employees;
-- Table EMP_TRG이(가) 생성되었습니다.
select *
from    emp_trg;

-- 실습 19-32. 주말에 데이터 입력/수정/삭제를 금지하는 트리거 | 작업은 주중에만 할 수 있도록...
-- 예외발생 : raise_application_error(-20000, '예외 내용') : 시스템 예외를 호출
CREATE OR REPLACE TRIGGER trg_emp_nodml_weekend
BEFORE 
INSERT OR UPDATE OR DELETE ON emp_trg
BEGIN
    IF TO_CHAR(SYSDATE, 'DY') IN ('토', '일', 'SAT', 'SUN') THEN
        IF INSERTING THEN 
            raise_application_error(-20000, '주말 사원정보 추가 불가');
        ELSIF UPDATING THEN
            raise_application_error(-20001, '주말 사원정보 수정 불가');
        ELSIF DELETING THEN
           raise_application_error(-20002, '주말 사원정보 삭제 불가');
        ELSE
           raise_application_error(-20003, '주말 사원정보 변경 불가');
           END IF;
    END IF;
END;

--데이터 입력/변경/삭제 되면, 시스템의 날짜 바꿔서 재시도! (인터넷 날짜 VS 시스템 날짜)

--Trigger TRG_EMP_NODML_WEEKEND이(가) 컴파일되었습니다

INSERT INTO emp_trg ( employee_id, last_name, email, hire_date, job_id)
VALUES (400, 'KIM', 'HYEONJUN', SYSDATE, 'SA_MAN');

select *
from emp_trg;


