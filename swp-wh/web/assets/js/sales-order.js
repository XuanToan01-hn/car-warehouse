//Delete quotation start
function openDeleteForm(id) {
    document.getElementById('quotationIdInput').value = id;
    document.getElementById('deleteQuotationCode').innerText = id;
    document.getElementById('delete').style.display = 'block';
}

function closeDeleteForm() {
    document.getElementById('delete').style.display = 'none';
}
//Delete quotation end

//form choose customer start
function openChooseCustomerModal() {
    document.getElementById("chooseCustomerModal").style.display = "block";
}

function closeChooseCustomerModal() {
    document.getElementById("chooseCustomerModal").style.display = "none";
}

function selectCustomer(id, name, email, phone, address) {
    document.getElementById("selectedCustomerId").value = id;
    document.getElementById("selectedCustomerName").innerHTML = '<strong>' + name + '</strong>';
    document.getElementById("selectedCustomerEmail").innerText = email;
    document.getElementById("selectedCustomerPhone").innerText = phone;
    document.getElementById("selectedCustomerAddress").innerText = address;
//    document.getElementById("selectedCustomerIDHref").href = 'ListProductToTheOrder?customerId=' + id;
    closeChooseCustomerModal();
}

function handleAddProductClick() {
    const customerId = document.getElementById('selectedCustomerId').value;
    if (customerId) {
        document.getElementById("selectedCustomerIDHref").href = 'ListProductToTheOrder?customerId=' + customerId;
    } else {
        alert('Please choose customer before add new product!');
    }
}
//form choose customer end

//Alert start
window.addEventListener("DOMContentLoaded", function () {
    // Lấy phần tử toast đang tồn tại (chỉ có 1 toast sẽ được render)
    const errorToast = document.getElementById("errorToast");
    const successToast = document.getElementById("successToast");

    const toast = errorToast || successToast;

    if (toast) {
        // Sau 3 giây thì ẩn thông báo
        setTimeout(() => {
            toast.style.transition = "opacity 0.5s ease, visibility 0.5s ease";
            toast.style.opacity = "0";
            toast.style.visibility = "hidden";
        }, 3000);
    }
});
//Alert end


//submit quotation
function handleSubmitClick(data, event) {
    const customerId = document.getElementById('selectedCustomerId').value;
    const expirationDate = document.getElementById('expirationDate').value;
    if (!expirationDate && event !== 'confirm') {
        alert('Please select a expiration date before ' + event + '!');
        return;
    }
    const expirationDateValue = expirationDate;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const selectedDate = new Date(expirationDateValue);
    if (selectedDate < today) {
        alert('Error: Expiration date cannot be in the past. Please choose today or a future date.');
        expirationDateInput.focus();
        return;
    }
    if (!customerId) {
        alert('Please choose customer before' + event + '!');
        return;
    }
    if (!validateForm()) {
        return;
    }
    const statusValue = data.getAttribute('data-value');
    document.getElementById('buttonSubmit').value = statusValue;
    document.getElementById('orderForm').submit();
}
//submit sales order detail
function handleSubmitSalesOrderDetail() {
    const productId = document.getElementById('productIdValue').value;
    if (!productId) {
        alert('Please choose product before submit!');
        return;
    }
    if (!validateForm()) {
        return;
    }
    document.getElementById('addProductForm').submit();

}

//Delete Sales Order detail
function openDelteProductForm(productId, salesOrderId, productName) {
    document.getElementById('deleteSOD').style.display = 'block';
    document.getElementById('deleteProductName').innerText = productName;
    document.getElementById('productId').value = productId;
    document.getElementById('salesOrderId').value = salesOrderId;
}
function closeDeleteProductForm() {
    document.getElementById('deleteSOD').style.display = 'none';
}

//Add Product
function btnAddProduct() {
    const tableBody = document.getElementById('productTableBody');
    const productRowTemplate = document.getElementById('productRowTemplate');
    const newRowFragment = productRowTemplate.content.cloneNode(true);
    tableBody.appendChild(newRowFragment);
    updateRowNumbers();
    updateProductDropdowns();
}
function updateRowNumbers() {
    const tableBody = document.getElementById('productTableBody');
    const allRows = tableBody.querySelectorAll('tr');
    let i = 1;
    for (const row of allRows) {
        const numberCell = row.querySelector('.row-number');
        if (numberCell) {
            numberCell.textContent = i;
        }
        i++;
    }
}
function handleDeleteClick(deleteButton) {
    const row = deleteButton.closest('tr');
    if (confirm("Bạn có chắc chắn muốn xóa dòng này không?")) {
        const row = deleteButton.closest('tr');
        if (row) {
            row.remove();
            updateRowNumbers();
            alert("Dòng đã được xóa thành công!");
        }
    }
}

function updateProductDropdowns() {
    // 1. Lấy tất cả các ID sản phẩm đã được chọn trong form
    const selectedProductIds = new Set();

    document.querySelectorAll('tr[data-product-id]').forEach(row => {
        selectedProductIds.add(row.dataset.productId);
    });

    document.querySelectorAll('.product-select').forEach(select => {
        if (select.value) { // Chỉ lấy những select đã có giá trị
            selectedProductIds.add(select.value);
        }
    });

    // 2. Lặp qua từng dropdown để cập nhật các option của nó
    document.querySelectorAll('.product-select').forEach(select => {
        const currentSelectedValue = select.value; // Giá trị đang được chọn của chính dropdown này

        // Lặp qua từng option trong dropdown hiện tại
        select.querySelectorAll('option').forEach(option => {
            if (!option.value || option.value === currentSelectedValue) {
                option.disabled = false;
                return; // Bỏ qua, đi tới option tiếp theo
            }
            const isAlreadySelected = selectedProductIds.has(option.value);
            const freeToUseAttr = option.getAttribute('data-freeToUse');

            const freeToUse = parseInt(freeToUseAttr);
            const isOutOfStock = freeToUse <= 0;

            if (isAlreadySelected || isOutOfStock) {
                option.disabled = true;
            } else {
                option.disabled = false;
            }
        });
    });
}

function handleProductChange(selectElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];

    const priceString = selectedOption.getAttribute('data-price') || '0';
    const originalPrice = parseFloat(priceString);
    const row = selectElement.closest('tr');
    const freeToUseInput = row.querySelector('.freeToUse-cell');
    const freeToUse = selectedOption.getAttribute('data-freeToUse') || 0;
    const imageInput = row.querySelector('.image-cell');
    const image = selectedOption.getAttribute('data-image');
    if (!row) {
        console.error("Could not find the parent row.");
        return;
    }

    const unitPriceInput = row.querySelector('.unit-price');
    
    imageInput.src = "./assets/images/table/product/" + image;
            
    unitPriceInput.value = originalPrice.toFixed(0);

    unitPriceInput.setAttribute('data-original-price', originalPrice);

    freeToUseInput.textContent = freeToUse;

    updateSubtotal(row);
    updateProductDropdowns();
}

function handlePriceChange(priceInput) {
    const row = priceInput.closest('tr');
    updateSubtotal(row);
}

function handleQuantityChange(quantityInput) {
    const row = quantityInput.closest('tr');
    updateSubtotal(row);
}

function updateSubtotal(row) {
    const unitPriceInput = row.querySelector('.unit-price');
    const quantityInput = row.querySelector('.quantity-input');
    const subtotalCell = row.querySelector('.subtotal-cell');

    const price = parseFloat(unitPriceInput.value) || 0;
    const quantity = parseInt(quantityInput.value) || 0;

    const subtotal = price * quantity;

    subtotalCell.textContent = subtotal.toFixed(2);
}

function handleTaxChange(selectElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];

    const taxRate = selectedOption.getAttribute('data-rate');

    const row = selectElement.closest('tr');

    const taxRateCell = row.querySelector('.tax-rate-cell');

    taxRateCell.textContent = taxRate;
}

function validateForm() {
    const rows = document.querySelectorAll("#productTableBody tr");
    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const productSelect = row.querySelector('.product-select');
        const taxSelect = row.querySelector('.tax-select');
        const quantityInput = row.querySelector('.quantity-input');
        const unitPriceInput = row.querySelector('.unit-price');
        const rowNumber = i + 1;

        if (productSelect.value === "") {
            alert(`Error in row #${rowNumber}: Please select a product.`);
            productSelect.focus();
            return false;
        }

        const currentPrice = parseFloat(unitPriceInput.value);
        if (currentPrice < 1) {
            alert(`Error in row #${rowNumber}: Price must be a number and > 0.`);
            unitPriceInput.focus();
            return false;
        }
        const originalPriceString = unitPriceInput.getAttribute('data-original-price');
        if (originalPriceString) {
            const originalPrice = parseFloat(originalPriceString);
            const lowerBound = originalPrice * 0.9;
            const upperBound = originalPrice * 1.1;

            if (currentPrice < lowerBound || currentPrice > upperBound) {
                alert(
                        `Lỗi ở dòng #${rowNumber}: Giá chỉ có thể được điều chỉnh trong phạm vi 10%.\n\n` +
                        `Giá gốc: ${originalPrice}\n` +
                        `Phạm vi cho phép: ${lowerBound.toFixed(0)} - ${upperBound.toFixed(0)}`
                        );
                unitPriceInput.focus();
                unitPriceInput.value = originalPriceString;
                return false;
            }
        }

        const quantity = parseInt(quantityInput.value);
        if (quantity < 1) {
            alert(`Error in row #${rowNumber}: Quantity must be a number and at least 1.`);
            quantityInput.focus();
            return false;
        }
        const freeToUseInput = row.querySelector('.freeToUse-cell');
        const availableStock = parseInt(freeToUseInput.textContent);
        if (availableStock < quantity) {
            alert(`Error in row #${rowNumber}: Quantity must be less than free to use.`);
            quantityInput.value = availableStock;
            quantityInput.focus();
            return false;
        }
        if (taxSelect.value === "") {
            alert(`Error in row #${rowNumber}: Please select a tax.`);
            taxSelect.focus();
            return false;
        }
    }
    return true;
}


// View send mail quotation
function openConfirmAddressForm(action) {
    const form = document.getElementById("actionForm");
    const modal = document.getElementById("ConfirmAddressModal");
    const modalAddressInput = document.getElementById("AddressInput");
    modal.setAttribute('data-action', action);
    modalAddressInput.value = '';
    modal.style.display = "block";
}

function closeConfirmAddressForm() {
    const modal = document.getElementById("ConfirmAddressModal");
    modal.style.display = "none";
}

function submitAddressAndAction() {
    const modal = document.getElementById("ConfirmAddressModal");
    const form = document.getElementById("actionForm");
    const actionInput = document.getElementById("actionTypeValue");
    const addressInput = document.getElementById("addressTypeValue");
    const modalAddressInput = document.getElementById("AddressInput");
    const currentAction = modal.getAttribute('data-action');
    const shippingAddress = modalAddressInput.value;
    if (shippingAddress.trim() === '') {
        alert('Please enter a shipping address.');
        return;
    }
    actionInput.value = currentAction;
    addressInput.value = shippingAddress;
    form.submit();
}

function submitUpdateQuotationSendedForm(action) {
    const form = document.getElementById("quotationResponseForm");
    const productRows = form.querySelectorAll("tbody tr");

    for (const row of productRows) {
        const quantityInput = row.querySelector(".quantity-input");
        const quantity = parseInt(quantityInput.value, 10);

        if (isNaN(quantity) || quantity < 1) {
            alert(`Error: Quantity must be a number and at least 1.`);
            quantityInput.focus();
            return;
        }
    }

    document.getElementById("actionValue").value = action;
    form.submit();
}

function submitRejectQuotationSendedForm(action) {
    const form = document.getElementById("quotationResponseForm");
    
    document.getElementById("actionValue").value = action;
    
    form.submit();
}

function submitRejectAction(action) {
    const modal = document.getElementById("ConfirmAddressModal");
    const form = document.getElementById("actionForm");
    const actionInput = document.getElementById("actionValue");
    const currentAction = action;
    actionInput.value = currentAction;
    form.submit();
}

function openFormRequestOrder() {
    const modal = document.getElementById("createRequestModal");
    modal.style.display = "block";
}

function closeFormRequestImport() {
    const modal = document.getElementById("createRequestModal");
    modal.style.display = "none";
}


