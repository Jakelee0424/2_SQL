-- DCL (DATA CONTROL LANGUAGE)
-- : 데이터를 다루기 위한 권한을 다루는 언어
-- 계정에 DB, DB 객체에 대한 접근 권한을 부여(GRANT)하고 회수 (REVOKE)하는 언어


-- 		권한의 종류

-- 1) 시스템 권한 : DB접속, 객체 생성 권한

-- 		CREATE SESSITON : 데이터베이스 접속 권한
-- 		CREATE TABLE : 테이블 생성 권한
-- 		CREATE VIEW : 뷰 생성 권한
-- 		CREATE SEQUENCE : 시퀀스 생성 권한
-- 		CREATE PROCEDURE : 함수(프로시저) 생성 권한
-- 		CREATE USER : 사용자(계정) 생성 권한

-- 		DROP USER : 사용자(계정) 삭제 권한

-- 2) 객체 권한 : 특정 객체를 조작할 수 있는 권한

-- 		권한 종류 		|			설정 객체

--		 SELECT					TABLE, VIEW, SEQUENCE
--		 INSERT					TABLE, VIEW
--		 UPDATE					TABLE, VIEW
--		 DELETE					TABLE, VIEW
-- 		 ALTER 					TABLE, SEQUENCE
-- 		 REFERENCES				TABLE
-- 		 INDEX					TABLE
--		 EXCUTE					PROCEDURE 
------------------------------------------------------------------------------------------

-- USER - 계정 (사용자)

-- 1) 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정
--					모든 권한과 책임을 가지는 계정
--					EX) SYS, SYSTEM(SYS에서 권한 몇개 제외됨)

-- 2) 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의 
--					작업을 수행할 수 있는 계정
--					업무에 필요한 최소한의 권한만 가지는 것이 원칙
--					EX) KH, WORKBOOK

--------------------------------------------------------------------------------------------

-- 계정 생성하기

-- 1. SYS 계정 접속

-- 2. 이전 SQL 구문도 허용해주는 구문(계정정 간단 작성 가능)
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 3. 계정 생성 
-- : CREATE USER '아이디' IDENTIFIED BY '비밀번호' 
CREATE USER JAKE IDENTIFIED BY 1234;

-- 4. 접속 권한 부여
-- : GRANT 권한, 권한, ... TO '사용자 명';
GRANT CREATE SESSION TO JAKE; -- (계정 생성 권한)

-- 5. JAKE 계정으로는 아직 테이블 생성 불가 X
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
);

-- 6. SYS 계정에서 테이블 생성 권한 + TABLESPACE 할당
GRANT CREATE TABLE TO JAKE; -- 테이블 생성 권한 부여

ALTER USER JAKE DEFAULT TABLESPACE
SYSTEM QUOTA UNLIMITED ON SYSTEM; -- TABLESPACE 할당

-- 7. 테이블 생성 가능 
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
);

-----------------------------------------------------------------------------------------------

-- ROLE(역할) : 권한 묶음
-- 묶어 둔 권한(ROLE)을 특정 계정에 부여
--		-> 해당 계정은 권한을 이용하여 특정 역할을 갖게 된다.

-- JAKE 계정에 CONNECT, RESOURCE 부여
GRANT "CONNECT", RESOURCE TO JAKE; 

-- CONNECT : DB 접속 관련 권한
-- RESOURCE : DB 사용을 위한 기본 객체 생성 권한(CREATE TABLE, CREATE SEQUENCE 등..)

------------------------------------------------------------------------------------------------

-- 객체 권한
-- kh / JAKE 사용자 계정끼리 서로 객체 접근 권한 부여 과정

-- 1. JAKE 계정으로 kh 계정의 EMPLOYEE 테이블 조회
SELECT * FROM kh.EMPLOYEE; -- 접근 권한 없어서 조회 불가

-- 2. (kh) 계정에서 JAKE로 EMPLOYEE 테이블 조회 권한 부여
-- GRANT 객체권한 ON 객체명 TO 사용자명;
GRANT SELECT ON EMPLOYEE TO JAKE; -- 실행 후 조회 가능

-- 3. 권한 회수
-- (kh) 계정에서 실행
-- REVOKE 객체권한 ON 객체명 FROM 사용자명;
REVOKE SELECT ON EMPLOYEE FROM JAKE; 





