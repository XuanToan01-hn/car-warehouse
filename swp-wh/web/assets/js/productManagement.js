
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

//Update open
function openUpdateForm(id, name, code, description, price, image, cateid, unit) {
    document.getElementById('product-id').value = id;
    document.getElementById('product-name').value = name;
    document.getElementById('product-code').value = code;
    document.getElementById('product-price').value = price;
    document.getElementById('file-image').textContent = image;
    document.getElementById('product-image-old').value = image;
    document.getElementById('product-des').value = description;
    document.getElementById('category-select').value = cateid;
    document.getElementById('unit-select').value = unit;
    document.getElementById('product-id').style.border = '1px solid #DCDFE8';
    document.getElementById('product-name').style.border = '1px solid #DCDFE8';
    document.getElementById('product-code').style.border = '1px solid #DCDFE8';
    document.getElementById('product-price').style.border = '1px solid #DCDFE8';
    document.getElementById('product-des').style.border = '1px solid #DCDFE8';
    document.getElementById('error1').textContent = '';
    document.getElementById('error2').textContent = '';
    document.getElementById('error3').textContent = '';
    document.getElementById('error4').textContent = '';
    document.getElementById('updateModal').style.display = 'block';
}

//Delete open
function openDeleteForm(id, name) {
    document.getElementById('deleteProductId').value = id;
    document.getElementById('deleteProductName').innerHTML = name;
    document.getElementById('deleteModal').style.display = 'block';
}

//Update close
function closeUpdateForm() {
    document.getElementById('updateModal').style.display = 'none';
}

//Delete close
function closeDeleteForm() {
    document.getElementById('deleteModal').style.display = 'none';
}


document.getElementById('product-price').addEventListener('input', function () {
    let price = parseInt(this.value); // ép kiểu sang số

    if (price >= 10000000000) {
        this.value = 1000;
    }
});
