-- Q1. 급여가 2000초과인 사원들의 부서 정보, 사원 정보를 오른쪽과 같이 출력해 보세요
-- 오라클 조인, ANSI 조인 방식으로 조회
-- 오라클 등가조인 : 공통 컬럼을 기준으로 ~ 연결된 테이블의 컬럼을 포함하여 데이터 조회
SELECT  d.department_id,  d.department_name, 
        e.employee_id, e.first_name, e.salary
FROM    employees e, departments d
WHERE   e.employee_id = d.department_id
ORDER BY 5; -- 11rows

-- ANSI 조인 : , 대신 INNER JOIN, WHERE 대신 ON 
SELECT  d.department_id,  d.department_name, 
        e.employee_id, e.first_name, e.salary
FROM    employees e INNER JOIN departments d
ON     d.department_id = e.department_id
WHERE   e.salary > 2000
ORDER BY 5;

--ANSI 조인(NATURAL JOIN : 등가조인, 알아서 공통 컬럼을 인식해서 JOIN 연산)
-- ※ 두 테이블 간의 동일한 이름을 갖는 모든 컬럼들에 대해 EQUI(=) JOIN을 수행한다.
-- ※ 테이블 별칭, 컬럼 별칭, USIN, ON을 사용할 수 없다.
SELECT  department_id,  department_name, 
        employee_id, first_name, salary
FROM    employees NATURAL JOIN departments
WHERE   salary > 2000
ORDER BY salary; -- 32rows : 10,40,70 번 부서원 데이터 누락


--Q1. 각 부서별 평균 급여, 최대급여, 최소 급여, 사원수를 조회하시오
SELECT  d.department_id, d.department_name, ROUND(AVG(e.salary)) AS AVG_SAL, MAX(e.salary) AS MAX_SAL, MIN(e.salary) AS MIN_SAL,
        COUNT(*) AS CNT
FROM    departments d, employees e
WHERE   d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- II. ANSI 조인
SELECT  d.department_id, d.department_name,
        ROUND(AVG(e.salary)) AS AVG_SAL, MAX(e.salary) AS MAX_SAL, MIN(e.salary) AS MIN_SAL, COUNT(*) AS CNT
FROM    departments d INNER JOIN employees e
ON  d.department_id = e.department_id
GROUP   BY d.department_id, d.department_name;

-- Q3. 모든 부서 정보와 모든 사원 정보를 부서번호, 부서명, 사번, 이름, 직무, 급여 순서로 조회하시오
-- I. 오라클 조인
-- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다: 오라클 조인에서는 양쪽 모두 NULL 값을 포함할 수 없다.
SELECT  d.department_id AS DEPTNO, d.department_name AS DNAME,
        e.employee_id AS EMPNO, e.first_name AS ENAME, e.job_id AS JOB, e.salary AS SAL
FROM    departments d, employees e
WHERE   d.department_id = e.department_id(+);

-- II. ANSI 조인
-- FULL OUTER JOIN : 양쪽 NULL값을 모두 포함한.
SELECT  d.department_id AS DEPTNO, d.department_name AS DNAME,
        e.employee_id AS EMPNO, e.first_name AS ENAME, e.job_id AS JOB, e.salary AS SAL
FROM    departments d FULL OUTER JOIN employees e
ON   d.department_id = e.department_id
ORDER BY    1;


-- p.240 Q4. 모든 부서 정보, 사원 정보, 급여 정보, 사원의 직속상관 정보를 조회하시오
-- I. 오라클 조인
SELECT  d.department_id AS DEPTNO,
        d.department_name AS DNAME,
        e.employee_id AS EMPNO,
        e.first_name AS ENAME,
        e.manager_id AS MGR,
        e.salary AS SAL,
        j.min_salary AS LOSAL,
        j.max_salary AS HISAL,
        m.department_id AS DEPTNO_MGR,
        m.employee_id AS MGR_EMPNO,
        m.first_name AS MGR_NAME
FROM    departments d, employees e, jobs j, employees m
WHERE   d.department_id = e.department_id(+)
AND     e.job_id = j.job_id(+)
AND     e.manager_id = m.employee_id(+)
ORDER BY 1; -- 122 rows

-- II. ANSI 조인
SELECT  d.department_id AS DEPTNO,
        d.department_name AS DNAME,
        e.employee_id AS EMPNO,
        e.first_name AS ENAME,
        e.manager_id AS MGR,
        e.salary AS SAL,
        j.min_salary AS LOSAL,
        j.max_salary AS HISAL,
        m.department_id AS DEPTNO_MGR,
        m.employee_id AS MGR_EMPNO,
        m.first_name AS MGR_NAME
FROM    departments d LEFT OUTER JOIN employees e
ON   d.department_id = e.department_id LEFT OUTER JOIN  jobs j
ON     e.job_id = j.job_id LEFT OUTER JOIN employees m
ON     e.manager_id = m.employee_id
ORDER BY 1; -- 122rows -- outer는 방향을 써야함 left, right, full


-- p.218 집합 연산 vs 조인 연산 차이점
--       수직         수평
--        X           종속관계 : 부모- 자식(부서 -사원관계)
--                    식별관계 vs 비식별 관계 : 부모테이블의 기본 키/유니크 키 --> 자식 테이블의 기본키(PK)로 사용되는 관계
--                                              부모테이블의 기본 키/유니크 키 --> 자식 테이블의 외래키(FK)로 사용되는 관계




