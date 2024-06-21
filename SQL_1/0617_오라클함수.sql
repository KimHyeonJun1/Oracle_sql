-- 06. 데이터 처리와 가공을 위한 함수
-- 빌트인(내장객체) 함수 (=메소드)
-- 사용자 함수? ==> PL/SQL PART | 교재 p.419
-- PL/SQL ==> Procedural Language extension to SQL : SQL을 확장한 절차적인 언어(=SQL + 프로그래밍 언어의 문법)

-- ※ 함수는? 오라클에서는 연산자만으로 다루기 어려운 복작합 데이터 처리(ex.NULL은 비교/연산도 안됨)로
-- 다양한 결과를 얻기위해 함수를 제공함

SELECT  employee_id, first_name, salary, salary * commission_pct AS comm, salary * 12 + salary * commission_pct AS total
FROM    employees;










-- ================================================================
-- p.128 오라클 함수 (★ : 실무에서 자주 사용)
-- ================================================================
-- 06-1. 함수 정의, 함수 사용에 따른 (결과)구분
-- 함수란? 수학에서 정의한 개념, 입력한 값을 어떠한 ㅓ리를 해서 출력하는 일종의 블랙박스
-- 1) 단일 행 함수 ★ : 함수 실행 결과가, 행이(row) 1개
-- 2) 다중 행 함수 : 함수 실행 결과가, 행이(row) 여러개

-- int, String, double : JAVA primitive vs  NUMBER(int, double), VARCHAR2, DATE : ORACLE






--06-3. 숫자 함수 : % 대신 MOD 함수 ==> LIKE 연산자에서 와일드카드로 %를 사용함
-- ================================================================
-- 숫자 데이터를 다루는 함수(정수, 실수 ==> NUMBER 타입)
desc employees;
--SALARY            NUMBER(8,2) : 8이 전체 자릿수, 2가 소수부, 8-2는 정수

--ROUND(x) : 반올림(옵션 : 자릿수)
-- TRUNC(x) : 버림
-- CEIL(x) : 정수 (지정된 숫자보다 큰 정수중 가장 작은 정수)
-- FLOOR(x) : 정수 (지정된 숫자보다 작은 정수중 가장 큰 정수)
-- MOD(m,n) : 지정된 숫자를 나눈 나머지 값 <--> JAVA : % 연산자의 역할

--라인 복제 : 커서 위치해두고CTRL + SHIFT+D
--라인 삭제 : 커서 위치해두고 SHIFT + DEL
SELECT  10.5 AS ORIGIN,
        ROUND(10.532) AS ROUND1,
        ROUND(10.532, 0) AS ROUND0,       
        ROUND(10.532, 1) AS ROUND2,
        ROUND(10.532, 2) AS ROUND3,
        ROUND(10.532, -1) AS ROUND4_MINUS,
        ROUND(10.532, -2) AS ROUND5_MINUS    
FROM    dual;     






SELECT  10.5 AS ORIGIN,
        TRUNC(10.532) AS TRUNC1,
        TRUNC(10.532, 0) AS TRUNC0,       
        TRUNC(10.532, 1) AS TRUNC2,
        TRUNC(10.532, 2) AS TRUNC3,
        TRUNC(10.532, -1) AS TRUNC4_MINUS,
        TRUNC(10.532, -2) AS TRUNC     
FROM    dual;        


SELECT employee_id, first_name, salary, TRUNC(salary * 0.25, -1) AS comm
FROM    employees
WHERE   commission_pct IS NOT NULL;

SELECT  3.14 AS ORIGIN,
        CEIL(3.14) AS CEIL,
        FLOOR(3.14) AS FLOOR,
        ROUND(3.14) AS ROUND,
        TRUNC(3.14) AS TRUNC
FROM    dual;        


-- p.149 실습 6-22. MOD 함수로 나머지값 출력하기
-- 나머지 ==> 홀수 짝수 판별
SELECT  FLOOR(15 / 6) AS 몫,
        MOD(15, 6) AS 나머지
FROM    dual;






-- ================================================================
--06-2. 문자 함수 | 문자를 가공하거나, 문자데이터로부터 특정 결과를 얻을 떄
-- ================================================================

--1) 대,소문자를 바꾸는 함수 : UPPER(), LOWER(), INITCAP()-첫글자만 대문자 나머지는 소문자
desc employees;
SELECT  first_name,
        UPPER(first_name),
        LOWER(first_name),
        INITCAP(first_name)
FROM    employees        
WHERE   manager_id IS null;

-- p.131 실습 6-2 이름이 steven
SELECT *
FROM    employees
WHERE   LOWER(first_name) = 'steven';

SELECT *
FROM    employees
WHERE   LOWER(first_name) = 'scott'; -- 오래된 오라클 버전에서 사용한 SCOTT 스키마.. 여기엔 없음


-- p.132 실습 6-4. 선택한 열의 문자열 길이 구하기
SELECT  employee_id, first_name, LENGTH(first_name) AS name_length
FROM    employees
WHERE   LENGTH(first_name) >=7
ORDER BY    name_length;

SELECT  LENGTH('A') AS ENG,
        LENGTH('김') AS KOR,
        LENGTHB('A') AS ENG_BYTE,
        LENGTHB('김') AS KOR_BYTE
FROM    dual;        



--p.134 문자열 일부를 추출하는 SUBSTR 함수
-- 3) SUBSTR() : 문자열(주민등록번호 -> 생년월일, 전화번호 -> 마지막 네자리) 추출하는 함수
-- SUBSTR(문자열 데이터, 시작위치, [추출 길이]) : 문자열의 시작위치부터 추출 길이만큼 추출합니다.
-- 만약, 시작위치가 음수면 문자열의 마지막 위치부터 거슬러 올라간 위치에서 시작합니다.-- HELLO

SELECT  job_id
FROM    employees;

SELECT  job_id, SUBSTR(job_id, 1, 2) AS front, SUBSTR(job_id, 4, LENGTH(job_id)) AS back
FROM    employees;

-- ex. 주민번호(123456-7894561)
SELECT '123456-7894561' AS 주민번호,
        SUBSTR('123456-7894561', 1, 6)AS "주민번호 앞",
        SUBSTR('123456-7894561', 8) AS "주민번호 뒤1",
        SUBSTR('123456-7894561', 8, LENGTH('123456-7894561')) AS "주민번호 뒤2" 
FROM    dual;

-- ex. 전화번호(062-362-7797)
SELECT  '062-362-7797' AS 한울대표번호,
        SUBSTR('062-362-7797', -4) AS "마지막 번호1",
        SUBSTR('062-362-7797', -4, -1) AS "마지막 번호2",
        
        SUBSTR('062-362-7797', -4, LENGTH('062-362-7797')) AS "마지막 번호3"
FROM    dual;    


--p.135 사원 테이블의 사원이름, 세번쨰 글자부터 끝까지~
SELECT  employee_id, first_name, SUBSTR(first_name, 3) AS SUBSTR
FROM    employees;


--4) INSTR 함수 : 문자열 데이터 안에서 특정 문자 위치를 찾는 함수
-- 주민등록번호 : 123456-1234567 - 을 기준으로 앞, 뒤 구분
-- 이메일 주소 : id@naver.com에서 @을 기준으로 아이디, 도메인으로 구분
-- ....사례.. ==> 문자열의 특정 문자위치를 찾아서 반환하는 기능
-- INSTR(대상문자열, 찾는문자[, 시작위치][, 몇번째])
SELECT  'superboy123@naver.com' AS EMAIL,
        SUBSTR('superboy123@naver.com', 1, INSTR('superboy123@naver.com', '@')-1) AS EMAIL_ID,
        SUBSTR('superboy123@naver.com', INSTR('superboy123@naver.com', '@')+1, LENGTH('superboy123@naver.com')) AS EMAIL_ADDRESS
FROM    dual;


SELECT  '123456-9876543' AS 주번,
        SUBSTR('123456-9876543', 1, INSTR('123456-9876543', '-')-1) AS 주번앞자리,
        SUBSTR('123456-9876543', INSTR('123456-9876543', '-')+1, LENGTH('123456-9876543')) AS 주번뒷자리
FROM    dual;



SELECT  employee_id, first_name, email, phone_number,
        SUBSTR(phone_number, 1, INSTR(phone_number, '.')-1) AS 국번,
        SUBSTR(phone_number, INSTR(phone_number, '.')+1, 3)  AS 중간번호
FROM    employees
WHERE   employee_id BETWEEN 100 AND 144;

--p.138 실습 6-10 특정 문자를 포함하는 행(row) 찾기
-- 1) INSTR 함수로 찾기
SELECT *
FROM    employees
WHERE   INSTR(LOWER(first_name), 's') > 0;

-- 2) LIKE 연산자로 찾기
SELECT  employee_id, first_name, department_id
FROM    employees
WHERE   LOWER(first_name) LIKE '%s%';


--5) REPLACE 함수 : 특정 문자를 다른 문자로 바꾸는 함수
-- REPLACE(문자열데이터 또는 컬럼, 찾을문자[, 바꿀문자]);
--만약, 바꿀문자를 지정하지 않으면 찾는 문자로 지정한 문자는, 문자열 데이터에서 삭제됩니다.

--실습 6-12 REPLACE 함수로 전화번호 문자열의 -를 반환(공백 or 삭제)
SELECT  '010-1234-5678' AS PHONE1,
       REPLACE('010-1234-5678', '-', ' ')AS PHONE2,
       REPLACE('010-1234-5678', '-') AS PHONE3
FROM    dual;      

--6) LPAD(), RPAD() 데이터의 빈 공간을 특정 문자로 채우는 함수
-- L: Left, R: Right ==> 방향을 지정해서~
-- LPAD(문자열데이터 또는 컬럼명, 전체 자릿수[, 채울문자])
-- RPAD(문자열데이터 또는 컬럼명, 전체 자릿수[, 채울문자])
-- ※ 채울문자를 지정하지 않으면, 빈 공간의 자릿수 만큼 공백문자로 띄웁니다.

--p.140 실습 6-13 LPADm RPAD 함수 이용하여 출력하기

SELECT  'Oracle' AS COMPANY,
        LPAD('Oracle', 10, '#') AS LPAD1,
        LPAD('Oracle', 10) AS LPAD2,
        RPAD('Oracle', 10, '#') AS RPAD1,
        RPAD('Oracle', 10) AS RPAD2
FROM     dual;

--전화번호 : * 로 채우기
-- 주민등록번호 : * 채우기
SELECT  RPAD('990528-', 14, '*') AS 주민등록번호,
        RPAD('062-362-', 13, '*') AS 전화번호
FROM    dual;        

-- 7) CONCAT(문자열 데이터1, 문자열 데이터2) : 두 문자열을 하나로 합친 결과를 반환하는 함수
-- || : 문자열 연결 연산자 (선호)


-- 8) TRIM, LTRIM, RTRIM 함수 : 문자열 데이터 내에서 특정 문자를 제거하기 위해 사용하는 함수
-- TRIM([삭제 옵션] [삭제할 문자] FROM 원본 문자열) : 
-- ※ 삭제할 문자 생략시, 공백을 제거함
--8-1) 삭제옵션
-- LEADING : 왼쪽에서 제거
-- TRAILING : 오른쪽에서 제거
-- BOTH : 양쪽(좌우) 제거

--p.124 실습 6-16. TRIM 함수로 공백 제거하기

SELECT   '_ _Oracle_ _' AS ORIGIN_TEXT,
        '[' || TRIM(' _ _Oracle_ _ ') || ']' AS TRIM1,
        '[' || TRIM(LEADING FROM ' _ _Oracle_ _ ') || ']' AS TRIM2, 
         '[' || TRIM(TRAILING FROM ' _ _Oracle_ _ ') || ']' AS TRIM3,
         '[' || TRIM(BOTH FROM ' _ _Oracle_ _ ') || ']' AS TRIM4,
          '[' || LTRIM(' _ _Oracle_ _ ') || ']' AS LTRIM,
          '[' || RTRIM(' _ _Oracle_ _ ') || ']' AS RTRIM
FROM    dual;

-- LTRIM(원본문자열[,삭제할 문자열(집합)])
-- RTRIM(원본문자열[,삭제할 문자열(집합)])
-- ※ 삭제할 문자가 생략되면, 기본적으로 공백을 제거합니다.

-- ※TRIM(옵션~)이라는 함수는 꼭 알아두세요!


--================================================
--06-4. 날짜 함수
-- NLS 날짜 설정 : RR/MM/DD


SELECT  '24/06/18' + 1
FROM    dual;



--1) SYSDATE : 날짜 함수중 대표 함수, 파라미터x, OS의 현재 날짜와 시간을 반환하는 함수
-- ※ 150p. 년/월/일 시:분:초 형식 --> (1) 도구 - 환결설정 - 데이터베이스 - NLS 설정 변경(비추), (2) 변환함수 사용(추천)
SELECT  SYSDATE AS 오늘날짜,
        SYSDATE -1 AS 어제날짜,
        SYSDATE +1 AS 내일날짜,
        CURRENT_TIMESTAMP
FROM    dual;


-- 2) ADD_MONTHS() : 특정 날짜에 지정한 개월 수 이후 날짜 데이터를 반환하는 함수
--※ 윤녕등의 이유로 복잡해질수 있는 날짜 계산을 손쉽게 해결하는 함수 --> 은근히 자주 사용
-- ADD_MONTHS(날짜, 더할 개월수)
--  ※날짜 데이터 + 숫자 : 일수만 더해지고, ADD_MONTHS()를 사용해 개월수를 더하거나 뺌
SELECT  ADD_MONTHS(SYSDATE, 3) AS AFTER_MONTH,
        SYSDATE AS TODAY,
        ADD_MONTHS(SYSDATE, -3) AS AFTER_MONTH
FROM    dual;


SELECT  employee_id, first_name, hire_date, ADD_MONTHS(hire_date, 120)AS WORK10YEAR,
                                            ADD_MONTHS(hire_date, 240)AS WORK20YEAR
FROM    employees
ORDER BY    hire_date ASC;


--p.152 실습 6-26 입사 32년 미만인 사원 데이터 출력
SELECT  employee_id, first_name, hire_date, sysdate
FROM    employees
WHERE   ADD_MONTHS(hire_date, 12 * 20) > SYSDATE; 



-- 3) MONTH_BETWEEN(): 두 날짜간 개월 수 차이를 구하는 함수
-- MONTHS_BETWEEN(날짜데이터1, 날짜데이터)
-- ※ 비교 날짜의 입력 위치에 따라 음수 또는 양수가 나올 수 있습니다.

SELECT  employee_id, first_name, job_id, hire_date, SYSDATE,
        ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "근속 개월수",      
        ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS "근속 년수"
FROM    employees;


-- 4) NEXT_DAY() : 돌아오는 요일의 날짜를 반환하는 함수
-- NEXT_DAY(날짜 데이터, 요일문자) : 날짜 데이터 기준으로 돌아오는 요일의 날짜를 반환


SELECT  SYSDATE,
        NEXT_DAY(SYSDATE, '월'),
        NEXT_DAY(SYSDATE, '월요일')
--        NEXT_DAY(SYSDATE, 'MON') -- NLS 설정: 날짜 ->코리안 이라서 MON 입력하면 에러발생
        
FROM    dual;

-- 5) LAST_DAY() : 입력한 날짜 데이터에서 마지막 요일을 반환하는 함수
--LAST DAY(날짜 데이터) : 특정날짜가 속한 달의 마지막 날짜를 반환하는 함수
SELECT  SYSDATE,
        LAST_DAY(ADD_MONTHS(SYSDATE, 3)) AS "3개월 뒤 마지막 날짜"
FROM    dual;


-- 6) ROUND() : 
-- 7) TRUNC()
--================================================
-- ROUND(date), TRUNC(date) : 숫자 데이터, 날짜 데이터의 반올림, 버림 결과를 반환하는 함수
--================================================
-- ※ 특수한 목적의 업무 처리에 필요한 함수 vs 대부분은 숫자에 대한 처리 목적의 함수

-- p.156 6-29 ROUND 함수 사용하여 날짜 데이터 출력하기
SELECT   SYSDATE,
         ROUND(SYSDATE, 'MONTH')AS ROUND,
         TRUNC(SYSDATE, 'MON') AS TRUNC1,
         TRUNC(SYSDATE, 'MM') AS TRUNC
FROM    dual;

SELECT   SYSDATE,
         ROUND(SYSDATE, 'DAY')AS ROUND,
         TRUNC(SYSDATE, 'DD') AS TRUNC1,
         TRUNC(SYSDATE, 'J') AS TRUNC
FROM    dual;



--================================================
-- 변환함수: TO_CHAR(). TO_DATE(), TO_NUMBER() :  숫자 <--->문자 <----> 날짜 변환
--================================================
-- 일반적으로 오라클 엔진이 형변환, 의도적으로 형변환을 원할때 변환함수
-- 암시작, 암묵적 형변환     <---> 명시적 형변환
SELECT  1 + '1', 1
FROM    dual;

SELECT employee_id, first_name
FROM    employees;

-- p.157 6-31. 숫자와 문자열을 더하여 추력하기
SELECT  employee_id, first_name, employee_id + '500'  --employee_id가 number라 알아서 형변환 
FROM    employees
WHERE   employee_id = 200;


--06-5. 변환 함수 : 숫자 -> 문자 -> 날짜 or 숫자 <- 문자 <- 날짜
-- ※ 오라클에서는 숫자 -> 날짜, 날짜 -> 숫자로 바로 바꿀수 없음.

--1) TO_CHAR(날짜데이터, 문자포맷)  : 날짜, 숫자 데이터를 문자로 변환하는 함수
--   TO_CHAR(숫자데이터)

SELECT  TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS 현재날짜시간1,
          TO_CHAR(SYSDATE, 'YYYY/MM/DD HH:MI:SS') AS 현재날짜시간2,
          CURRENT_TIMESTAMP
FROM    dual;


SELECT  employee_id, first_name, TO_CHAR(hire_date, 'YYYY') AS hire_date, job_id, department_id
FROM    employees;

--p.160 실습 6-35. 여러 언어로 날짜(월) 출력하기
SELECT  SYSDATE,
        TO_CHAR(SYSDATE, 'MM') AS MM,
        TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MOM_KOR,
        TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE' ) AS MOM_JPN,
        TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MOM_ENG,
        TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MOMTH_KOR,
        TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = JAPANESE' ) AS MOMTH_JPN,
        TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MOMTH_ENG
FROM    dual;        


-- p.161 실습 6-37. SYSDATE 시간 형식 지정하여 출력하기
SELECT  SYSDATE,
        TO_CHAR(SYSDATE, 'HH:MI:SS AM') AS TODAY
FROM    dual;        

--NLS 설정 확인 : 도구 - 환경설정 - 데이터베이스 - NLS (탭)
-- 시스템 만들어둔 view(뷰, 임시테이블)
-- 설정을 세션이 유지되는 동안, 원하는 형태로 변경할 수 있음
-- ※ 도구 > 환결성정 > 데이터베이스 > NLS로 변경하면 ==> 이후에 변경되는 영구적인 설정
--SELECT  *
--FROM    v$nls_parameters;

--p.162 실습 6-38 여러 가지 숫자 형식을 사용하여 급여 출력하기
SELECT employee_id, first_name, TO_CHAR(salary, '99,999') AS "월급", TO_CHAR(salary * 12, '999,999') AS "연봉", salary * commission_pct AS "성과급"
FROM    employees
ORDER BY salary;

--p.163 실습 6-39. 문자 데이터와 숫자데이터를 연산하기
SELECT  1300 - '1500',
        '1300' - 1500
FROM    dual;        

-- TO_CHAR(), TO_NUMBER() : 사용빈도 (많다 -> 적다)

-- p.164 실습 6-42. 문자데이터를 날짜 데이터로 변환하기
SELECT  TO_DATE('2018-07-14', 'YY-MM-DD') AS DATE1,
        TO_DATE('20180714', 'YYYY-MM-DD') AS DATE2
FROM    dual;        

--p.165 실습 6-43. 1981년 6월 1일 이후에 입사한 사원 정보 출력하기
SELECT  employee_id, first_name, salary,
        TO_CHAR(hire_date, 'RRRR/MM/DD')AS RR_YEAR_49,
        TO_CHAR(hire_date, 'YYYY/MM/DD') AS YY_YEAR_49,
        department_id
FROM    employees
ORDER BY    hire_date ASC;
--==========================================================
-- RR v YY : 날짜 계산 방식이 다름(00~49), (50~99) ==> 비교적 가까운 날짜로 계산
--==========================================================


--06-6. NULL(처리)함수
-- NULL : 빈값, 이상값(Abnormal)의 의미(*)
-- NULL은 연산, 비교 대상이 아님!! 제대로 결과가 나오지 않음
SELECT 10 * NULL
FROM dual;

SELECT *
FROM    employees
WHERE   manager_id = null; -- 사장은 null 인데 안나옴


-- 1) NVL(NULL 검사할 컬럼, NULL일때 반환할 데이터) : NULL 검사할 컬럼이 NULL이 아니면 그대로 컬럼값을 반환하고,
--       NULL이면 두번째 파라미터의 값을 반환하는 함수

SELECT  employee_id, first_name,
        TO_CHAR(salary, '99,999') AS salary,
        NVL(commission_pct, 0) AS RATIO,
        TO_CHAR(salary * NVL(commission_pct, 0), '99,999') AS BONUS
FROM    employees;


-- 2) NVL2(NULL 검사할 컬럼, NULL아닐때 반환값, NULL일때 반환값)
-- 커미션 여부만 표시 : O, X
SELECT  employee_id, first_name, department_id, NVL2(commission_pct, 'O', 'X') AS "보너스 유무"
FROM    employees;


-- 3) COALESCE(NULL 검사할 컬럼1, 컬럼2[, 컬럼n]) : 첫 번째로 NULL 이 아닌 값을 반환하는 함수
-- 누군가는 연락처, 누군가는 휴대폰 번호, 누군가는 전화번호... 등으로 같은 의미를 갖는 다른 컬럼의 데이터를
-- 조회할때 사용/ 통합 - 합병되어서 DB를 통합하거나?
SELECT  COALESCE(NULL, '010-1234-5678', null) AS COALESCE1,
        COALESCE(NULL, null, '010-1234-5678')AS COALESCE2
FROM    dual;        



-- 06-7. 상황에 따른 데이터를 반환하는 DECODE 함수와 CASE문
-- 특정 열 값이나 데이터 값에 따라 어떤 데이터를 반환할지 결정하는 함수 : DECODE(if 조건문, switch_case문과 비슷)
--                                                                 문장 : CASE

-- DECODE(검사할 컬럼, 비교할 값, 조건1, 조건1과 일치할때 반환값, 
-- 조건2, 조건2와 일치할때 반환값, 조건n, 조건n과 일치할때 반환값...) AS 별칭

-- SA_MAN : 10% 인상한 급여
-- SA_REP : 5%
-- job_id와 조건을 동등비교하고 그 결과를 반환하는 DECODE 함수
SELECT  employee_id, first_name, job_id, salary,
        DECODE(job_id, 'SA_MAN', salary + salary * 0.1, 
                'SA_REP', salary + salary * 0.05,
                'ST_MAN', salary + salary * 0.03,
                salary) AS "increased salary"
FROM    employees;


-- 10번 부서 : 10%
-- 20번 부서 : 20%
-- 30번 부서 : 30%
-- 나머지 부서 : 인상 x

SELECT  employee_id, first_name, salary,
        DECODE(department_id, 10, salary + salary * 0.1,
                              20, salary + salary * 0.2,
                              30, salary + salary * 0.3,
                              salary)AS "increased salary"
        ,department_id
FROM    employees
ORDER BY department_id;

--DECODE() vs CASE
-- 동등비교     동등비교 이외의 비교(크다, 작다)
-- 연산자x     연산자o
--              WHEN, THEN, ELSE
--CASE 동등비교         vs          CASE 범위비교
-- CASE 비교할 컬럼/ 데이터         WHEN 비교할 컬럼/데이터 > 비교값 THEN
-- ※ 가독성있게 작성하고 줄바꿈! (대신, 문장 끝에 콤마 x)


-- DECODE <---> CASE를 바꾸어서 작성가능
/*
-- I. 동등비교

    CASE 검사 컬럼 데이터
        WHEN 조건1 THEN 조건1과 일치할때 반환값
        WHEN 조건2 THEN 조건2와 일치할때 반환값
        ....
        WHEN 조건n THEN 조건n과 일치할때 반환값
        ELSE 일치하는 조건이 없을때 반환값
        END AS 별칭
 

    II. 조건비교
    CASE
        WHEN 조건1 > 컬럼/데이터) THEN 조건1과 일치할때 반환값
        WHEN 조건2 < 컬럼/데이터) THEN 조건2와 일치할때 반환값
        ....
        WHEN 조건n(검사 컬럼/데이터) THEN 조건n과 일치할때 반환값
        ELSE 일치하는 조건이 없을때 반환값
        END AS 별칭
PL/SQL ==> INCREASE_SAL() 함수를 만드는 것 vs DECODE(), CASE ~ END 작성하는 것
 */
 
 -- I. CASE ~ 동등비교
 SELECT employee_id, first_name, salary,
        CASE department_id
        WHEN 10 THEN salary + salary * 0.1
        WHEN 20 THEN salary + salary * 0.2
        WHEN 30 THEN salary + salary * 0.3
        ELSE salary
        END AS "increased salary",
        job_id, department_id
FROM    employees
ORDER BY department_id;

-- 10~30 부서 : 10%
-- 40~60 부서 : 20%
-- 70~90 부서 : 30%
-- 나머지 인상x

-- II. 범위비교
SELECT employee_id, first_name, salary,
        CASE 
       
        WHEN   department_id >= 10 AND department_id <= 30 THEN salary + salary * 0.1
        WHEN   department_id BETWEEN 40 AND 60 THEN salary + salary * 0.2
        WHEN   department_id BETWEEN 70 AND 90 THEN salary + salary * 0.3
        ELSE salary
        END AS "increased salary",
        job_id, department_id
FROM    employees
ORDER BY department_id;

-- p.174~175 잊기전에 한번 더

--Q1. 사원테이블에서 사번과 이름을 조회하고 사번과 이름의 일부를 *로 표시하시오
-- 단, 이름의 길이 다섯글자 이상 여섯글자 미만의 사원 저옵률 출력
-- MASKING_EMPNO : 사원의 앞 두자리와 뒷자리를 *로 출력
-- MASKING_NAME : 사원의 이름 첫 글자만 보여주고 나머지는 글자수 만큼 *로 출력
-- ※ LPAD() 사용 vs 연결연산자 || 사용
SELECT  employee_id,
        RPAD(SUBSTR(employee_id, 1, 2), 4, '*') AS MASKING_EMPNO,
        first_name,
        RPAD(SUBSTR(first_name, 1, 1), 5, '*') AS MASKING_NAME
FROM    employees
WHERE   LENGTH(first_name) >= 5 AND LENGTH(first_name) < 6; --35rows

-- Q2. 사번, 이름, 급여, 일급, 시급을 사원테이블에서 조회하시오
-- 사원의 월 평균 근무일수 : 21.5일 (소수점 세번째 자리에서 버림)
-- 하루 근무시간 : 8시간
-- 일급: 소수점 세번째 자리에서 버림
-- 시급 : 두번째 소수점에서 반올림
SELECT  employee_id, first_name, salary,
        TRUNC(salary / 21.5, 2) AS DAY_PAY,
        ROUND((salary / 21.5) / 8, 1) AS TIME_PAY
FROM    employees;


--Q3. 사원테이블에서 사원의 입사일, 정직원이 되는 날짜, 추가수당 여부 | 없으면 N/A로 표시
-- NEXT_DAY() : 돌아오는 날짜, 요일?
-- LAST_DAY() : datetime의 마지막 날짜
-- DECODE() 또는 CASE~END로 해결
SELECT  employee_id, first_name, hire_date, NEXT_DAY(hire_date, '월요일') AS R_JOB,
        DECODE(commission_pct, null, 'N/A',
                                ROUND(commission_pct * salary)) AS COMM
FROM    employees;        


SELECT  employee_id, first_name, hire_date, NEXT_DAY(hire_date, '월요일') AS R_JOB,
        CASE 
        WHEN commission_pct IS NULL THEN 'N/A'
        ELSE TO_CHAR(commission_pct * salary, '99,999')
        END AS COMM
FROM    employees;    

--ORA-00932: 일관성 없는 데이터 유형 : CHAR이(가) 필요하지만  NUMBER임
-- CASE ~ END 에서, 첫번째 조건이 CHAR를 반환하므로, ELSE 절도 문자로 반환해서 오류 해결
-- N/A :  not applicable 또는 not available, no answer의 두문자어로, 정보없음 또는 해당사항이 없음을 의미한다.

--Q4. 직속 상관의 사원번호 (manager_id)를 기준으로 CHG_MGR컬럼에 출력
-- 매니저 없으면 0000
-- 매니저 사원의 앞 두자리 : --> ???
-- 그외 상관 사원의 번호 : 본래 직속 상관의 사원 번호 출력

SELECT *
FROM    employees
ORDER BY employee_id; -- 100~206 총 107명

-- DECODE(), CASE ~ END : 범용성
SELECT  employee_id, first_name, manager_id,
        CASE
            WHEN manager_id IS NULL THEN '0000'
            WHEN SUBSTR(manager_id, 1, 2) = '10' THEN '1000'
            WHEN SUBSTR(manager_id, 1, 2) = '11' THEN '1100'
            WHEN SUBSTR(manager_id, 1, 2) = '12' THEN '1200'
            ELSE TO_CHAR(manager_id)
            END AS CHG_MGR
         
FROM    employees        