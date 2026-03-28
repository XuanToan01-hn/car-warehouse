/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.locationProduct;

import dal.LocationDAO;
import dal.LocationProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Location;
import model.Product;
import model.LocationProduct;
import model.ProductDetail;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 *
 * @author Asus
 */
@WebServlet(name="LocationProductServlet", urlPatterns={"/location-product"})
public class LocationProductServlet extends HttpServlet {
   
 private final LocationProductDAO lpDAO = new LocationProductDAO();
    private final LocationDAO locDAO = new LocationDAO();
    private final ProductDetailDAO pdDAO = new ProductDetailDAO();
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LocationProduct</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LocationProduct at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                List<LocationProduct> rawItems = lpDAO.getAll();
                
                // Group by Location + Product
                java.util.Map<String, java.util.Map<String, Object>> groupedMap = new java.util.LinkedHashMap<>();
                for (LocationProduct lp : rawItems) {
                    if (lp.getQuantity() <= 0 || lp.getProduct() == null || lp.getLocation() == null) continue;
                    
                    String key = lp.getLocation().getId() + "_" + lp.getProduct().getId();
                    if (!groupedMap.containsKey(key)) {
                        java.util.Map<String, Object> group = new java.util.HashMap<>();
                        group.put("location", lp.getLocation());
                        group.put("product", lp.getProduct());
                        group.put("totalQty", 0);
                        group.put("serials", new java.util.ArrayList<java.util.Map<String, Object>>());
                        groupedMap.put(key, group);
                    }
                    
                    java.util.Map<String, Object> group = groupedMap.get(key);
                    group.put("totalQty", (int) group.get("totalQty") + lp.getQuantity());
                    
                    java.util.List<java.util.Map<String, Object>> serials = (java.util.List<java.util.Map<String, Object>>) group.get("serials");
                    java.util.Map<String, Object> s = new java.util.HashMap<>();
                    s.put("serial", lp.getProductDetail().getSerialNumber());
                    s.put("qty", lp.getQuantity());
                    s.put("color", lp.getProductDetail().getColor());
                    s.put("pdId", lp.getProductDetail().getId());
                    s.put("locId", lp.getLocation().getId());
                    serials.add(s);
                }

                // Filter
                String search = request.getParameter("search");
                String keyword = (search != null) ? search.trim().toLowerCase() : "";
                java.util.List<java.util.Map<String, Object>> filteredList = new java.util.ArrayList<>(groupedMap.values());
                if (!keyword.isEmpty()) {
                    java.util.List<java.util.Map<String, Object>> tempList = new java.util.ArrayList<>();
                    for (java.util.Map<String, Object> g : filteredList) {
                        model.Product p = (model.Product) g.get("product");
                        model.Location l = (model.Location) g.get("location");
                        if (p.getName().toLowerCase().contains(keyword) 
                                || p.getCode().toLowerCase().contains(keyword)
                                || l.getLocationName().toLowerCase().contains(keyword)
                                || l.getLocationCode().toLowerCase().contains(keyword)) {
                            tempList.add(g);
                        }
                    }
                    filteredList = tempList;
                }

                // Pagination
                int pageSize = 5;
                int currentPage = 1;
                try {
                    String p = request.getParameter("page");
                    if (p != null && !p.trim().isEmpty()) currentPage = Integer.parseInt(p.trim());
                } catch (Exception e) {}
                
                int totalItems = filteredList.size();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
                if (currentPage < 1) currentPage = 1;
                
                int start = (currentPage - 1) * pageSize;
                int end = java.lang.Math.min(start + pageSize, totalItems);
                
                java.util.List<java.util.Map<String, Object>> pagedItems = new java.util.ArrayList<>();
                if (start < totalItems) pagedItems = filteredList.subList(start, end);

                request.setAttribute("items", pagedItems);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("search", keyword);
                
                request.getRequestDispatcher("/view/location-product/location-product-list.jsp").forward(request, response);
                break;
            case "add":
                request.setAttribute("locations", locDAO.getAll());
                request.setAttribute("details", pdDAO.getAll()); 
                request.getRequestDispatcher("/view/location-product/location-product-form.jsp").forward(request, response);
                break;
            case "delete":
                try {
                    int locId = Integer.parseInt(request.getParameter("locId"));
                    int pdId = Integer.parseInt(request.getParameter("pdId"));
                    lpDAO.delete(locId, pdId);
                } catch (Exception e) {}
                response.sendRedirect("location-product");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int locId = Integer.parseInt(request.getParameter("locationId"));
        int pdId = Integer.parseInt(request.getParameter("productDetailId"));
        int qty = Integer.parseInt(request.getParameter("quantity"));

        LocationProduct lp = new LocationProduct();
        Location l = new Location(); l.setId(locId);
        ProductDetail pd = pdDAO.getById(pdId); 
        
        lp.setLocation(l);
        lp.setProductDetail(pd);
        lp.setQuantity(qty);

        lpDAO.save(lp);
        response.sendRedirect("location-product");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
