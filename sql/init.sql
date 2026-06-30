-- ============================================================
-- HR 인사관리 시스템 DB 초기화 SQL
-- Database: dlive_insa
-- ============================================================

USE dlive_insa;

-- 사원 기본 마스터 테이블
CREATE TABLE IF NOT EXISTS PHM_EMP_C (    
    EMP_ID              INT NOT NULL             COMMENT '사원id',
    COMPANY_CD          VARCHAR(10) NOT NULL       COMMENT '인사영역',
    EMP_NO              VARCHAR(10) NOT NULL       COMMENT '사원번호',
    EMP_NM              VARCHAR(40)                COMMENT '사원성명',
    ENG_NM              VARCHAR(40)                COMMENT '사원성명(영문)',
    CHI_NM              VARCHAR(40)                COMMENT '사원성명(한문)',
    CTZ_NO              VARCHAR(13)                COMMENT '주민번호',
    EMP_KIND_CD         VARCHAR(10)                COMMENT '직원구분코드 [PHM_EMP_KIND_CD]',
    HIRE_CD             VARCHAR(10)                COMMENT '채용구분코드 [CAM_CAU_CD]',
    IN_OFFI_YN          CHAR(1)                     COMMENT '재직여부',
    SEX_CD              VARCHAR(10)                COMMENT '성별코드(PHM_SEX_CD)',
    BIRTH_YMD           DATE                        COMMENT '생년월일',
    SOLAR_TYPE          CHAR(1)                     COMMENT '음양구분(1:양, 2:음)',
    POS_GRD_CD          VARCHAR(10)                COMMENT '직급코드 [PHM_POS_GRD_CD]',
    POS_GRD_YMD         DATE                        COMMENT '직급승진일',
    NEXT_POS_GRD_YMD    DATE                        COMMENT '차기직급승진일',
    POS_CD              VARCHAR(10)                COMMENT '직위코드 [PHM_POS_CD]',
    POS_YMD             DATE                        COMMENT '직위임용일',
    YEARNUM             VARCHAR(2)                 COMMENT '호봉',
    YEARNUM_YMD         DATE                        COMMENT '호봉승급일',
    NEXT_YEARNUM_YMD    DATE                        COMMENT '차기호봉승급일',
    ORG_CD              VARCHAR(10)                COMMENT '발령부서코드',
    ORG_YMD             DATE                        COMMENT '발령부서전입일',
    PAY_KIND_CD         VARCHAR(10)                COMMENT '급여구분코드 [CAM015]',
    PAY_ORG_CD          VARCHAR(10)                COMMENT '급여부서코드',
    WORK_ORG_CD         VARCHAR(10)                COMMENT '근무부서코드',
    WORK_ORG_YMD        DATE                        COMMENT '근무부서전입일',
    DUTY_CD             VARCHAR(10)                COMMENT '직책코드 [PHM_CALL_CD]',
    DUTY_YMD            DATE                        COMMENT '직책부여일',
    CALL_CD             VARCHAR(10)                COMMENT '호칭코드',
    CALL_YMD            DATE                        COMMENT '호칭부여일',
    JOB_CD              VARCHAR(10)                COMMENT '직무코드',
    JOB_YMD             DATE                        COMMENT '직무담당일',
    HIRE_YMD            DATE NOT NULL               COMMENT '입사일자',
    ANNUAL_CAL_YMD      DATE                        COMMENT '연차기산일',
    RETIRE_YMD          DATE                        COMMENT '퇴직일',
    RETIRE_PLAN_YMD     DATE                        COMMENT '퇴직예정일',
    RETIRE_TYPE_CD      VARCHAR(10)                COMMENT '퇴직구분코드 [CAM_CAU_CD]',
    TRAINING_S_YMD      DATE                        COMMENT '수습시작일자',
    TRAINING_E_YMD      DATE                        COMMENT '수습종료일자',
    EMP_KIND_SUB_CD     VARCHAR(10)                COMMENT '직원세부구분 [PHM_EMP_STYPE_CD]',
    REPREDUTY_CD        VARCHAR(10)                COMMENT '대표담당업무',
    FILE_NM             VARCHAR(100)               COMMENT '사진파일명',
    FILE_ID             VARCHAR(100)               COMMENT '사진파일ID',
    ANNUAL_DD           INT(3)                   COMMENT '연차보전일수',
    MOD_USER_ID         INT NOT NULL             COMMENT '변경자',
    MOD_DATE            DATE NOT NULL               COMMENT '변경일',
    CON_YMD             DATE                        COMMENT '계약종료예정일',
    PRIMARY KEY (EMP_ID)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='인사기본';


-- 발령 이력 테이블
CREATE TABLE IF NOT EXISTS CAM_HISTORY_C
(    
    CAM_HISTORY_ID  INT          NOT NULL    COMMENT '발령이력ID',
    EMP_ID          INT          NOT NULL    COMMENT '사원ID',
    STA_YMD         DATE            NOT NULL    COMMENT '발령일자',
    END_YMD         DATE            NOT NULL    COMMENT '발령종료일',
    WRITE_DATE      DATE            NOT NULL    COMMENT '투입일시',
    TYPE_CD         VARCHAR(10)    NOT NULL    COMMENT '발령유형코드 [CAM_TYPE_CD]',
    CAU_CD          VARCHAR(10)                COMMENT '발령사유코드 [CAM_CAU_CD]',
    CAM_DOC_ID      INT          NOT NULL    COMMENT '발령품의서ID',
    COMPANY_CD      VARCHAR(10)                COMMENT '발령인사영역 [PHM_COMPANY_CD]',
    ORG_CD          VARCHAR(10)                COMMENT '발령부서',
    POS_CD          VARCHAR(10)                COMMENT '발령직위 [PHM_POS_CD]',
    POS_GRD_CD      VARCHAR(10)                COMMENT '발령직급 [PHM_POS_GRD_CD]',
    JOB_CD          VARCHAR(10)                COMMENT '발령직렬',
    DUTY_CD         VARCHAR(10)                COMMENT '발령직책 [PHM_CALL_CD]',
    CALL_CD         VARCHAR(10)                COMMENT '발령호칭',
    EMP_KIND_CD     VARCHAR(10)                COMMENT '발령직원구분 [PHM_EMP_KIND_CD]',
    COMPANY_CHN_YN  CHAR(1)         NOT NULL    COMMENT '인사영역변경여부',
    ORG_CHN_YN      CHAR(1)         NOT NULL    COMMENT '부서변경여부',
    POS_CHN_YN      CHAR(1)         NOT NULL    COMMENT '직위변경여부',
    POS_GRD_CHN_YN  CHAR(1)         NOT NULL    COMMENT '직급변경여부',
    JOB_CHN_YN      CHAR(1)         NOT NULL    COMMENT '직무변경여부',
    DUTY_CHN_YN     CHAR(1)         NOT NULL    COMMENT '호칭변경여부',
    EMP_KIND_CHN_YN CHAR(1)         NOT NULL    COMMENT '직원구분변경여부',
    HIRE_YN         CHAR(1)         NOT NULL    COMMENT '채용여부',
    RETIRE_YN       CHAR(1)         NOT NULL    COMMENT '퇴직여부',    
    SEND_YN         CHAR(1)                     COMMENT '겸직여부',
    REST_YN         CHAR(1)                     COMMENT '휴직여부',
    REN_YMD         DATE                        COMMENT '휴직복직예정일',
    BABY_YMD        DATE                        COMMENT '출산예정일',
    REST_RTN_YN     CHAR(1)                     COMMENT '휴직복직여부',
    DIS_YN          CHAR(1)                     COMMENT '파견여부',
    DIS_KIND_CD     VARCHAR(10)                COMMENT '파견구분 [CAM_DIS_KIND_CD]',
    DIS_RTN_YMD     DATE                        COMMENT '파견복귀예정일',
    DIS_ORG_CD      VARCHAR(10)                COMMENT '파견부서코드',
    DIS_AREA_NM     VARCHAR(40)                COMMENT '파견처명',
    DIS_RTN_YN      CHAR(1)                     COMMENT '파견복직여부',
    HIRE_CD         VARCHAR(10)                COMMENT '채용구분코드_사용하지 않음 [PHM_HIRE_CD]',
    YEARNUM         VARCHAR(2)                 COMMENT '발령호봉',
    YEARNUM_CHN_YN  CHAR(1)                     COMMENT '호봉변경여부',
    REASON_CD       VARCHAR(10)                COMMENT '채용구분 [CAM_REASON_CD]',
    MAS_YN          CHAR(1)                     COMMENT '인사반영여부',
    NOTE            VARCHAR(200)               COMMENT '비고',
    MOD_USER_ID     INT          NOT NULL    COMMENT '변경자',
    MOD_DATE        DATE            NOT NULL    COMMENT '변경일',
    OUT_NOTE        VARCHAR(100)               COMMENT '퇴직사유',
    OUT_YMD         DATE                        COMMENT '퇴직일자',
    DIS_POS_CD      VARCHAR(10)                COMMENT '파견직위',
    DIS_DUTY_CD     VARCHAR(10)                COMMENT '파견직책',
    DIS_POS_GRD_CD  VARCHAR(10)                COMMENT '파견지점',
    CON_YMD         DATE                        COMMENT '계약종료예정일',
    
    PRIMARY KEY (CAM_HISTORY_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='발령이력';




-- 조직 테이블
CREATE TABLE IF NOT EXISTS ORM_ORG_C
(
    ORM_ORG_ID      INT NOT NULL         COMMENT '조직정보ID',
    COMPANY_CD      VARCHAR(10) NOT NULL    COMMENT '인사영역 [PHM_COMPANY_CD]',
    ORG_CD          VARCHAR(10) NOT NULL    COMMENT '조직코드',
    STA_YMD         DATE NOT NULL           COMMENT '적용시작일자',
    END_YMD         DATE NOT NULL           COMMENT '적용종료일자',
    ORG_NM          VARCHAR(100)            COMMENT '소속명',
    SHORT_NM        VARCHAR(100)            COMMENT '조직약명',
    FULL_NM         VARCHAR(100)            COMMENT '조직전체명',
    ENG_NM          VARCHAR(100)            COMMENT '조직영문명',
    HR_ORG_NM       VARCHAR(40)             COMMENT '인사조직명',
    SUPER_ORG_CD    VARCHAR(10)             COMMENT '상위조직코드',
    MGR_ORG_CD      VARCHAR(10)             COMMENT '사업본부조직코드',
    CONTROL_ORG_CD  VARCHAR(10)             COMMENT '관리조직코드',
    ORG_TYPE_CD     VARCHAR(10)             COMMENT '계층코드 [ORM_ORG_LEVEL_CD]',
    WORK_AREA_CD    VARCHAR(10)             COMMENT '작업장코드 [ORM_WORK_AREA_CD]',
    COST_ORG_CD     VARCHAR(10)             COMMENT '코스트센터',
    SQ              VARCHAR(20)             COMMENT '조직순차',
    ORG_REASON_CD   VARCHAR(10)             COMMENT '조직변경사유코드 [ORM_REASON_CD]',
    REG_ORG_YN      CHAR(1)                 COMMENT '공식조직유무',
    ORG_LINE        VARCHAR(500)            COMMENT '조직라인',
    ORG_S_YMD       DATE                    COMMENT '개설일자',
    ORG_E_YMD       DATE                    COMMENT '폐쇄일자',
    ORG_ETC_CD1     VARCHAR(10)             COMMENT '기타코드1',
    ORG_ETC_CD2     VARCHAR(10)             COMMENT '기타코드2',
    ORG_ETC_CD3     VARCHAR(10)             COMMENT '기타코드3',
    NOTE            VARCHAR(200)            COMMENT '비고',
    MOD_USER_ID     INT NOT NULL         COMMENT '변경자',
    MOD_DATE        DATE NOT NULL       COMMENT '변경일' ,
    
    PRIMARY KEY (ORM_ORG_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='조직정보';


-- 공통코드 테이블
CREATE TABLE IF NOT EXISTS XFRMD2C
(
    CD_ID       INT         NOT NULL     COMMENT '코드ID',
    CD          VARCHAR(10)   NOT NULL     COMMENT '코드',
    CD_NM       VARCHAR(100)               COMMENT '코드명',
    SYSTEM_CD   VARCHAR(10)                COMMENT '시스템코드',
    SHORT_NM    VARCHAR(40)                COMMENT '코드약명',
    FOR_NM      VARCHAR(100)               COMMENT '외국어명',
    COMPANY_CD  VARCHAR(10)   NOT NULL     COMMENT '회사코드(인사영역)',
    CD_KIND     VARCHAR(100)  NOT NULL     COMMENT '코드분류',
    STA_YMD     DATE           NOT NULL     COMMENT '생성일자',
    END_YMD     DATE           NOT NULL     COMMENT '종료일자',
    PRINT_NM    VARCHAR(100)               COMMENT '출력명',
    ORD_NO      VARCHAR(10)                COMMENT '정렬순서',
    CONV_CD     VARCHAR(20)                COMMENT '변환코드',
    ETC_CD1     VARCHAR(100)               COMMENT '기타코드1',
    ETC_CD2     VARCHAR(100)               COMMENT '기타코드2',
    ETC_CD3     VARCHAR(100)               COMMENT '기타코드3',
    ETC_CD4     VARCHAR(100)               COMMENT '기타코드4',
    ETC_CD5     VARCHAR(100)               COMMENT '기타코드5',
    ETC_CD6     VARCHAR(100)               COMMENT '기타코드6',
    ETC_CD7     VARCHAR(100)               COMMENT '기타코드7',
    ETC_CD8     VARCHAR(100)               COMMENT '기타코드8',
    ETC_CD9     VARCHAR(100)               COMMENT '기타코드9',
    ETC_CD10    VARCHAR(100)               COMMENT '기타코드10',
    NOTE        VARCHAR(100)               COMMENT '비고',
    MOD_USER_ID INT                      COMMENT '변경자',
    MOD_DATE    DATE                        COMMENT '변경일시',
    
    PRIMARY KEY (CD_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공통코드';




-- ============================================================
-- 샘플 데이터
-- ============================================================

-- 공통코드 (XFRMD2C)
INSERT INTO XFRMD2C (CD_ID, CD, CD_NM, COMPANY_CD, CD_KIND, STA_YMD, END_YMD, ORD_NO, MOD_USER_ID, MOD_DATE) VALUES
-- 회사코드
(1,  'D001', '디라이브',   'D001', 'PHM_COMPANY_CD',  '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
-- 성별코드
(2,  'M',    '남성',       'D001', 'PHM_SEX_CD',       '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(3,  'F',    '여성',       'D001', 'PHM_SEX_CD',       '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
-- 직급코드
(4,  'G1',   '사원',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(5,  'G2',   '주임',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
(6,  'G3',   '대리',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '3', 1, '2024-01-01'),
(7,  'G4',   '과장',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '4', 1, '2024-01-01'),
(8,  'G5',   '차장',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '5', 1, '2024-01-01'),
(9,  'G6',   '부장',       'D001', 'PHM_POS_GRD_CD',   '2020-01-01', '9999-12-31', '6', 1, '2024-01-01'),
-- 직위코드
(10, 'P1',   '사원',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(11, 'P2',   '주임',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
(12, 'P3',   '대리',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '3', 1, '2024-01-01'),
(13, 'P4',   '과장',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '4', 1, '2024-01-01'),
(14, 'P5',   '차장',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '5', 1, '2024-01-01'),
(15, 'P6',   '부장',       'D001', 'PHM_POS_CD',       '2020-01-01', '9999-12-31', '6', 1, '2024-01-01'),
-- 직책코드
(16, 'C1',   '팀원',       'D001', 'PHM_CALL_CD',      '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(17, 'C2',   '팀장',       'D001', 'PHM_CALL_CD',      '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
(18, 'C3',   '실장',       'D001', 'PHM_CALL_CD',      '2020-01-01', '9999-12-31', '3', 1, '2024-01-01'),
(19, 'C4',   '본부장',     'D001', 'PHM_CALL_CD',      '2020-01-01', '9999-12-31', '4', 1, '2024-01-01'),
-- 직원구분코드
(20, 'E1',   '정규직',     'D001', 'PHM_EMP_KIND_CD',  '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(21, 'E2',   '계약직',     'D001', 'PHM_EMP_KIND_CD',  '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
-- 발령유형코드
(22, 'T1',   '신규발령',   'D001', 'CAM_TYPE_CD',      '2020-01-01', '9999-12-31', '1', 1, '2024-01-01'),
(23, 'T2',   '부서이동',   'D001', 'CAM_TYPE_CD',      '2020-01-01', '9999-12-31', '2', 1, '2024-01-01'),
(24, 'T3',   '직위변경',   'D001', 'CAM_TYPE_CD',      '2020-01-01', '9999-12-31', '3', 1, '2024-01-01'),
(25, 'T4',   '직급변경',   'D001', 'CAM_TYPE_CD',      '2020-01-01', '9999-12-31', '4', 1, '2024-01-01');


-- 조직정보 (ORM_ORG_C)
INSERT INTO ORM_ORG_C (ORM_ORG_ID, COMPANY_CD, ORG_CD, STA_YMD, END_YMD, ORG_NM, SHORT_NM, FULL_NM, SUPER_ORG_CD, MOD_USER_ID, MOD_DATE) VALUES
(1, 'D001', 'ORG001', '2020-01-01', '9999-12-31', '본사',      '본사',    '디라이브 본사',      NULL,     1, '2024-01-01'),
(2, 'D001', 'ORG010', '2020-01-01', '9999-12-31', '개발팀',    '개발',    '디라이브 개발팀',    'ORG001', 1, '2024-01-01'),
(3, 'D001', 'ORG020', '2020-01-01', '9999-12-31', '기획팀',    '기획',    '디라이브 기획팀',    'ORG001', 1, '2024-01-01'),
(4, 'D001', 'ORG030', '2020-01-01', '9999-12-31', '마케팅팀',  '마케팅',  '디라이브 마케팅팀',  'ORG001', 1, '2024-01-01'),
(5, 'D001', 'ORG040', '2020-01-01', '9999-12-31', '인사팀',    '인사',    '디라이브 인사팀',    'ORG001', 1, '2024-01-01'),
(6, 'D001', 'ORG050', '2020-01-01', '9999-12-31', '영업팀',    '영업',    '디라이브 영업팀',    'ORG001', 1, '2024-01-01');


-- 인사마스터 (PHM_EMP_C) - 직원 10명
INSERT INTO PHM_EMP_C (EMP_ID, COMPANY_CD, EMP_NO, EMP_NM, ENG_NM, CHI_NM, CTZ_NO,
    EMP_KIND_CD, IN_OFFI_YN, SEX_CD, BIRTH_YMD, POS_GRD_CD, POS_CD, ORG_CD,
    HIRE_YMD, ANNUAL_CAL_YMD, DUTY_CD, JOB_CD, REPREDUTY_CD, WORK_ORG_CD,
    MOD_USER_ID, MOD_DATE) VALUES
(1,  'D001', 'E001', '김철수', 'Kim Cheol-su',   '金哲洙', '8501011000000', 'E1', 'Y', 'M', '1985-01-01', 'G4', 'P4', 'ORG010', '2015-03-02', '2015-03-02', 'C1', 'DEV',   '소프트웨어개발', 'ORG010', 1, '2024-01-01'),
(2,  'D001', 'E002', '이영희', 'Lee Young-hee',  '李英姬', '9203052000000', 'E1', 'Y', 'F', '1992-03-05', 'G3', 'P3', 'ORG020', '2018-07-01', '2018-07-01', 'C1', 'PLAN',  '서비스기획',    'ORG020', 1, '2024-01-01'),
(3,  'D001', 'E003', '박민준', 'Park Min-jun',   '朴民俊', '8009151000000', 'E1', 'Y', 'M', '1980-09-15', 'G6', 'P6', 'ORG030', '2010-05-10', '2010-05-10', 'C2', 'MKT',   '마케팅전략',    'ORG030', 1, '2024-01-01'),
(4,  'D001', 'E004', '최수진', 'Choi Su-jin',    '崔秀珍', '8312282000000', 'E1', 'Y', 'F', '1983-12-28', 'G5', 'P5', 'ORG040', '2012-09-01', '2012-09-01', 'C2', 'HR',    '인사제도운영',  'ORG040', 1, '2024-01-01'),
(5,  'D001', 'E005', '정호준', 'Jeong Ho-jun',   '鄭浩俊', '9507201000000', 'E1', 'Y', 'M', '1995-07-20', 'G2', 'P2', 'ORG010', '2021-02-01', '2021-02-01', 'C1', 'DEV',   '백엔드개발',    'ORG010', 1, '2024-01-01'),
(6,  'D001', 'E006', '강지은', 'Kang Ji-eun',    '姜智恩', '9811152000000', 'E2', 'Y', 'F', '1998-11-15', 'G1', 'P1', 'ORG050', '2023-03-06', '2023-03-06', 'C1', 'SALES', '영업지원',      'ORG050', 1, '2024-01-01'),
(7,  'D001', 'E007', '윤재현', 'Yoon Jae-hyun',  '尹載鉉', '9201101000000', 'E1', 'Y', 'M', '1992-01-10', 'G3', 'P3', 'ORG010', '2019-04-01', '2019-04-01', 'C1', 'DEV',   '프론트엔드개발','ORG010', 1, '2024-01-01'),
(8,  'D001', 'E008', '임소현', 'Lim So-hyun',    '林素賢', '8806252000000', 'E1', 'Y', 'F', '1988-06-25', 'G4', 'P4', 'ORG020', '2014-08-11', '2014-08-11', 'C1', 'PLAN',  'UX기획',        'ORG020', 1, '2024-01-01'),
(9,  'D001', 'E009', '한동현', 'Han Dong-hyun',  '韓東現', '8103181000000', 'E1', 'Y', 'M', '1981-03-18', 'G5', 'P5', 'ORG030', '2011-11-15', '2011-11-15', 'C2', 'MKT',   '브랜드마케팅',  'ORG030', 1, '2024-01-01'),
(10, 'D001', 'E010', '서지현', 'Seo Ji-hyun',    '徐志賢', '9605282000000', 'E2', 'Y', 'F', '1996-05-28', 'G1', 'P1', 'ORG040', '2022-07-04', '2022-07-04', 'C1', 'HR',    '채용지원',      'ORG040', 1, '2024-01-01');


-- 발령이력 (CAM_HISTORY_C)
INSERT INTO CAM_HISTORY_C (CAM_HISTORY_ID, EMP_ID, STA_YMD, END_YMD, WRITE_DATE, TYPE_CD, CAM_DOC_ID,
    COMPANY_CD, ORG_CD, POS_CD, POS_GRD_CD, DUTY_CD,
    COMPANY_CHN_YN, ORG_CHN_YN, POS_CHN_YN, POS_GRD_CHN_YN, JOB_CHN_YN, DUTY_CHN_YN, EMP_KIND_CHN_YN,
    HIRE_YN, RETIRE_YN, MAS_YN, NOTE, MOD_USER_ID, MOD_DATE) VALUES
-- 김철수 (1): 신규→대리승진→과장승진
(1,  1, '2015-03-02', '2017-12-31', '2015-03-02', 'T1', 1,  'D001', 'ORG010', 'P2', 'G2', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2015-03-02'),
(2,  1, '2018-01-01', '2020-12-31', '2018-01-01', 'T4', 2,  'D001', 'ORG010', 'P3', 'G3', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '대리 승진',              1, '2018-01-01'),
(3,  1, '2021-01-01', '9999-12-31', '2021-01-01', 'T4', 3,  'D001', 'ORG010', 'P4', 'G4', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '과장 승진',              1, '2021-01-01'),
-- 이영희 (2): 신규→대리승진
(4,  2, '2018-07-01', '2021-06-30', '2018-07-01', 'T1', 4,  'D001', 'ORG020', 'P1', 'G1', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2018-07-01'),
(5,  2, '2021-07-01', '9999-12-31', '2021-07-01', 'T4', 5,  'D001', 'ORG020', 'P3', 'G3', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '대리 승진',              1, '2021-07-01'),
-- 박민준 (3): 신규→차장승진→부장승진/팀장
(6,  3, '2010-05-10', '2014-12-31', '2010-05-10', 'T1', 6,  'D001', 'ORG030', 'P4', 'G4', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2010-05-10'),
(7,  3, '2015-01-01', '2018-12-31', '2015-01-01', 'T4', 7,  'D001', 'ORG030', 'P5', 'G5', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '차장 승진',              1, '2015-01-01'),
(8,  3, '2019-01-01', '9999-12-31', '2019-01-01', 'T4', 8,  'D001', 'ORG030', 'P6', 'G6', 'C2', 'N','N','Y','Y','N','Y','N', 'N','N', 'Y', '부장 승진 및 팀장 부여', 1, '2019-01-01'),
-- 최수진 (4): 신규(기획팀)→인사팀이동→차장승진/팀장
(9,  4, '2012-09-01', '2015-12-31', '2012-09-01', 'T1', 9,  'D001', 'ORG020', 'P3', 'G3', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2012-09-01'),
(10, 4, '2016-01-01', '2019-12-31', '2016-01-01', 'T2', 10, 'D001', 'ORG040', 'P3', 'G3', 'C1', 'N','Y','N','N','N','N','N', 'N','N', 'Y', '인사팀 이동',            1, '2016-01-01'),
(11, 4, '2020-01-01', '9999-12-31', '2020-01-01', 'T4', 11, 'D001', 'ORG040', 'P5', 'G5', 'C2', 'N','N','Y','Y','N','Y','N', 'N','N', 'Y', '차장 승진 및 팀장 부여', 1, '2020-01-01'),
-- 정호준 (5): 신규→주임승진
(12, 5, '2021-02-01', '2023-12-31', '2021-02-01', 'T1', 12, 'D001', 'ORG010', 'P1', 'G1', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2021-02-01'),
(13, 5, '2024-01-01', '9999-12-31', '2024-01-01', 'T4', 13, 'D001', 'ORG010', 'P2', 'G2', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '주임 승진',              1, '2024-01-01'),
-- 강지은 (6): 신규(계약직)
(14, 6, '2023-03-06', '9999-12-31', '2023-03-06', 'T1', 14, 'D001', 'ORG050', 'P1', 'G1', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사(계약직)',        1, '2023-03-06'),
-- 윤재현 (7): 신규→대리승진
(15, 7, '2019-04-01', '2022-03-31', '2019-04-01', 'T1', 15, 'D001', 'ORG010', 'P1', 'G1', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2019-04-01'),
(16, 7, '2022-04-01', '9999-12-31', '2022-04-01', 'T4', 16, 'D001', 'ORG010', 'P3', 'G3', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '대리 승진',              1, '2022-04-01'),
-- 임소현 (8): 신규(마케팅팀)→기획팀이동→과장승진
(17, 8, '2014-08-11', '2015-12-31', '2014-08-11', 'T1', 17, 'D001', 'ORG030', 'P2', 'G2', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2014-08-11'),
(18, 8, '2016-01-01', '2018-12-31', '2016-01-01', 'T2', 18, 'D001', 'ORG020', 'P2', 'G2', 'C1', 'N','Y','N','N','N','N','N', 'N','N', 'Y', '기획팀 이동',            1, '2016-01-01'),
(19, 8, '2019-01-01', '9999-12-31', '2019-01-01', 'T4', 19, 'D001', 'ORG020', 'P4', 'G4', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '과장 승진',              1, '2019-01-01'),
-- 한동현 (9): 신규→직위변경→차장승진/팀장
(20, 9, '2011-11-15', '2014-12-31', '2011-11-15', 'T1', 20, 'D001', 'ORG030', 'P3', 'G3', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사',               1, '2011-11-15'),
(21, 9, '2015-01-01', '2019-12-31', '2015-01-01', 'T3', 21, 'D001', 'ORG030', 'P4', 'G4', 'C1', 'N','N','Y','Y','N','N','N', 'N','N', 'Y', '직위 변경',              1, '2015-01-01'),
(22, 9, '2020-01-01', '9999-12-31', '2020-01-01', 'T4', 22, 'D001', 'ORG030', 'P5', 'G5', 'C2', 'N','N','Y','Y','N','Y','N', 'N','N', 'Y', '차장 승진 및 팀장 부여', 1, '2020-01-01'),
-- 서지현 (10): 신규(계약직)
(23, 10, '2022-07-04', '9999-12-31', '2022-07-04', 'T1', 23, 'D001', 'ORG040', 'P1', 'G1', 'C1', 'N','N','N','N','N','N','N', 'Y','N', 'Y', '신규입사(계약직)',       1, '2022-07-04');
