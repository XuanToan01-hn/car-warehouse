package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;

/**
 * DAO đơn giản cho bảng Warehouse,
 * chỉ dùng để phục vụ module Location (lấy danh sách kho).
 */
public class WarehouseDAO extends DBContext {

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM Warehouse";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getInt("WarehouseID"));
                w.setWarehouseCode(rs.getString("WarehouseCode"));
                w.setWarehouseName(rs.getString("WarehouseName"));
                w.setAddress(rs.getString("Address"));
                w.setDescription(rs.getString("Description"));
                w.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

