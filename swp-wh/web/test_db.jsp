<%@ page import="java.sql.*" %>
<%@ page import="context.DBContext" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<h2>Debug Location_Product</h2>
<table border="1">
    <tr>
        <th>LocationID</th>
        <th>ProductDetailID</th>
        <th>Quantity</th>
        <th>Location Name</th>
    </tr>
    <%
        try {
            DBContext db = new DBContext();
            Connection conn = (Connection) db.getClass().getDeclaredField("connection").get(db);
            if (conn == null) {
                out.println("Connection is null!");
            } else {
                String sql = "SELECT lp.*, l.LocationName FROM Location_Product lp JOIN Location l ON lp.LocationID = l.LocationID";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("LocationID") %></td>
        <td><%= rs.getInt("ProductDetailID") %></td>
        <td><%= rs.getInt("Quantity") %></td>
        <td><%= rs.getString("LocationName") %></td>
    </tr>
    <%
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new java.io.PrintWriter(out));
        }
    %>
</table>
</body>
</html>
