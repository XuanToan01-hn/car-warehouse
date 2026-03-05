const now = new Date();
const year = now.getFullYear();
const month = String(now.getMonth() + 1).padStart(2, '0');
const day = String(now.getDate()).padStart(2, '0');
const today = `${year}-${month}-${day}`;

document.getElementById('dateInput').value = today;

function openSelectForm() {
    document.getElementById('selectModal').style.display = 'block';
}

function closeSelectForm() {
    document.getElementById('selectModal').style.display = 'none';
}

function openUpdateForm() {
    document.getElementById('updateModal').style.display = 'block';
}
function closeUpdateForm() {
    document.getElementById('updateModal').style.display = 'none';
}

function closeDeleteForm() {
    document.getElementById('deleteModal').style.display = 'none';
}
function openDeleteForm(productId, productName) {
    document.getElementById('deleteProductId').value = productId;
    document.getElementById('deleteProductName').innerText = productName;
    document.getElementById('deleteModal').style.display = 'block';
}
// Close the modal when clicking outside of it
window.onclick = function (event) {
    const modal = document.getElementById('selectModal');
    if (modal && event.target === modal) {
        modal.style.display = 'none';
    }
};

function  backToSale() {
    document.getElementById("backtosale").submit();
}

function openTransferInternal(saleId, warehourseId, productId) {
    document.getElementById("saleFrom").value = saleId;
    document.getElementById("warehouseTF").value = warehourseId;
    document.getElementById("productTF").value = productId;
    document.getElementById("transferForm").submit();
}

function chooseWarehouse(prductid, id, warehouse, address, quantity) {
    document.getElementById("product-select").value = prductid;
    document.getElementById("WarehoureId").value = id;
    document.getElementById("wahouseName").value = warehouse;
    document.getElementById("wahouseAddress").value = address;
    document.getElementById("wahouseQuantity").value = quantity;
}

function postWarehouse(warehouseId, saleId) {
    document.getElementById("saleId").value = saleId;
    document.getElementById("warehouseId").value = warehouseId;
    document.getElementById("hiddenForm").submit();
}

function btnAddTransfer() {
    const tableBody = document.getElementById('warehouseTableBody');
    const productRowTemplate = document.getElementById('warehouseRowTemplate');
    const newRowFragment = productRowTemplate.content.cloneNode(true);
    tableBody.appendChild(newRowFragment);
    updateSelectOptions();
}

function handleDeleteTransfer(deleteButton) {
    const row = deleteButton.closest('tr');
    row.remove();
    updateTotalQuantity();
}

function handleWarehouseChoose(selectElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];
    const quantity = selectedOption.getAttribute('data-quantity');
    const row = selectElement.closest('tr');

    const unitInput = row.querySelector('.unit-order');
    unitInput.value = 1;

    const unitHave = row.querySelector('.unit-quantity');
    unitHave.value = parseInt(quantity);

    updateSelectOptions();
    updateTotalQuantity();
}

function updateSelectOptions() {
    const allSelects = document.querySelectorAll('.product-select');

    const selectedValues = Array.from(allSelects)
            .map(select => select.value)
            .filter(value => value !== "" && value !== "0");

    allSelects.forEach(select => {
        const options = select.querySelectorAll('option');

        options.forEach(option => {
            const optValue = option.value;

            if (optValue === "" || optValue === "0") {
                option.hidden = false;
            } else {
                option.hidden = selectedValues.includes(optValue) && select.value !== optValue;
            }
        });
    });
}

document.addEventListener('input', function (e) {
    if (e.target.classList.contains('unit-order')) {
        const input = e.target;
        const row = input.closest('tr');
        const maxInput = row.querySelector('.unit-quantity');

        const maxVal = parseInt(maxInput.value);
        let currentVal = parseInt(input.value);

        // Nếu nhỏ hơn 1 → đặt lại 1
        if (currentVal < 1 || isNaN(currentVal)) {
            input.value = 1;
        }

        // Nếu lớn hơn max → đặt lại max
        if (!isNaN(maxVal) && currentVal > maxVal) {
            input.value = maxVal;
        }

        // Cập nhật tổng
        updateTotalQuantity();
    }
});


function updateTotalQuantity() {
    const inputs = document.querySelectorAll('.unit-order');
    let total = 0;

    inputs.forEach(input => {
        const row = input.closest("tr");
        const select = row.querySelector("select");

        if (select && select.value !== "0") {
            const val = parseInt(input.value);
            if (!isNaN(val)) {
                total += val;
            }
        }
    });

    document.getElementById("total-quantity").value = total;
}

function submitTransfer() {
    var need = parseInt(document.getElementById("quantity-need").value);
    var order = parseInt(document.getElementById("total-quantity").value);

    deleteInvalidWarehouseRows();

    if (order < need) {
        document.getElementById("error-order").innerText = "Total quantity must more than " + need;
    } else {
        document.getElementById("submit-form-transfer").submit();
    }
}

function deleteInvalidWarehouseRows() {
    const tableBody = document.getElementById('warehouseTableBody');

    const rows = tableBody.querySelectorAll('tr');

    rows.forEach(row => {
        const select = row.querySelector('select.product-select');
        if (select && select.value === "0") {
            row.remove();
        }
    });
}

function handleExport(sevrletURL) {
    const createDateInput = document.getElementById("dateInput");
    const pickUpDateInput = document.getElementById("pickUpDate");

    const createDate = new Date(createDateInput.value);
    const pickUpDate = new Date(pickUpDateInput.value);

    const rows = document.querySelectorAll('#ligth-body tr');
    let hasError = false;

    rows.forEach(row => {
        const cells = row.getElementsByTagName('td');
        const docText = cells[2].textContent.trim();
        const actText = cells[3].textContent.trim();

        const quantityDoc = parseInt(docText);
        const quantityAct = parseInt(actText);

        if (quantityDoc > quantityAct) {
            hasError = true;
        }
    });

    if (hasError) {
        document.getElementById("error-export").innerText = "Insufficient stock!";
    } else {
        var form = document.getElementById('exportForm');
        form.action = sevrletURL;
        if (form.checkValidity()) {
            if (pickUpDate < createDate) {
                document.getElementById("error-export").innerText = "Pickup Date must after create date!";
                document.getElementById("pickUpDate").style.border = '1px solid red';
            } else {
                form.submit();
            }
        } else {
            form.reportValidity();
        }
    }
}

function handleTrans(sevrletURL) {
    const receiptDateInput = document.getElementById("recepitDate");
    const createDateInput = document.getElementById("dateInput");
    const pickUpDateInput = document.getElementById("shipDate");

    const receiptDate = new Date(receiptDateInput.value);
    const createDate = new Date(createDateInput.value);
    const pickUpDate = new Date(pickUpDateInput.value);

    var form = document.getElementById('exportForm');

    form.action = sevrletURL;
    if (form.checkValidity()) {
        if (pickUpDate < createDate) {
            document.getElementById("error-export").innerText = "Shipment Date must after create date!";
            document.getElementById("shipDate").style.border = '1px solid red';
        } else {
            document.getElementById("shipDate").style.border = '1px solid #DCDFE8';
            if (receiptDate < pickUpDate) {
                document.getElementById("error-export").innerText = "Receipt Date must after shipment date!";
                document.getElementById("recepitDate").style.border = '1px solid red';
            } else {
                form.submit();
            }
        }
    } else {
        form.reportValidity();
    }

}

function handleRequest() {
    const startDate = new Date(dateInput.value);
    const endDate = new Date(dateLine.value);
    var form = document.getElementById('exportForm');
    form.action = 'create-replenishment';
    if (form.checkValidity()) {
        if (dateInput.value && dateLine.value && endDate < startDate) {
            errorExport.textContent = "Ngày hết hạn phải lớn hơn hoặc bằng ngày tạo!";
            dateLine.style.border = "1px solid #E08DB4";
            dateInput.style.border = "1px solid #E08DB4";
        } else {
            form.submit();
        }
    } else {
        form.reportValidity();
    }
}

function createrequest(sevrletURL) {
    const createDateInput = document.getElementById("dateInput");
    const pickUpDateInput = document.getElementById("pickUpDate");
    const createDate = new Date(createDateInput.value);
    const pickUpDate = new Date(pickUpDateInput.value);
    var form = document.getElementById('exportForm');
    form.action = sevrletURL;
    if (form.checkValidity()) {
        if (pickUpDate < createDate) {
            document.getElementById("error-export").innerText = "Pickup Date must after create date!";
            document.getElementById("pickUpDate").style.border = '1px solid red';
        } else {
            form.submit();
        }
    } else {
        form.reportValidity();
    }
}


function checkDatails(formId, urlSevrlet) {
    document.getElementById(formId).action = urlSevrlet;
    document.getElementById(formId).submit();
}

function selectWarehourseTrans(formId, urlSevrlet) {
    document.getElementById("warehouseC").value = document.getElementById("warehouseCF").value;
    document.getElementById(formId).action = urlSevrlet;
    document.getElementById(formId).submit();
}

function backListExport() {
    window.location.href = "list-export";
}

function backListTransferInternal() {
    window.location.href = "list-transfer-internal";
}

function backListExport(url) {
    document.getElementById("backListExport").action = url;
    document.getElementById("backListExport").submit();
}

document.querySelectorAll('.unit-quantity').forEach(function (input) {
    input.addEventListener('input', function () {
        const val = Number(this.value);
        if (isNaN(val) || val < 0) {
            this.value = 0;
        }
    });
});

function submitTransferInternal(sevrletURL) {
    const form = document.getElementById("exportForm");
    form.action = sevrletURL;
    form.submit();
}


function pagingTransfer(page) {
    document.getElementById("pageTransfer").value = page;
    document.getElementById("listTransferInternal").submit();
}

function processTransfer(id) {
    document.getElementById("exportId").value = id;
    document.getElementById("processExportForm").submit();
}

window.addEventListener('DOMContentLoaded', function () {
    const greetingEl = document.getElementById("greeting");
    const hour = new Date().getHours();
    let greetingText = "";

    if (hour >= 5 && hour < 12) {
        greetingText = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
        greetingText = "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
        greetingText = "Good Evening";
    } else {
        greetingText = "Good Night";
    }

    greetingEl.textContent = greetingText;
});

function submitWarehouseChange1(warehouseId, productId) {
    document.getElementById("warehouseId").value = warehouseId;
    document.getElementById("productId").value = productId;
    document.getElementById("requestOrder").submit();
}

document.getElementById("demand").addEventListener('input', function () {
    if (this.value < 1) {
        this.value = 1;
    }
});

const dateInput = document.getElementById('dateInput');
const dateLine = document.getElementById('dateLine');
const errorExport = document.getElementById('error-export');

function validateDates() {
    const startDate = new Date(dateInput.value);
    const endDate = new Date(dateLine.value);

    if (dateInput.value && dateLine.value && endDate < startDate) {
        errorExport.textContent = "Ngày hết hạn phải lớn hơn hoặc bằng ngày tạo!";
        dateLine.style.border = "1px solid #E08DB4";
        dateInput.style.border = "1px solid #E08DB4";
    } else {
        errorExport.textContent = "";
        dateLine.style.border = "1px solid #DCDFE8";
        dateInput.style.border = "1px solid #DCDFE8";
    }
}

dateInput.addEventListener('change', validateDates);
dateLine.addEventListener('change', validateDates);     