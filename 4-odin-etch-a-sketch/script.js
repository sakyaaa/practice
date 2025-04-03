const defaultGridSize = 16;

const mainContainer = document.getElementById("main-container");
const buttonDraw = document.createElement("button");

buttonDraw.onclick = () => {
    userSize = Math.min(Math.max(prompt("Enter grid size: ").trim(), 1), 100);
    mainContainer.innerHTML = "";
    drawGrid(userSize);
};

buttonDraw.innerHTML = "<div class=\"text\">Draw new grid</div>";
document.querySelector("body").prepend(buttonDraw);

function drawGrid(gridSize) {
    for (let i = 0; i < gridSize; i++) {
        const currentContainer = document.createElement("div");
        currentContainer.classList.add("container");

        for (let j = 0; j < gridSize; j++) {
            const currentItem = document.createElement("div");
            currentItem.classList.add("item");
            currentItem.onmousedown = () => { currentItem.style.backgroundColor = "#ffffff"; };

            currentContainer.appendChild(currentItem);
        }

        mainContainer.appendChild(currentContainer);
    }
}

drawGrid(defaultGridSize);
