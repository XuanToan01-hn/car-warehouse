package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Product;

@WebServlet(name = "AddProduct", urlPatterns = {"/add-product"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class AddProduct extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/images/table/product";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        boolean status = true;
        boolean flag = true;

        String name = trim(request.getParameter("name"));
        String code = trim(request.getParameter("code"));
        String priceStr = request.getParameter("price");
        String categoryStr = request.getParameter("category");
        String quantityStr = request.getParameter("quantity");
        String description = trim(request.getParameter("description"));

        long price = 0;
        int categoryId = 0;
        int quantity = 0;

        try {
            if (priceStr != null) price = Long.parseLong(priceStr);
            if (categoryStr != null) categoryId = Integer.parseInt(categoryStr);
            if (quantityStr != null) quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            flag = false;
        }

        if (name.isEmpty()) { request.setAttribute("eName", "Name is required"); flag = false; }
        if (price <= 0) { request.setAttribute("ePrice", "Price > 0"); flag = false; }
        if (quantity < 0) { request.setAttribute("eQuantity", "Quantity >= 0"); flag = false; }

        String savedImageName = "";

        if (flag) {
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String submittedFileName = imagePart.getSubmittedFileName();
                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                    String ext = "";
                    int dot = submittedFileName.lastIndexOf('.');
                    if (dot >= 0) ext = submittedFileName.substring(dot);
                    String newFileName = UUID.randomUUID().toString() + ext;
                    String baseDir = getServletContext().getRealPath("/");
                    if (baseDir != null) {
                        Path uploadPath = Paths.get(baseDir, UPLOAD_DIR);
                        try {
                            Files.createDirectories(uploadPath);
                            Path filePath = uploadPath.resolve(newFileName);
                            try (InputStream is = imagePart.getInputStream()) {
                                Files.copy(is, filePath, StandardCopyOption.REPLACE_EXISTING);
                            }
                            savedImageName = newFileName;
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        if (!flag) {
            status = false;
            request.setAttribute("uName", name);
            request.setAttribute("uCode", code);
            request.setAttribute("uPrice", price);
            request.setAttribute("uCategory", categoryId);
            request.setAttribute("uDes", description);
            request.setAttribute("uQuantity", quantityStr);
        } else {
            Product product = new Product();
            product.setId(0);
            product.setCode(code);
            product.setName(name);
            product.setPrice((double) price);
            product.setDescription(description);
            product.setImage(savedImageName);
            product.setCategory(categoryDAO.getByID(categoryId));
            product.setMinStock(quantity);
            productDAO.insert(product);
        }

        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("showStatus", status);
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}