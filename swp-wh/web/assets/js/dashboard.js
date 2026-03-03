/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


window.addEventListener('DOMContentLoaded', function () {
    const greetingEl = document.getElementById("greeting");
    const hour = new Date().getHours();
    let greetingText = "";

    if (hour >= 5 && hour < 12) {
        greetingText = "Good Morning";
    } else if (hour >= 12 && hour < 19) {
        greetingText = "Good Afternoon";
    } else if (hour >= 19 && hour < 22) {
        greetingText = "Good Evening";
    } else {
        greetingText = "Good Night";
    }

    greetingEl.textContent = greetingText;
});
