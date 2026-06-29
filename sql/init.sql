-- ============================================================
-- HR 인사관리 시스템 DB 초기화 SQL
-- Database: dlive_insa
-- ============================================================

USE dlive_insa;

-- 사원 기본 마스터 테이블
CREATE TABLE IF NOT EXISTS emp_master (
    emp_id          VARCHAR(20)  NOT NULL             COMMENT '사번',
    emp_nm          VARCHAR(50)  NOT NULL             COMMENT '성명(한글)',
    emp_nm_hanja    VARCHAR(50)                       COMMENT '성명(한자)',
    emp_nm_eng      VARCHAR(100)                      COMMENT '성명(영문)',
    emp_gender      CHAR(1)                           COMMENT '성별 M:남 F:여',
    emp_birth_dt    DATE                              COMMENT '생년월일',
    emp_ssn         VARCHAR(14)                       COMMENT '주민번호',
    emp_nationality VARCHAR(50)  DEFAULT '내국인'     COMMENT '국적',
    work_status     CHAR(1)      DEFAULT '1'          COMMENT '근무상태 1:재직 2:휴직 3:퇴직',
    corp_cd         VARCHAR(20)                       COMMENT '법인코드',
    corp_nm         VARCHAR(100)                      COMMENT '법인명',
    grp_join_dt     DATE                              COMMENT '그룹입사일',
    corp_join_dt    DATE                              COMMENT '법인입사일',
    dept_cd         VARCHAR(20)                       COMMENT '부서코드',
    dept_nm         VARCHAR(200)                      COMMENT '부서명',
    position_cd     VARCHAR(20)                       COMMENT '직위코드',
    position_nm     VARCHAR(50)                       COMMENT '직위명',
    title_nm        VARCHAR(50)                       COMMENT '직책명',
    work_so         VARCHAR(100)                      COMMENT '근무SO',
    mobile_no       VARCHAR(20)                       COMMENT '휴대폰',
    office_tel      VARCHAR(20)                       COMMENT '사내전화',
    home_tel        VARCHAR(20)                       COMMENT '자택번호',
    edu_level       VARCHAR(20)                       COMMENT '최종학력',
    job_type        VARCHAR(50)                       COMMENT '직무구분',
    duty_nm         VARCHAR(200)                      COMMENT '담당업무',
    corp_email      VARCHAR(100)                      COMMENT '회사이메일',
    personal_email  VARCHAR(100)                      COMMENT '개인이메일',
    veteran_yn      CHAR(1)      DEFAULT 'N'          COMMENT '보훈여부',
    disability_yn   CHAR(1)      DEFAULT 'N'          COMMENT '장애여부',
    club_nm         VARCHAR(200)                      COMMENT '동호회',
    marital_status  VARCHAR(20)                       COMMENT '결혼정보',
    hometown        VARCHAR(300)                      COMMENT '본적',
    home_addr       VARCHAR(500)                      COMMENT '현주소',
    photo_path      VARCHAR(500)                      COMMENT '사진경로',
    resign_dt       DATE                              COMMENT '퇴직일',
    remark          TEXT                              COMMENT '비고',
    created_dt      DATETIME     DEFAULT CURRENT_TIMESTAMP              COMMENT '생성일시',
    updated_dt      DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사원 기본 마스터';


-- 발령 이력 테이블
CREATE TABLE IF NOT EXISTS emp_appoint (
    appoint_id      INT          NOT NULL AUTO_INCREMENT COMMENT '발령ID',
    emp_id          VARCHAR(20)  NOT NULL             COMMENT '사번',
    appoint_dt      DATE         NOT NULL             COMMENT '발령일',
    appoint_type    VARCHAR(30)                       COMMENT '발령종류',
    from_dept_nm    VARCHAR(200)                      COMMENT '이전부서',
    to_dept_nm      VARCHAR(200)                      COMMENT '발령부서',
    from_position   VARCHAR(50)                       COMMENT '이전직위',
    to_position     VARCHAR(50)                       COMMENT '발령직위',
    from_title      VARCHAR(50)                       COMMENT '이전직책',
    to_title        VARCHAR(50)                       COMMENT '발령직책',
    remark          VARCHAR(500)                      COMMENT '비고',
    created_dt      DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (appoint_id),
    KEY idx_emp_id (emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='발령이력';


-- 가족사항 테이블
CREATE TABLE IF NOT EXISTS emp_family (
    family_id       INT          NOT NULL AUTO_INCREMENT COMMENT '가족ID',
    emp_id          VARCHAR(20)  NOT NULL             COMMENT '사번',
    relation        VARCHAR(20)                       COMMENT '관계',
    family_nm       VARCHAR(50)                       COMMENT '성명',
    family_birth_dt DATE                              COMMENT '생년월일',
    family_gender   CHAR(1)                           COMMENT '성별',
    live_together   CHAR(1)      DEFAULT 'Y'          COMMENT '동거여부',
    PRIMARY KEY (family_id),
    KEY idx_emp_id (emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='가족사항';


-- 학력 테이블
CREATE TABLE IF NOT EXISTS emp_education (
    edu_id          INT          NOT NULL AUTO_INCREMENT COMMENT '학력ID',
    emp_id          VARCHAR(20)  NOT NULL             COMMENT '사번',
    school_nm       VARCHAR(200)                      COMMENT '학교명',
    major           VARCHAR(100)                      COMMENT '전공',
    edu_level       VARCHAR(20)                       COMMENT '학력구분',
    enter_dt        DATE                              COMMENT '입학일',
    graduate_dt     DATE                              COMMENT '졸업일',
    graduate_type   VARCHAR(20)                       COMMENT '졸업구분',
    PRIMARY KEY (edu_id),
    KEY idx_emp_id (emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='학력사항';


-- 경력 테이블
CREATE TABLE IF NOT EXISTS emp_career (
    career_id       INT          NOT NULL AUTO_INCREMENT COMMENT '경력ID',
    emp_id          VARCHAR(20)  NOT NULL             COMMENT '사번',
    company_nm      VARCHAR(200)                      COMMENT '회사명',
    dept_nm         VARCHAR(100)                      COMMENT '부서',
    position_nm     VARCHAR(50)                       COMMENT '직위',
    join_dt         DATE                              COMMENT '입사일',
    resign_dt       DATE                              COMMENT '퇴사일',
    duty_nm         VARCHAR(200)                      COMMENT '담당업무',
    remark          VARCHAR(500)                      COMMENT '비고',
    PRIMARY KEY (career_id),
    KEY idx_emp_id (emp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='경력사항';


-- 샘플 데이터
INSERT IGNORE INTO emp_master (
    emp_id, emp_nm, emp_nm_hanja, emp_nm_eng, emp_gender, emp_birth_dt, emp_ssn,
    work_status, corp_cd, corp_nm, grp_join_dt, corp_join_dt,
    dept_cd, dept_nm, position_nm, title_nm, work_so,
    mobile_no, office_tel, home_tel,
    edu_level, job_type, duty_nm, corp_email, personal_email,
    marital_status, home_addr, emp_nationality
) VALUES
('EMP001','홍길동','洪吉童','HONG GIL DONG','M','1985-03-15','850315-1234567',
 '1','DL001','(주)딜라이브','2010-03-02','2010-03-02',
 'DEPT001','방송본부 편성팀','차장','팀장','서울SO',
 '010-1234-5678','02-1234-5678','02-1111-2222',
 '대학교졸','PD','채널편성 및 프로그램 기획','gdhong@dlive.kr','hong@gmail.com',
 '기혼','서울특별시 강남구 테헤란로 123','내국인'),
('EMP002','김영희','金英姬','KIM YOUNG HEE','F','1990-07-22','900722-2345678',
 '1','DL001','(주)딜라이브','2015-07-01','2015-07-01',
 'DEPT002','경영지원팀','대리','','서울SO',
 '010-2345-6789','02-2345-6789','',
 '대학교졸','경영','인사급여관리','yhkim@dlive.kr','yhkim@naver.com',
 '미혼','서울특별시 마포구 상암로 456','내국인'),
('EMP003','이철수','李哲洙','LEE CHUL SU','M','1982-11-30','821130-1345678',
 '1','DL001','(주)딜라이브','2008-01-15','2008-01-15',
 'DEPT003','IT기술팀','부장','파트장','경기SO',
 '010-3456-7890','031-345-6789','031-222-3333',
 '대학원졸','IT','시스템 인프라 관리','cslee@dlive.kr','cslee@gmail.com',
 '기혼','경기도 수원시 영통구 789','내국인');
