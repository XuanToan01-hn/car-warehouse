/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;

/**
 *
 * @author Nhat
 */
public class CategoryDAO extends DBContext {

    public List<Category> getAll() {
        String sql = "SELECT * FROM Category;";
        List<Category> list = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(rs.getInt("CategoryID"), rs.getString("Name"), rs.getString("Description"));
                list.add(c);
            }
        } catch (SQLException ex) {

            System.out.println(ex);
        }
        return list;
    }

    public Category getByID(int iD) {
        String sql = "SELECT * FROM Category WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, iD); // Gán giá trị iD vào dấu ?
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                        rs.getInt("CategoryID"),
                        rs.getString("Name"),
                        rs.getString("Description")
                );
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }


    public Integer getCategoryIdByProductId(int productId) {
        String sql = "SELECT CategoryID FROM Product WHERE ProductID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("CategoryID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; // Trả về null nếu không tìm thấy hoặc lỗi
    }

    
    public List<Category> searchAndPaginate(String keyword, int offset, int limit) {
        String sql = "SELECT * FROM Category WHERE Name LIKE ? ORDER BY CategoryID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<Category> list = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(rs.getInt("CategoryID"), rs.getString("Name"), rs.getString("Description"));
                list.add(c);
            }
        } catch (SQLException ex) {
            System.out.println("getAll with search + paging: " + ex);
        }
        return list;
    }

    public int count(String keyword) {
        String sql = "SELECT COUNT(*) FROM Category WHERE Name LIKE ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("count with search: " + ex);
        }
        return 0;
    }

    public void delete(int id) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.out.println("delete: " + ex);
        }
    }

    public void insert(Category category) {
        String sql = "INSERT INTO [dbo].[Category]\n" +
"           ([Name]\n" +
"           ,[Description])\n" +
"     VALUES\n" +
"           (?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.out.println("insert: " + ex);
        }
    }

    public void update(Category category) {
        String sql = "UPDATE Category SET [Name] = ?, [Description] = ? WHERE CategoryID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.out.println("update: " + ex);
        }
    }

    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();
        List<Category> list = dao.searchAndPaginate("", 0, 5);
        for (Category c : list) {
            System.out.println(c.getId() + " - " + c.getName());
        }
    }

}
