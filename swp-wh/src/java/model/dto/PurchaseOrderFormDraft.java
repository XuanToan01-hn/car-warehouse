package model.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Draft tạo PO trong session — tránh mất dữ liệu khi thêm/xóa dòng (server-side).
 */
public class PurchaseOrderFormDraft implements Serializable {

    private static final long serialVersionUID = 1L;

    private int supplierId;
    private String orderCode;
    private final List<PurchaseLineDraft> lines = new ArrayList<>();

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public List<PurchaseLineDraft> getLines() {
        return lines;
    }

    public void resetLinesOneEmpty() {
        lines.clear();
        lines.add(new PurchaseLineDraft());
    }

    public void addLine(PurchaseLineDraft line) {
        lines.add(line);
    }

    public void removeLine(int index) {
        if (index < 0 || index >= lines.size()) {
            return;
        }
        if (lines.size() <= 1) {
            lines.get(0).clear();
            return;
        }
        lines.remove(index);
    }
}
