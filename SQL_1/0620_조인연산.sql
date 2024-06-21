-- p.215 조인(식 연산) /쪼인
-- 여러개의 테이블 (마치) 하나의 테이블인것처럼 사용하는 방법
-- 수평적인 연결 | 조인 연산 <--> 수직적인 연결 : 집합(SET) 연산

-- p.215 여러 테이블을 사용할때의 FROM 절
--SELECT 컬럼1, 컬럼2, 컬럼3...
--FROM  테이블1, 테이블2, 테이블3....
--WHERE
--GROUP BY
--HAVING
--ORDER BY
-- p.216 실습 8-1. FROM 절에 여러 테이블 선언하기
-- 사원 : 107
-- 부서 : 27
SELECT 107 * 27
FROM    dual; -- 2889rows
-- 조인 조건을 명시하지 않으면 ==> 테이블의 결과행을 모두 곱해서 ==> 출력!(p.217 조인조건이 없을때 문제점)


SELECT   *
FROM    employees, departments
ORDER BY    employee_id;

--조인연산
-- 테이블 별칭.컬럼명
SELECT  e.employee_id, e.first_name, e.job_id, -- employees컬럼
        d.department_name -- departments 컬럼
FROM    employees e, departments d -- 각 테이블의 별칭(Alias)
WHERE   e.department_id = d.department_id
ORDER BY    1;


--=================================================================
--ORA-00918: 열의 정의가 애매합니다 --> 조인연산자에서 어느 테이블의 컬럼인지, 별칭.컬럼명으로 기술
--=================================================================
-- 카테시안 곱(Catesian Product) ==> 조인 조건이 생략되었을 때, 조인 하려는 테이블의 데이터 행 갯수만큼
-- [크로스 조인] (잘못된 조인식)     곱한 결과를 반환한 현상 ==> employees : 107 X 27 : departments = 2889 rows
-- ※ 오라클 조인
-- 1) 등가조인 : 테이블을 연결한 후 출력 행을 각 테이블의 특정 열에 일치한 데이터를 기준으로 선정하는 방식
--         └ 내부조인(Inner JOIN), 단순조인(Simple JOIN) 이라고도 함.
--         └ 일반적으로(오라클에서) 가장 많이 사용하는 조인 방식
--         ※ 외부 조인이라고 하지 않으면, 기본적으로 등가조인(=내부조인)을 사용함.

-- p.222 실습8-5. 사원의 정보중에 부서명과 부서위치를 함께 조회
-- 등가조인 + 일반조걱 ==> 출력 제한( 총 107명중, 월급여 3000$ 이상인 사원들만 사원으 ㅣ정보 + 부서정보 조회)
SELECT  e.employee_id, e.first_name, e.department_id, 
        d.department_name, d.location_id
FROM        employees e, departments d    -- 조인 조건
WHERE       e.department_id = d.department_id
AND         e.salary >= 3000 --일반 조건
ORDER BY    1;

-- p.223 1분 복습.
--====================================================================
-- 조인 테이블 갯수와 조건식의 갯수 관계 : (최소갯수) 테이블 갯수 -1
-- ex. 사원 - 부서 테이블 JOIN : 테이블 개수 2개 ==> 조인 조건식 1개
-- ex. 사원 - 부서 - 위치 테이블 JOIN : 테이블 개수 3개 ==> 조인 조건식 2개
--====================================================================
SELECT  e.employee_id, e.first_name,
        d.department_name, d.location_id
FROm    employees e, departments d
WHERE   e.department_id = d.department_id
AND     e.salary <= 2500
AND     e.employee_id BETWEEN 100 AND 150
ORDER BY  1;

-- 사원 정보 - 부서정보 - 부서의 위치정보 | 
-- 1명의 사원 ==> 부서(departments_id IS NULL)가 없음 <===>NULL 비교x 여서 106명나옴
-- 누락된 데이터를 조인 ==> 외부(OUTER) 조인으로 처리
SELECT  e.employee_id, e.first_name, e.phone_number,
        d.department_name, 
        l.city, l.street_address
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id
AND     d.location_id = l.location_id
ORDER BY    1;

SELECT *
FROM    employees
WHERE   department_id IS NULL;
-- 178	Kimberely	Grant	KGRANT	011.44.1644.429263	07/05/24	SA_REP	7000	0.15	149	
--
-- 2) 비등가조인 : 등가 조인 이외의 방식을 의미 ==> 등가(=) 조인 vs (=이 아닌 다른 비교 연산자 사용)조인
--p.224 SALGRADE - EMP 조인 ==> SALGRADE
-- JOBS 테이블 : MIN_SALARY, MAX_SALARY
-- p. 224 실습8-7. 급여 범위를 지정하는 조건식으로 조인하기
SELECT  *
FROM    employees e, jobs j
WHERE   e.salary BETWEEN j.min_salary AND j.max_salary;

SELECT *
FROM    jobs; -- 19rows



SELECT COUNT(*)
FROM    jobs; -- 19rows



SELECT COUNT(*)
FROM    employees;  -- 107rows




-- 3) 자체조인(SELF 조인)
-- 사원 - 매니저 관계 : 사원, 매니저 ==> employee   , 사원은 매니저를 있을 수 있다.
-- 사원정보 + 매니저 정보 : 이름, 연락처
-- 사원의 manager_id에 매니저 사원의 employee_id가 저장되어 있음.
SELECT  e.employee_id, e.first_name, e.department_id,
        m.first_name AS manager_name, m.phone_number AS phone_number
FROM    employees e, employees m
WHERE   e.manager_id = m.employee_id
ORDER BY 1;







-- 4) 외부조인 : 특정 컬럼의 값이 NULL일때 조인을 하면, 관계되는 테이블의 결과를 누락하는데 (등가조인일떄)
--               누락하지 않고 어느 기준열의 한쪽이 NULL이라도 강제로 출력하는 방식

--===============================================================
-- 왼쪽 외부 조인 vs 오른쪽 외부 조인 : 기준 열 중 한쪽(=반대쪽)에 (+) 기호를 붙인다.
--===============================================================

-- 사원정보에 부서이름을 함께 조회
SELECT  e.employee_id, e.first_name, e.job_id, e.hire_date,
        d.department_name
FROM    employees e, departments d
WHERE   e.department_id = d.department_id(+);


-- 사원과 매니저 정보를 함께 조회
SELECT  e.employee_id, e.first_name, e.department_id,
        m.first_name AS manager_name, m.phone_number AS phone_number
FROM    employees e, employees m
WHERE   e.manager_id = m.employee_id(+)
ORDER BY 1;
--===============================================================
--ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다
--WHERE   e.department_id(+) = d.department_id(+);
--===============================================================



--=======================================================================
-- SQL-99 ISO/ANSI 표준문법 : 다른 DBMS에서 조인연산에 있어 표준 문법을 정의
-- 오라클 이외의 DBMS (MySQL, postgreSQL, sqlLite, ---ect) 에서 사용하는 조인식
--=======================================================================
-- 5) NATURAL JOIN : 오라클 등가조인 대신 사용할 수 있는 조인방식 ==> 공통 컬럼의 이름 기준
-- (=INNER JOIN)
-- p. 232 실습 8-11. 사원의 정보에 사원이 소속된 부서의 이름과 부서위치 코드를 조회 ==> NATURAL JOIN 사용!
-- 커미션은 월급여 X 커미션 퍼센트
SELECT  employee_id, first_name, job_id, manager_id, hire_date, salary, salary * NVL(commission_pct, 0) AS COMM,
        department_id, department_name, location_id
FROM    employees e NATURAL JOIN departments d -- 네추럴 조인 한다고 보여짐 vs    , : 콤마?
WHERE   department_id = 30;


SELECT  e.employee_id, e.first_name, e.job_id, e.manager_id, e.hire_date, e.salary, e.salary * NVL(e.commission_pct, 0) AS COMM,
        d.department_id, d.department_name, d.location_id
FROM    employees e INNER JOIN departments d -- 네추럴 조인 한다고 보여짐 vs    , : 콤마?
ON   e.department_id = d.department_id;


SELECT  e.employee_id, e.first_name, e.job_id, e.manager_id, e.hire_date, e.salary, e.salary * NVL(e.commission_pct, 0) AS COMM,
        department_id, d.department_name, d.location_id
FROM    employees e JOIN departments d -- 네추럴 조인 한다고 보여짐 vs    , : 콤마?
USING   (department_id);
--=================================================================
--ORA-00905: 누락된 키워드 ==> INNER JOIN으로 표기할 때는 WHERE을 ON 으로
--ORA-00906: 누락된 좌괄호 - USING(공동컬럼명) vs ON 기준컬럼=상대컬럼
--=================================================================


-- 6) JOIN ~ USING
-- 7) JOIN ~ ON

-- 8) OUTER JOIN : FROM 테이블1[LEFT | RIGHT | FULL] OUTER JOIN 테이블명2
-- 107명중 1명: 부서없는, 킴벌리씨가 전체 사원명단에서 누락됨(부서코드 x)
SELECT  e.employee_id, e.first_name, e.job_id, e.manager_id, e.hire_date, e.salary, e.salary * NVL(e.commission_pct, 0) AS COMM,
        department_id, d.department_name, d.location_id
FROM    employees e FULL OUTER JOIN departments d -- 네추럴 조인 한다고 보여짐 vs    , : 콤마?
USING   (department_id);














