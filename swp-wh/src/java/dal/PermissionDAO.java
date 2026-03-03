/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Permission;
import model.PermissionGroup;
import model.Role;
import model.RolePermission;

/**
 *
 * @author Asus
 */
public class PermissionDAO extends DBContext {

    public boolean hasPermission(int roleId, String url) {
        String sql = "SELECT COUNT(*) "
                + "FROM RolePermission RP "
                + "JOIN Permission P ON RP.PermissionID = P.PermissionID "
                + "WHERE RP.RoleID = ? AND P.URL = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setString(2, url);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in hasPermission: " + e.getMessage());
        }
        return false;
    }

    public List<Role> getListRole() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Role]";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Permission> getListPermission() {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Permission]";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Permission(rs.getInt("PermissionID"), rs.getString("Name"), rs.getString("URL"),
                        rs.getString("Description"), getPermissionGroupById(rs.getInt("GroupID"))));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Permission> getListPermissionByGroupId(int id) {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Permission]"
                + "WHERE [GroupID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Permission(rs.getInt("PermissionID"), rs.getString("Name"), rs.getString("URL"),
                        rs.getString("Description"), getPermissionGroupById(rs.getInt("GroupID"))));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<PermissionGroup> getListPermissionGroup() {
        List<PermissionGroup> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[PermissionGroup]";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PermissionGroup p = new PermissionGroup(rs.getInt("GroupID"), rs.getString("GroupName"),
                        rs.getString("Description"), getListPermissionByGroupId(rs.getInt("GroupID")));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public PermissionGroup getPermissionGroupById(int id) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[PermissionGroup]"
                + "  WHERE GroupID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PermissionGroup p = new PermissionGroup(rs.getInt("GroupID"),
                        rs.getString("GroupName"), rs.getString("Description"));
                return p;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<RolePermission> getListRolePermissionByRoleId(int roleId) {
        List<RolePermission> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[RolePermission]\n"
                + "  WHERE [RoleID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RolePermission p = new RolePermission(getPermissionById(rs.getInt("PermissionID")),
                        getRoleById(rs.getInt("RoleID")));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Permission getPermissionById(int permissionId) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Permission]\n"
                + "  WHERE [PermissionID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, permissionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission p = new Permission(rs.getInt("PermissionID"), rs.getString("Name"), rs.getString("URL"),
                        rs.getString("Description"), getPermissionGroupById(rs.getInt("GroupID")));
                return p;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public Role getRoleById(int roleId) {
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Role]\n"
                + "  WHERE [RoleID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role r = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                return r;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public static void main(String[] args) {
        PermissionDAO p = new PermissionDAO();
        for (Permission arg : p.getListPermission()) {
            System.out.println(arg.getPermissionGroup().getGroupName());
        }
    }

    public void addPermission(int roleId, int permissionId) {
        String sql = "INSERT INTO [dbo].[RolePermission]\n"
                + "           ([RoleID]\n"
                + "           ,[PermissionID])\n"
                + "     VALUES\n"
                + "           (?\n"
                + "           ,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void deletePermission(int roleId) {
        String sql = "DELETE FROM [dbo].[RolePermission]\n"
                + "      WHERE [RoleID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
