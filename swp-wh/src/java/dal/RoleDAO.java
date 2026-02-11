/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author Asus
 */
public class RoleDAO extends DBContext{
    public List<Role> getAll() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM Role";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("RoleID"));
                r.setRoleName(rs.getString("RoleName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Role getById(int id) {
        String sql = "SELECT * FROM Role WHERE RoleID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("RoleID"));
                r.setRoleName(rs.getString("RoleName"));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(Role r) {
        String sql = "INSERT INTO Role(RoleName) VALUES(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getRoleName());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Role r) {
        String sql = "UPDATE Role SET RoleName=? WHERE RoleID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getRoleName());
            ps.setInt(2, r.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Role WHERE RoleID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
