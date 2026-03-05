//Update start
function openUpdateForm(id, name, phone, email, address, gender) {
    document.getElementById('customerId').value = id;
    if (gender === '1') {
        document.getElementById('customerMale').checked = true;
    } else if (gender === '0') {
        document.getElementById('customerFemale').checked = true;
    }
    document.getElementById('customerName').value = name;
    document.getElementById('customerPhone').value = phone;
    document.getElementById('customerEmail').value = email;
    document.getElementById('customerAddress').value = address;
    document.getElementById('nameError').textContent = '';
    document.getElementById('phoneError').textContent = '';
    document.getElementById('emailError').textContent = '';
    document.getElementById('addressError').textContent = '';
    document.getElementById('updateModal').style.display = 'block';
}

function closeUpdateForm() {
    document.getElementById('updateModal').style.display = 'none';
}

function submitUpdateForm() {
    document.getElementById('updateForm').submit();
}
//Update end

//Add start
function submitAddForm() {
    document.getElementById("addForm").submit();
}

function openAddForm() {
    document.getElementById('addModal').style.display = 'block';
}

function closeAddForm() {
    document.getElementById('addModal').style.display = 'none';
}
//Add end

//Delete start
function openDeleteForm(id, code) {
    document.getElementById('CustomerIdInput').value = id;
    document.getElementById('deleteCustomerCode').innerText = code;
    document.getElementById('delete').style.display = 'block';
}

function closeDeleteForm() {
    document.getElementById('delete').style.display = 'none';
}

function submitDeleteForm() {
    document.getElementById('deleteForm').submit();
}
//Delete end

//Alert
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

