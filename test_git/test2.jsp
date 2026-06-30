<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>

<%
    // .env 파일 로드
    String envPath = application.getRealPath("/WEB-INF");
    
    Dotenv dotenv = Dotenv.configure()
                          .directory(envPath)
                          .load();
    
    String dbUrl = dotenv.get("DB_URL");
    String dbUser = dotenv.get("DB_USER");
    String dbPassword = dotenv.get("DB_PASSWORD");

    // 이후 Connection 연결 로직은 동일...
%>

<%
    // 1. 서버가 요청을 받을 때와 응답을 보낼 때의 인코딩을 UTF-8로 강제 지정 (★핵심)
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 1. CORS 허용 설정 (React 서버의 주소에 맞게 설정, 테스트용으로 전체 허용)
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    // OPTIONS preflight 요청 처리
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    String method = request.getMethod();
    String jsonResponse = "";

    if ("GET".equalsIgnoreCase(method)) {
        // GET 요청 처리: 단순한 테스트용 JSON 반환
        // jsonResponse = "{\"status\": \"success\", \"message\": \"안녕! pure JSP 파일(data.jsp)에서 보낸 GET! 데이터야123.111ㄹㄹㄹㄹ\"}";


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

                String cleanName = (name != null) ? name.replace("\n", "").replace("\r", "") : "";
                String cleanEmail = (email != null) ? email.replace("\n", "").replace("\r", "") : "";

                jsonResult.append("{")
                        .append("\"id\":\"").append(id).append("\",")
                        .append("\"name\":\"").append(cleanName).append("\",")
                        .append("\"email\":\"").append(cleanEmail).append("\",")
                        .append("\"abc\":\"125\"")
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
            //jsonResult.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            // 5. 자원 해제 (반드시 실행)
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        jsonResponse = jsonResult.toString();


        
    } else if ("POST".equalsIgnoreCase(method)) {
        // POST 요청 처리: React가 보낸 JSON 바디 읽기
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 1. React에서 보낸 JSON 데이터 읽기
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String requestBody = sb.toString();

            // 2. JSON에서 userName 값 추출 (라이브러리 없이 간단하게 처리)
            // 실제 프로덕션에서는 Gson, Jackson 등의 라이브러리 사용을 권장합니다.
            String userName = null;
            String userEmail = null;

            if (requestBody != null && requestBody.contains("\"userName\"")) {
                String[] parts = requestBody.split("\"userName\":\"");
                if (parts.length > 1) {
                    userName = parts[1].split("\"")[0];
                }
            }
            if (requestBody != null && requestBody.contains("\"userEmail\"")) {
                String[] parts = requestBody.split("\"userEmail\":\"");
                if (parts.length > 1) {
                    userEmail = parts[1].split("\"")[0];
                }
            }

            if (userName == null || userName.trim().isEmpty() || userEmail == null || userEmail.trim().isEmpty()) {
                throw new Exception("이름과 이메일 모두 유효하지 않습니다.");
            }

            // 3. 데이터베이스에 사용자 추가
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userName);
            pstmt.setString(2, userEmail);
            int result = pstmt.executeUpdate();

            if (result > 0) {
                jsonResponse = "{\"status\": \"success\", \"message\": \"사용자(" + userName + ", " + userEmail + ")가 성공적으로 추가되었습니다.\"}";
            } else {
                throw new Exception("사용자 추가에 실패했습니다.");
            }
        } catch (Exception e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }

    // 2. 최종 JSON 응답 출력
    out.print(jsonResponse);
    out.flush();
%>