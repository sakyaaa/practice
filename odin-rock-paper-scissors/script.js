// Rock, Paper and Scissors game

const Choices = Object.freeze({
    ROCK: "rock",
    PAPER: "paper",
    SCISSORS: "scissors"
});

const Winners = Object.freeze({
    HUMAN: "human",
    COMPUTER: "computer",
    DRAW: "draw",
});

// Random choice
function getComputerChoice() {
    return Choices[Object.keys(Choices)[Math.floor(Math.random() * Object.keys(Choices).length)]];
}

// Who win the round logic
function getRoundWinner(humanChoice, computerChoice) {
    if (humanChoice == computerChoice) return Winners.DRAW;

    switch (humanChoice) {
        case Choices.ROCK:
            if (computerChoice == Choices.PAPER) return Winners.COMPUTER;
            if (computerChoice == Choices.SCISSORS) return Winners.HUMAN;
        case Choices.PAPER:
            if (computerChoice == Choices.SCISSORS) return Winners.COMPUTER;
            if (computerChoice == Choices.ROCK) return Winners.HUMAN;
        case Choices.SCISSORS:
            if (computerChoice == Choices.ROCK) return Winners.COMPUTER;
            if (computerChoice == Choices.PAPER) return Winners.HUMAN;
    }
}

// Main function
function playGame() {
    let computerScore = 0;
    let humanScore = 0;

    function playRound(humanChoice) {
        let computerChoice = getComputerChoice();
        let winner = getRoundWinner(humanChoice, computerChoice);
    
        switch (winner) {
            case Winners.COMPUTER:
                textInfo.textContent = `Computer win, ${computerChoice} beats ${humanChoice}`;
                computerScore++;
                textComputerScore.textContent = "Computer: " + computerScore;

                if (computerScore >= 5) {
                    textInfo.textContent += " and computer wins the game!";
                    buttonRock.disabled = true;
                    buttonPaper.disabled = true;
                    buttonScissors.disabled = true;
                }

                return;
            case Winners.HUMAN:
                textInfo.textContent = `Human win, ${humanChoice} beats ${computerChoice}`;
                humanScore++;
                textHumanScore.textContent = "Human: " + humanScore;

                if (humanScore >= 5) {
                    textInfo.textContent += " and human wins the game!";
                    buttonRock.disabled = true;
                    buttonPaper.disabled = true;
                    buttonScissors.disabled = true;
                }

                return;
            case Winners.DRAW:
                textInfo.textContent = "Draw, choices are similar, repeating round";
                return;
        }
    }

    // UI RENDER

    // BUTTONS
    const buttonRock = document.createElement("button");
    const buttonPaper = document.createElement("button");
    const buttonScissors = document.createElement("button");

    buttonRock.innerHTML = "<div class=\"text\">Rock</div>";
    buttonPaper.innerHTML = "<div class=\"text\">Paper</div>";
    buttonScissors.innerHTML = "<div class=\"text\">Scissors</div>";

    buttonRock.onclick = () => { playRound("rock"); }
    buttonPaper.onclick = () => { playRound("paper"); }
    buttonScissors.onclick = () => { playRound("scissors"); }

    // TEXT
    const textInfo = document.createElement("p");
    const textComputerScore = document.createElement("p");
    const textHumanScore = document.createElement("p");

    textInfo.classList.add("text");
    textComputerScore.classList.add("text");
    textHumanScore.classList.add("text");

    textInfo.textContent = "Make a choice";
    textComputerScore.textContent = "Computer: " + computerScore;
    textHumanScore.textContent = "Human: " + humanScore;

    // OUTPUT
    const outputText = document.getElementById("script-text");
    outputText.appendChild(textInfo);
    outputText.appendChild(textComputerScore);
    outputText.appendChild(textHumanScore);

    const outputButton = document.getElementById("script-buttons");
    outputButton.appendChild(buttonRock);
    outputButton.appendChild(buttonPaper);
    outputButton.appendChild(buttonScissors);
}

// Used when game played earlier
function newGame() {
    const outputText = document.getElementById("script-text");
    const outputButton = document.getElementById("script-buttons");

    // Clearing UI
    outputText.innerHTML = "";
    outputButton.innerHTML = "";

    playGame();
}

playGame();
