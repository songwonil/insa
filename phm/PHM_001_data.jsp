<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../common/db_include.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    String action = nvl(request.getParameter("action"));
    StringBuilder json = new StringBuilder();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection(application);

        // ============================================================
        // 직원 검색
        // ============================================================
        if ("search".equals(action)) {
            String nm     = nvl(request.getParameter("nm"));
            String status = nvl(request.getParameter("status"));

            StringBuilder sql = new StringBuilder(
                "SELECT emp_id, emp_nm, dept_nm, position_nm, work_status " +
                "FROM emp_master WHERE 1=1"
            );
            if (!nm.isEmpty())     sql.append(" AND emp_nm LIKE ?");
            if (!status.isEmpty()) sql.append(" AND work_status = ?");
            sql.append(" ORDER BY emp_nm LIMIT 100");

            pstmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (!nm.isEmpty())     pstmt.setString(idx++, "%" + nm + "%");
            if (!status.isEmpty()) pstmt.setString(idx++, status);
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"empId\":\"").append(escJson(rs.getString("emp_id"))).append("\",")
                    .append("\"empNm\":\"").append(escJson(rs.getString("emp_nm"))).append("\",")
                    .append("\"deptNm\":\"").append(escJson(rs.getString("dept_nm"))).append("\",")
                    .append("\"positionNm\":\"").append(escJson(rs.getString("position_nm"))).append("\",")
                    .append("\"workStatus\":\"").append(escJson(rs.getString("work_status"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 단건 사원 조회
        // ============================================================
        } else if ("getEmp".equals(action)) {
            String empId = nvl(request.getParameter("empId"));

            pstmt = conn.prepareStatement(
                "SELECT * FROM emp_master WHERE emp_id = ?"
            );
            pstmt.setString(1, empId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                json.append("{")
                    .append("\"empId\":\"").append(escJson(rs.getString("emp_id"))).append("\",")
                    .append("\"empNm\":\"").append(escJson(rs.getString("emp_nm"))).append("\",")
                    .append("\"empNmHanja\":\"").append(escJson(rs.getString("emp_nm_hanja"))).append("\",")
                    .append("\"empNmEng\":\"").append(escJson(rs.getString("emp_nm_eng"))).append("\",")
                    .append("\"empGender\":\"").append(escJson(rs.getString("emp_gender"))).append("\",")
                    .append("\"empBirthDt\":\"").append(escJson(rs.getString("emp_birth_dt"))).append("\",")
                    .append("\"empSsn\":\"").append(escJson(rs.getString("emp_ssn"))).append("\",")
                    .append("\"empNationality\":\"").append(escJson(rs.getString("emp_nationality"))).append("\",")
                    .append("\"workStatus\":\"").append(escJson(rs.getString("work_status"))).append("\",")
                    .append("\"corpCd\":\"").append(escJson(rs.getString("corp_cd"))).append("\",")
                    .append("\"corpNm\":\"").append(escJson(rs.getString("corp_nm"))).append("\",")
                    .append("\"grpJoinDt\":\"").append(escJson(rs.getString("grp_join_dt"))).append("\",")
                    .append("\"corpJoinDt\":\"").append(escJson(rs.getString("corp_join_dt"))).append("\",")
                    .append("\"deptCd\":\"").append(escJson(rs.getString("dept_cd"))).append("\",")
                    .append("\"deptNm\":\"").append(escJson(rs.getString("dept_nm"))).append("\",")
                    .append("\"positionNm\":\"").append(escJson(rs.getString("position_nm"))).append("\",")
                    .append("\"titleNm\":\"").append(escJson(rs.getString("title_nm"))).append("\",")
                    .append("\"workSo\":\"").append(escJson(rs.getString("work_so"))).append("\",")
                    .append("\"mobileNo\":\"").append(escJson(rs.getString("mobile_no"))).append("\",")
                    .append("\"officeTel\":\"").append(escJson(rs.getString("office_tel"))).append("\",")
                    .append("\"homeTel\":\"").append(escJson(rs.getString("home_tel"))).append("\",")
                    .append("\"eduLevel\":\"").append(escJson(rs.getString("edu_level"))).append("\",")
                    .append("\"jobType\":\"").append(escJson(rs.getString("job_type"))).append("\",")
                    .append("\"dutyNm\":\"").append(escJson(rs.getString("duty_nm"))).append("\",")
                    .append("\"corpEmail\":\"").append(escJson(rs.getString("corp_email"))).append("\",")
                    .append("\"personalEmail\":\"").append(escJson(rs.getString("personal_email"))).append("\",")
                    .append("\"veteranYn\":\"").append(escJson(rs.getString("veteran_yn"))).append("\",")
                    .append("\"disabilityYn\":\"").append(escJson(rs.getString("disability_yn"))).append("\",")
                    .append("\"clubNm\":\"").append(escJson(rs.getString("club_nm"))).append("\",")
                    .append("\"maritalStatus\":\"").append(escJson(rs.getString("marital_status"))).append("\",")
                    .append("\"hometown\":\"").append(escJson(rs.getString("hometown"))).append("\",")
                    .append("\"homeAddr\":\"").append(escJson(rs.getString("home_addr"))).append("\",")
                    .append("\"photoPath\":\"").append(escJson(rs.getString("photo_path"))).append("\"")
                    .append("}");
            } else {
                json.append("{\"error\":\"사원을 찾을 수 없습니다.\"}");
                response.setStatus(404);
            }

        // ============================================================
        // 사원 정보 저장 (POST)
        // ============================================================
        } else if ("saveEmp".equals(action)) {
            String empId        = nvl(request.getParameter("empId"));
            String empNm        = nvl(request.getParameter("empNm"));
            String empNmHanja   = nvl(request.getParameter("empNmHanja"));
            String empSsn       = nvl(request.getParameter("empSsn"));
            String workStatus   = nvl(request.getParameter("workStatus"));
            String grpJoinDt    = nvl(request.getParameter("grpJoinDt"));
            String corpJoinDt   = nvl(request.getParameter("corpJoinDt"));
            String workSo       = nvl(request.getParameter("workSo"));
            String positionNm   = nvl(request.getParameter("positionNm"));
            String titleNm      = nvl(request.getParameter("titleNm"));
            String mobileNo     = nvl(request.getParameter("mobileNo"));
            String officeTel    = nvl(request.getParameter("officeTel"));
            String homeTel      = nvl(request.getParameter("homeTel"));
            String empNmEng     = nvl(request.getParameter("empNmEng"));
            String empGender    = nvl(request.getParameter("empGender"));
            String empBirthDt   = nvl(request.getParameter("empBirthDt"));
            String empNationality = nvl(request.getParameter("empNationality"));
            String eduLevel     = nvl(request.getParameter("eduLevel"));
            String jobType      = nvl(request.getParameter("jobType"));
            String dutyNm       = nvl(request.getParameter("dutyNm"));
            String corpEmail    = nvl(request.getParameter("corpEmail"));
            String personalEmail = nvl(request.getParameter("personalEmail"));
            String veteranYn    = nvl(request.getParameter("veteranYn"));
            String disabilityYn = nvl(request.getParameter("disabilityYn"));
            String clubNm       = nvl(request.getParameter("clubNm"));
            String maritalStatus = nvl(request.getParameter("maritalStatus"));
            String hometown     = nvl(request.getParameter("hometown"));
            String homeAddr     = nvl(request.getParameter("homeAddr"));

            String upsertSql =
                "INSERT INTO emp_master (emp_id, emp_nm, emp_nm_hanja, emp_ssn, work_status, " +
                "  grp_join_dt, corp_join_dt, work_so, position_nm, title_nm, " +
                "  mobile_no, office_tel, home_tel, emp_nm_eng, emp_gender, " +
                "  emp_birth_dt, emp_nationality, edu_level, job_type, duty_nm, " +
                "  corp_email, personal_email, veteran_yn, disability_yn, club_nm, " +
                "  marital_status, hometown, home_addr) " +
                "VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) " +
                "ON DUPLICATE KEY UPDATE " +
                "  emp_nm=VALUES(emp_nm), emp_nm_hanja=VALUES(emp_nm_hanja), emp_ssn=VALUES(emp_ssn), " +
                "  work_status=VALUES(work_status), grp_join_dt=VALUES(grp_join_dt), corp_join_dt=VALUES(corp_join_dt), " +
                "  work_so=VALUES(work_so), position_nm=VALUES(position_nm), title_nm=VALUES(title_nm), " +
                "  mobile_no=VALUES(mobile_no), office_tel=VALUES(office_tel), home_tel=VALUES(home_tel), " +
                "  emp_nm_eng=VALUES(emp_nm_eng), emp_gender=VALUES(emp_gender), emp_birth_dt=VALUES(emp_birth_dt), " +
                "  emp_nationality=VALUES(emp_nationality), edu_level=VALUES(edu_level), job_type=VALUES(job_type), " +
                "  duty_nm=VALUES(duty_nm), corp_email=VALUES(corp_email), personal_email=VALUES(personal_email), " +
                "  veteran_yn=VALUES(veteran_yn), disability_yn=VALUES(disability_yn), club_nm=VALUES(club_nm), " +
                "  marital_status=VALUES(marital_status), hometown=VALUES(hometown), home_addr=VALUES(home_addr)";

            pstmt = conn.prepareStatement(upsertSql);
            pstmt.setString(1,  empId);
            pstmt.setString(2,  empNm);
            pstmt.setString(3,  empNmHanja.isEmpty() ? null : empNmHanja);
            pstmt.setString(4,  empSsn.isEmpty() ? null : empSsn);
            pstmt.setString(5,  workStatus.isEmpty() ? "1" : workStatus);
            pstmt.setString(6,  grpJoinDt.isEmpty() ? null : grpJoinDt);
            pstmt.setString(7,  corpJoinDt.isEmpty() ? null : corpJoinDt);
            pstmt.setString(8,  workSo.isEmpty() ? null : workSo);
            pstmt.setString(9,  positionNm.isEmpty() ? null : positionNm);
            pstmt.setString(10, titleNm.isEmpty() ? null : titleNm);
            pstmt.setString(11, mobileNo.isEmpty() ? null : mobileNo);
            pstmt.setString(12, officeTel.isEmpty() ? null : officeTel);
            pstmt.setString(13, homeTel.isEmpty() ? null : homeTel);
            pstmt.setString(14, empNmEng.isEmpty() ? null : empNmEng);
            pstmt.setString(15, empGender.isEmpty() ? null : empGender);
            pstmt.setString(16, empBirthDt.isEmpty() ? null : empBirthDt);
            pstmt.setString(17, empNationality.isEmpty() ? "내국인" : empNationality);
            pstmt.setString(18, eduLevel.isEmpty() ? null : eduLevel);
            pstmt.setString(19, jobType.isEmpty() ? null : jobType);
            pstmt.setString(20, dutyNm.isEmpty() ? null : dutyNm);
            pstmt.setString(21, corpEmail.isEmpty() ? null : corpEmail);
            pstmt.setString(22, personalEmail.isEmpty() ? null : personalEmail);
            pstmt.setString(23, veteranYn.isEmpty() ? "N" : veteranYn);
            pstmt.setString(24, disabilityYn.isEmpty() ? "N" : disabilityYn);
            pstmt.setString(25, clubNm.isEmpty() ? null : clubNm);
            pstmt.setString(26, maritalStatus.isEmpty() ? null : maritalStatus);
            pstmt.setString(27, hometown.isEmpty() ? null : hometown);
            pstmt.setString(28, homeAddr.isEmpty() ? null : homeAddr);
            pstmt.executeUpdate();

            json.append("{\"result\":\"ok\",\"message\":\"저장되었습니다.\"}");

        // ============================================================
        // 발령 이력
        // ============================================================
        } else if ("getAppoint".equals(action)) {
            String empId = nvl(request.getParameter("empId"));
            pstmt = conn.prepareStatement(
                "SELECT * FROM emp_appoint WHERE emp_id = ? ORDER BY appoint_dt DESC"
            );
            pstmt.setString(1, empId);
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"appointId\":").append(rs.getInt("appoint_id")).append(",")
                    .append("\"appointDt\":\"").append(escJson(rs.getString("appoint_dt"))).append("\",")
                    .append("\"appointType\":\"").append(escJson(rs.getString("appoint_type"))).append("\",")
                    .append("\"fromDeptNm\":\"").append(escJson(rs.getString("from_dept_nm"))).append("\",")
                    .append("\"toDeptNm\":\"").append(escJson(rs.getString("to_dept_nm"))).append("\",")
                    .append("\"fromPosition\":\"").append(escJson(rs.getString("from_position"))).append("\",")
                    .append("\"toPosition\":\"").append(escJson(rs.getString("to_position"))).append("\",")
                    .append("\"remark\":\"").append(escJson(rs.getString("remark"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 가족 사항
        // ============================================================
        } else if ("getFamily".equals(action)) {
            String empId = nvl(request.getParameter("empId"));
            pstmt = conn.prepareStatement(
                "SELECT * FROM emp_family WHERE emp_id = ? ORDER BY family_id"
            );
            pstmt.setString(1, empId);
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"familyId\":").append(rs.getInt("family_id")).append(",")
                    .append("\"relation\":\"").append(escJson(rs.getString("relation"))).append("\",")
                    .append("\"familyNm\":\"").append(escJson(rs.getString("family_nm"))).append("\",")
                    .append("\"familyGender\":\"").append(escJson(rs.getString("family_gender"))).append("\",")
                    .append("\"familyBirthDt\":\"").append(escJson(rs.getString("family_birth_dt"))).append("\",")
                    .append("\"liveTogether\":\"").append(escJson(rs.getString("live_together"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 학력 사항
        // ============================================================
        } else if ("getEdu".equals(action)) {
            String empId = nvl(request.getParameter("empId"));
            pstmt = conn.prepareStatement(
                "SELECT * FROM emp_education WHERE emp_id = ? ORDER BY graduate_dt DESC"
            );
            pstmt.setString(1, empId);
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"eduId\":").append(rs.getInt("edu_id")).append(",")
                    .append("\"schoolNm\":\"").append(escJson(rs.getString("school_nm"))).append("\",")
                    .append("\"major\":\"").append(escJson(rs.getString("major"))).append("\",")
                    .append("\"eduLevel\":\"").append(escJson(rs.getString("edu_level"))).append("\",")
                    .append("\"enterDt\":\"").append(escJson(rs.getString("enter_dt"))).append("\",")
                    .append("\"graduateDt\":\"").append(escJson(rs.getString("graduate_dt"))).append("\",")
                    .append("\"graduateType\":\"").append(escJson(rs.getString("graduate_type"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 경력 사항
        // ============================================================
        } else if ("getCareer".equals(action)) {
            String empId = nvl(request.getParameter("empId"));
            pstmt = conn.prepareStatement(
                "SELECT * FROM emp_career WHERE emp_id = ? ORDER BY join_dt DESC"
            );
            pstmt.setString(1, empId);
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"careerId\":").append(rs.getInt("career_id")).append(",")
                    .append("\"companyNm\":\"").append(escJson(rs.getString("company_nm"))).append("\",")
                    .append("\"deptNm\":\"").append(escJson(rs.getString("dept_nm"))).append("\",")
                    .append("\"positionNm\":\"").append(escJson(rs.getString("position_nm"))).append("\",")
                    .append("\"joinDt\":\"").append(escJson(rs.getString("join_dt"))).append("\",")
                    .append("\"resignDt\":\"").append(escJson(rs.getString("resign_dt"))).append("\",")
                    .append("\"dutyNm\":\"").append(escJson(rs.getString("duty_nm"))).append("\"")
                    .append("}");
            }
            json.append("]");

        } else {
            json.append("{\"error\":\"Unknown action\"}");
            response.setStatus(400);
        }

    } catch (Exception e) {
        json.setLength(0);
        json.append("{\"result\":\"error\",\"message\":\"").append(escJson(e.getMessage())).append("\"}");
        response.setStatus(500);
    } finally {
        if (rs    != null) try { rs.close();    } catch (Exception ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
        if (conn  != null) try { conn.close();  } catch (Exception ignore) {}
    }

    out.print(json.toString());
    out.flush();
%>
