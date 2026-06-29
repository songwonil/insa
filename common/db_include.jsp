<%@ page import="java.sql.*" %>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>
<%!
    // DB 연결 공통 메서드
    public Connection getConnection(javax.servlet.ServletContext ctx) throws Exception {
        String envPath = ctx.getRealPath("/WEB-INF");
        Dotenv dotenv = Dotenv.configure().directory(envPath).load();
        String dbUrl  = dotenv.get("DB_URL");
        String dbUser = dotenv.get("DB_USER");
        String dbPass = dotenv.get("DB_PASSWORD");
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }

    // null-safe getString
    public String nvl(String s) { return (s == null) ? "" : s; }

    // JSON 문자열 이스케이프
    public String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"")
                .replace("\r","\\r").replace("\n","\\n").replace("\t","\\t");
    }
%>
