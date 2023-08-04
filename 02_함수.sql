

/* 함수 : 컬럼의 값을 읽어서 연산한 결과를 반환
*
* 단일 행 함수 : N개의 값을 읽어서 N개의 결과를 반환
* 그룹 함수    : N개의 값을 읽어서 1개의 결과를 반환(합계, 평균, 최대, 최소)
* 
* 함수는 SELECT문의 
* SELECT절, WHERE절, ORDER BY절, GRUUP BY절, HAVING절 사용 가능
*
*/

-------------------------------------------------------

-- ** 단일 행 함수**

-- 1) LENGTH(컬럼명 | 문자열) : 길이 반환

SELECT EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;

-- INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치 [, 순번])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환

-- 문자열을 앞에서부터 검색하여 첫번째 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; 

-- 문자열을 5번째 문자부터 검색하여 첫번째 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL; 

-- 문자열을 5번째 문자부터 검색해서 두번째 B의 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5, 2) FROM DUAL; 

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@'의 위치 조회
SELECT EMP_NAME, EMAIL,INSTR(EMAIL, '@') FROM EMPLOYEE;

------------------------------------------------------------

-- 2) SUBSTR(컬럼명 | '문자열', 잘라내기 시작할 위치, [,잘라낼 길이]) 
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라서 반환
-- 잘라낼 길이 생략시 끝까지 잘라냄

-- EMPLOYEE 에서 사원명, 이메일 중 아이디만 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) FROM EMPLOYEE;
 
-----------------------------------------------------------------------

-- 3) TRIM([ [옵션] '문자열' | 컬럼명 FROM] '문자열' | 컬럼명)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> 양쪽 공백 제거에 사용

-- 옵션 : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽)

SELECT TRIM('            H E L L O           ') FROM DUAL;
SELECT TRIM(BOTH '#' FROM '#######%#안녕####^###')FROM DUAL; -- 중간에 다른 글자 있으면 거기서 멈춤
SELECT TRIM(BOTH '%' FROM TRIM(BOTH '#' FROM '#######%#안녕####^###' )) FROM DUAL; -- 중첩 가능
SELECT TRIM(BOTH '^' FROM TRIM(BOTH '%' FROM TRIM(BOTH '#' FROM '#######%#안녕####^###' ))) FROM DUAL;
SELECT TRIM(BOTH '#' FROM TRIM(BOTH '^' FROM TRIM(BOTH '%' FROM TRIM(BOTH '#' FROM '#######%#안녕####^###')))) FROM DUAL;

-------------------------------------------------------------------------

-- ** 숫자 관련 함수 **

-- 1) ABS(숫자 | 컬럼명) : 절대값
-- WHERE절에서도 가능
SELECT ABS(10), ABS(-10) FROM DUAL;
SELECT '절대값 같음' FROM DUAL
WHERE ABS(10) = ABS(-10);

---------------------------------------------------------------------------

-- 2) MOD(숫자 | 컬럼명, 숫자  | 컬럼명) : 나머지 값 반환
-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 떄 나머지 조회

SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) FROM EMPLOYEE ;

-- EMPLOYEE 에서 사번이 짝수 인 사원의 사번 이름
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 0; 

-- EMPLOYEE 에서 사번이 짝수 인 사원의 사번 이름
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 1; 

---------------------------------------------------------------------------

-- 3) ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
SELECT ROUND(123.456) FROM DUAL; -- 소수점 첫번째에서 반올림

SELECT ROUND(123.456, 1) FROM DUAL; -- 소수점 첫번째까지 표현

-- 4) CEIL(숫자 | 컬럼명) : 올림  -- 소수점 위치 못 넣음
-- 5) FLOOR(숫자 | 컬럼명) : 내림

SELECT CEIL(123.456345), FLOOR(123.9) FROM DUAL; 

-- 6) TRUNC(숫자 | 컬럼명 [, 소수점 위치 OR 정수 위치]) : 특정 위치 아래를 버림(첨삭)
SELECT TRUNC(12423.1245424, 2) FROM DUAL; -- 소수점 2번째 자리까지 남김
SELECT TRUNC(12423.1245424, -2) FROM DUAL; -- 10의 자리 까지 버림 

SELECT FLOOR(-123.5), TRUNC(-123.5) FROM DUAL;

---------------------------------------------------------------------------

-- ** 날짜 관련 함수**

-- 1) SYSDATE : 시스템에 현재 시간 반환
SELECT SYSDATE FROM DUAL;

-- 2) SYSTIMESTAMP : SYSDATE + MS 추가
SELECT SYSTIMESTAMP FROM DUAL; -- TIMESTAMP : 특정 시간을 나타내거나 기록하기 위한 문자열

-- 3) MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, '2023-12-22'), 3) "수강기간(개월)" 
FROM DUAL; 

--EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무한 개월수, 근무 연차
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무한 개월수", 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "근무 연차"  
FROM EMPLOYEE; 
/*' || ' : 연결 연산자(문자열 이어쓰기) */

-- 4) ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함.(음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL;

--5) LAST_DAT(날짜) : 해당 달의 마지막 날짜를 구함
SELECT LAST_DAY(SYSDATE) FROM DUAL; 
 
-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

-- EMPLOYEE 테이블에서 
-- 각사원의 이름, 입사년도, 월, 일 조회
SELECT EMP_NAME, 
EXTRACT(YEAR FROM HIRE_DATE)|| '년 ' || 
EXTRACT(MONTH FROM HIRE_DATE) || '월 ' || 
EXTRACT(DAY FROM HIRE_DATE) || '일 '  "입사일" 
FROM EMPLOYEE;

----------------------------------------------------------------------------

-- ** 형변환 함수 **
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE)끼리 형변환 가능

-- 1) 문자열로 변환
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경
SELECT TO_CHAR(HIRE_DATE) FROM EMPLOYEE; 

-- 숫자 변환시 [포맷] 패턴
-- 9 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬 
-- 0 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬 + 빈칸에 0 추가
-- L : 현재 DB에 설정된 나라의 화폐 기호
SELECT TO_CHAR(1234, '99999999') FROM DUAL; -- '    1234'
SELECT TO_CHAR(1234, '00000000') FROM DUAL; -- '00001234'
SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL; -- '01234'
SELECT TO_CHAR(1000000, 'L9,999,999') || '원' FROM DUAL; -- '\1,000,000원'

-- 날자 편환시 포맷 패턴
-- YYYY : 년도 // YY: 년도(짧게);
-- MM : 월
-- DD : 일
-- AM 또는 PM : 오전/오후 표시
-- HH : 시간 / HH24 : 24시간 표기법
-- MI 분 / SS: 초
-- DAY : 요일(전체 '수요일') / DY : 요일(요일명만 '수')

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY')FROM DUAL; 

--08/04(금)
SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL;

--2024년 08월 04일 (금)
SELECT TO_CHAR(SYSDATE, 'YY" DD"일" (DY)') 날짜
FROM DUAL; 
-- 년 월 일 이 날짜를 나타내는 패턴으로 인식이 안되서 오류 발생
--> "" 로 단순 문자로 인식시키면 해결


-- 2) 날짜로 변환 TO_DATE
-- TO_DATE(문자형 데이터, [포맷]) : 문자형 데이터를 날짜로 변경 
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 데이터를 날짜로 변경 
--> 지정된 포맷으로 날짜를 인식함
SELECT TO_DATE('2022-09-02')FROM DUAL; -- DATE 타입으로 변환
SELECT TO_DATE('20231230')FROM DUAL;  

SELECT TO_DATE('230803 101835', 'YYMMDD HH24MISS')FROM DUAL;
-- 패턴을 적용해서 작성된 문자열의 각 문자가 어떤 형식인지 인지 시킴[포맷]으로


-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일 조회
-- Y 패턴은 21세기 패턴 (20--년)
-- R 패턴 :  1세기 기준으로 
-- 절반(50년) 이상인 경우는 이전 세기(1900년대) : 50이상은 1900년대
-- 절반(50년) 미만인 경우는 현제 세기(2000년대) : 50미만은 2000년대
SELECT EMP_NAME, TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6),'RRMMDD' ), 'YYYY"년" MM"월" DD"일"') 생년월일 FROM EMPLOYEE;


-- 3) 숫자 형변환
-- TO_NUMBER(문자 데이터, [포맷]) : 문자형 데이터를 숫자형으로 변경
SELECT '1,000,000' + 500000 FROM DUAL; -- X
SELECT  TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL; 


-- 4) NULL처리 함수
-- NULL과 산술 진행 -> 결과는 NULL
-- 이런 상황 방지

-- NVL(컬럼명, 컬럼값이 NULL일때 바꿀 값) : NULL인 컬럼값을 다른값으로 변경
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY*NVL(BONUS, 0) FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2) : 해당 컬럼에 값이 있으면 1, NULL이면 2

-- EMPLOYEE에서 보너스 받으면 0 아니면 X
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 수령" FROM EMPLOYEE;


--------------------------------------------------------------------------------------------

-- ** 선택 함수 
-- 여러가지 경우에 따라 알맞은 결과를 선택할 수 있슴

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ...., 아무것도 일치하지 않을 때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
-- 일치하는 값을 확인(자바의 SWITCH 비슷)

-- 직원의 성별 구하기(남이면 1, 여면 2)
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성') 성별 FROM EMPLOYEE; 

--직원의 급여 인상하고자한다
-- 직급코드가 J7은 20
-- J6은 15
-- J5는 10
-- 그외는 5

SELECT EMP_NAME, JOB_CODE, SALARY,
	DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') "인상율"
	DECODE(JOB_CODE, 'J7', SALARY*1.2, 'J6', SALARY*1.15, 'J5', SALARY*1.1, SALARY*1.05) "인상 급여" 
FROM EMPLOYEE;


-- CASE WHEN 조건식 THEN 결과
--		WHEN 조건식 THEN 결과
--		ELSE 결과값
-- END
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 조건은 범위 값 가능

-- EMPLOYEE 테이블에서 
-- 급여가 500 이상 대
-- 급여가 300이상 500미만 중
-- 급여가 300미만 소

SELECT EMP_NAME, SALARY,
	CASE
		WHEN SALARY >= 5000000 THEN '대'
		WHEN SALARY >= 3000000 THEN '중'
		ELSE '소'
	END "급여 받는 정도"
FROM EMPLOYEE;


---------------------------------------------------------------
-- ** 그룹 함수
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의 하나의 결과 행으로 반환하는 함수


-- 1) SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합
SELECT SUM(SALARY) FROM EMPLOYEE;


-- 2) AVG(숫자가 기록된 컬럼명) : 평균
-- 전 직원의 급여 평균
SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE;

-- 부서코드가 D9인 사원의 급여합과 평균
SELECT SUM(SALARY), ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';


-- 3) MIN(컬럼명) : 최소값
-- 4) MAX(컬럼명) : 최대값
--> 타입 제한 없음(숫자: 대/소    ||    날짜 : 과거/미래    ||    문자 : 문자순서)

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가짱 빠른 이메일
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL) FROM EMPLOYEE;

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가짱 빠른 이메일
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL) FROM EMPLOYEE;

-- 급여를 가장 많이 받는 사원의 이름 급여 직급 코드
SELECT EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY)FROM EMPLOYEE); -- SUBQUERY + 그룹함수


-- 5) COUNT(* | 컬럼명) : 행 개수를 헤아려서 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 헤아려서 리턴
SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE; -- (NULL값 미포함)

-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
SELECT COUNT(*) FROM EMPLOYEE;

-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수를 리턴
SELECT COUNT(BONUS) FROM EMPLOYEE;
SELECT COUNT(*) FROM EMPLOYEE WHERE BONUS IS NOT NULL;


-- EMPLOYEE 테이블에서 남성인 사원의 수 조회

SELECT COUNT(*) 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

--------------------------------------------------------------------------


