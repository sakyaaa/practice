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
    ERROR: "unknown human choice / incorrect input"
});

function getComputerChoice() {
    return Choices[Object.keys(Choices)[Math.floor(Math.random() * Object.keys(Choices).length)]];
}

function getHumanChoice() {
    return prompt("rock, paper or scissors?").toLowerCase().trim();
}

function getRoundWinner(humanChoice, computerChoice) {
    if (!humanChoice) return Winners.ERROR;
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

function playGame() {
    let computerScore = 0;
    let humanScore = 0;

    function playRound() {
        let computerChoice = getComputerChoice();
        let humanChoice = getHumanChoice();
        let winner = getRoundWinner(humanChoice, computerChoice);
    
        switch (winner) {
            case Winners.COMPUTER:
                console.log(`Computer win, ${computerChoice} beats ${humanChoice}`);
                computerScore++;
                return "ok";
            case Winners.HUMAN:
                console.log(`Human win, ${humanChoice} beats ${computerChoice}`);
                humanScore++;
                return "ok";
            case Winners.DRAW:
                console.log("Draw, choices are similar, repeating round");
                return "retry";
            case Winners.ERROR:
                console.log(`An error has occurred: ${Winners.ERROR}, repeating round`);
                return "retry";
        }
    }

    for (let i = 0; i < 5; i++) {
        var current = playRound();

        console.log("Round " + (i + 1));
        console.log("computer: " + computerScore);
        console.log("human: " + humanScore);

        switch (current) {
            case "ok":
                continue;
            case "retry":
                i--;
                continue;
        }
    }

    if (computerScore > humanScore) console.log("Computer wins the game!");
    else if (computerScore < humanScore) console.log("Human wins the game!");
}

function main() {
    while (true) playGame();
}

main()
