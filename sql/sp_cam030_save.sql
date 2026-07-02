-- ============================================================
-- 발령내역관리 저장 프로시저 (CAM_030)
-- 신규(camHistoryId=0): INSERT, 수정: UPDATE
-- 실행: MySQL Workbench 또는 CLI에서 dlive_insa DB 선택 후 실행
-- ============================================================

USE dlive_insa;

DROP PROCEDURE IF EXISTS sp_cam030_save;

DELIMITER //

CREATE PROCEDURE sp_cam030_save(
    IN p_cam_history_id INT,        -- 0 = 신규, 양수 = 수정 대상 ID
    IN p_emp_id         INT,        -- 사원ID
    IN p_sta_ymd        VARCHAR(10),-- 발령일자 (YYYY-MM-DD)
    IN p_type_cd        VARCHAR(10),-- 발령유형코드
    IN p_cau_cd         VARCHAR(10),-- 발령사유코드
    IN p_company_cd     VARCHAR(10),-- 발령인사영역
    IN p_org_cd         VARCHAR(10),-- 발령부서코드
    IN p_pos_cd         VARCHAR(10),-- 발령직위코드
    IN p_duty_cd        VARCHAR(10),-- 발령직책코드
    IN p_emp_kind_cd    VARCHAR(10),-- 직원구분코드
    IN p_yearnum        VARCHAR(2), -- 호봉
    IN p_hirec_cd       VARCHAR(10),-- 채용구분코드
    IN p_send_nm        VARCHAR(40),-- 겸직내역
    IN p_rest_yn        CHAR(1),    -- 휴직여부 Y/N
    IN p_ren_ymd        VARCHAR(10),-- 복직예정일
    IN p_baby_ymd       VARCHAR(10),-- 출산예정일
    IN p_con_ymd        VARCHAR(10),-- 계약종료예정일
    IN p_dis_yn         CHAR(1),    -- 파견여부 Y/N
    IN p_dis_kind_cd    VARCHAR(10),-- 파견구분코드
    IN p_dis_rtn_ymd    VARCHAR(10),-- 파견복귀예정일
    IN p_dis_org_cd     VARCHAR(10),-- 파견부서코드
    IN p_dis_pos_cd     VARCHAR(10),-- 파견직위코드
    IN p_dis_duty_cd    VARCHAR(10),-- 파견직책코드
    IN p_dis_pos_grd_cd VARCHAR(10),-- 파견지점코드
    IN p_mod_user_id    INT         -- 변경자ID
)
BEGIN
    DECLARE v_new_id   INT DEFAULT 0;
    DECLARE v_org_chg  CHAR(1) DEFAULT 'N';
    DECLARE v_pos_chg  CHAR(1) DEFAULT 'N';
    DECLARE v_duty_chg CHAR(1) DEFAULT 'N';
    DECLARE v_kind_chg CHAR(1) DEFAULT 'N';
    DECLARE v_cur_org  VARCHAR(10) DEFAULT NULL;
    DECLARE v_cur_pos  VARCHAR(10) DEFAULT NULL;
    DECLARE v_cur_duty VARCHAR(10) DEFAULT NULL;
    DECLARE v_cur_kind VARCHAR(10) DEFAULT NULL;

    -- 현재 사원 정보 조회 (변경여부 계산용)
    SELECT ORG_CD, POS_CD, DUTY_CD, EMP_KIND_CD
    INTO   v_cur_org, v_cur_pos, v_cur_duty, v_cur_kind
    FROM   PHM_EMP_C
    WHERE  EMP_ID = p_emp_id;

    -- 변경여부 판단
    IF p_org_cd IS NOT NULL AND p_org_cd != '' AND p_org_cd != COALESCE(v_cur_org, '') THEN
        SET v_org_chg = 'Y';
    END IF;
    IF p_pos_cd IS NOT NULL AND p_pos_cd != '' AND p_pos_cd != COALESCE(v_cur_pos, '') THEN
        SET v_pos_chg = 'Y';
    END IF;
    IF p_duty_cd IS NOT NULL AND p_duty_cd != '' AND p_duty_cd != COALESCE(v_cur_duty, '') THEN
        SET v_duty_chg = 'Y';
    END IF;
    IF p_emp_kind_cd IS NOT NULL AND p_emp_kind_cd != '' AND p_emp_kind_cd != COALESCE(v_cur_kind, '') THEN
        SET v_kind_chg = 'Y';
    END IF;

    IF p_cam_history_id = 0 THEN
        -- ── 신규 등록 ──────────────────────────────────────────
        SELECT COALESCE(MAX(CAM_HISTORY_ID), 0) + 1 INTO v_new_id FROM CAM_HISTORY_C;

        INSERT INTO CAM_HISTORY_C (
            CAM_HISTORY_ID, EMP_ID, STA_YMD, END_YMD, WRITE_DATE,
            TYPE_CD, CAU_CD, CAM_DOC_ID,
            COMPANY_CD, ORG_CD, POS_CD, DUTY_CD, EMP_KIND_CD, YEARNUM, HIRE_CD,
            COMPANY_CHN_YN, ORG_CHN_YN, POS_CHN_YN, POS_GRD_CHN_YN,
            JOB_CHN_YN,     DUTY_CHN_YN, EMP_KIND_CHN_YN,
            HIRE_YN, RETIRE_YN,
            REST_YN,  REN_YMD,    BABY_YMD,  CON_YMD,
            DIS_YN,   DIS_KIND_CD, DIS_RTN_YMD, DIS_ORG_CD,
            DIS_POS_CD, DIS_DUTY_CD, DIS_POS_GRD_CD,
            MAS_YN, NOTE, OUT_NOTE,
            MOD_USER_ID, MOD_DATE
        ) VALUES (
            v_new_id, p_emp_id, p_sta_ymd, '9999-12-31', CURDATE(),
            p_type_cd,
            NULLIF(p_cau_cd, ''),
            0,
            NULLIF(p_company_cd, ''),
            NULLIF(p_org_cd, ''),
            NULLIF(p_pos_cd, ''),
            NULLIF(p_duty_cd, ''),
            NULLIF(p_emp_kind_cd, ''),
            NULLIF(p_yearnum, ''),
            NULLIF(p_hirec_cd, ''),
            'N', v_org_chg, v_pos_chg, 'N',
            'N', v_duty_chg, v_kind_chg,
            'N', 'N',
            p_rest_yn,
            NULLIF(p_ren_ymd, ''),
            NULLIF(p_baby_ymd, ''),
            NULLIF(p_con_ymd, ''),
            p_dis_yn,
            NULLIF(p_dis_kind_cd, ''),
            NULLIF(p_dis_rtn_ymd, ''),
            NULLIF(p_dis_org_cd, ''),
            NULLIF(p_dis_pos_cd, ''),
            NULLIF(p_dis_duty_cd, ''),
            NULLIF(p_dis_pos_grd_cd, ''),
            'Y',
            NULLIF(p_send_nm, ''),
            NULLIF(p_send_nm, ''),
            p_mod_user_id, CURDATE()
        );

        -- 인사마스터에 최신 발령 정보 반영
        UPDATE PHM_EMP_C SET
            ORG_CD       = COALESCE(NULLIF(p_org_cd, ''),      ORG_CD),
            POS_CD       = COALESCE(NULLIF(p_pos_cd, ''),      POS_CD),
            DUTY_CD      = COALESCE(NULLIF(p_duty_cd, ''),     DUTY_CD),
            EMP_KIND_CD  = COALESCE(NULLIF(p_emp_kind_cd,''),  EMP_KIND_CD),
            YEARNUM      = COALESCE(NULLIF(p_yearnum, ''),     YEARNUM),
            CON_YMD      = NULLIF(p_con_ymd, ''),
            MOD_USER_ID  = p_mod_user_id,
            MOD_DATE     = CURDATE()
        WHERE EMP_ID = p_emp_id;

        SELECT v_new_id AS new_id;

    ELSE
        -- ── 기존 발령 수정 ─────────────────────────────────────
        UPDATE CAM_HISTORY_C SET
            EMP_ID          = p_emp_id,
            STA_YMD         = p_sta_ymd,
            TYPE_CD         = p_type_cd,
            CAU_CD          = NULLIF(p_cau_cd, ''),
            COMPANY_CD      = NULLIF(p_company_cd, ''),
            ORG_CD          = NULLIF(p_org_cd, ''),
            POS_CD          = NULLIF(p_pos_cd, ''),
            DUTY_CD         = NULLIF(p_duty_cd, ''),
            EMP_KIND_CD     = NULLIF(p_emp_kind_cd, ''),
            YEARNUM         = NULLIF(p_yearnum, ''),
            HIRE_CD         = NULLIF(p_hirec_cd, ''),
            ORG_CHN_YN      = v_org_chg,
            POS_CHN_YN      = v_pos_chg,
            DUTY_CHN_YN     = v_duty_chg,
            EMP_KIND_CHN_YN = v_kind_chg,
            REST_YN         = p_rest_yn,
            REN_YMD         = NULLIF(p_ren_ymd, ''),
            BABY_YMD        = NULLIF(p_baby_ymd, ''),
            CON_YMD         = NULLIF(p_con_ymd, ''),
            DIS_YN          = p_dis_yn,
            DIS_KIND_CD     = NULLIF(p_dis_kind_cd, ''),
            DIS_RTN_YMD     = NULLIF(p_dis_rtn_ymd, ''),
            DIS_ORG_CD      = NULLIF(p_dis_org_cd, ''),
            DIS_POS_CD      = NULLIF(p_dis_pos_cd, ''),
            DIS_DUTY_CD     = NULLIF(p_dis_duty_cd, ''),
            DIS_POS_GRD_CD  = NULLIF(p_dis_pos_grd_cd, ''),
            NOTE            = NULLIF(p_send_nm, ''),
            OUT_NOTE        = NULL,
            MOD_USER_ID     = p_mod_user_id,
            MOD_DATE        = CURDATE()
        WHERE CAM_HISTORY_ID = p_cam_history_id;

        SELECT p_cam_history_id AS new_id;
    END IF;
END //

DELIMITER ;
