
let elements = document.querySelectorAll("button.dropdown-button");
elements.forEach(button => {
    button.addEventListener("click", () => {
        if (button.classList.contains("active")) {
            button.classList.remove("active");
        } else {
            button.classList.add("active");
        }
    });
});
