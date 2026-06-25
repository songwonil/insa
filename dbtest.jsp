<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 응답 헤더 설정 (캐시 방지 및 JSON 명시)
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 데이터베이스 연결 정보
    String dbUrl = "jdbc:mysql://140.245.76.64:3306/dlive_insa?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
    String dbUser = "insa";       // 본인의 MySQL 계정
    String dbPassword = "insa"; // 본인의 MySQL 비밀번호

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // JSON 문자열 생성을 위한 StringBuilder
    StringBuilder jsonResult = new StringBuilder();

    try {
        // 1. JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 2. 데이터베이스 연결
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // 3. SQL 쿼리 실행
        String sql = "SELECT id, name, email FROM users";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        // 4. JSON 배열 시작
        jsonResult.append("[");

        boolean isFirst = true;
        while (rs.next()) {
            if (!isFirst) {
                jsonResult.append(","); // 항목 간 쉼표 추가
            }
            isFirst = false;

            int id = rs.getInt("id");
            String name = rs.getString("name");
            String email = rs.getString("email");

            // 특수문자 에스케이프 처리를 수동으로 할 때는 주의가 필요합니다.
            // 여기서는 단순 출력을 위해 기본 문자열 포맷팅을 사용합니다.
            jsonResult.append("{")
                      .append("\"id\":").append(id).append(",")
                      .append("\"name\":\"").append(name).append("\",")
                      .append("\"email\":\"").append(email).append("\"")
                      .append("}");
        }
        
        // JSON 배열 종료
        jsonResult.append("]");

    } catch (Exception e) {
        // 에러 발생 시 에러 메시지를 JSON 형태로 출력
        jsonResult.setLength(0); // 기존 내용 초기화
        jsonResult.append("{\"error\":\"")
                  .append(e.getMessage().replace("\"", "\\\""))
                  .append("\"}");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
        // 5. 자원 해제 (반드시 실행)
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }

    // 최종 JSON 데이터 출력
    out.print(jsonResult.toString());
    out.flush();
%>