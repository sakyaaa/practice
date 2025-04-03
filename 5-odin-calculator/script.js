const main = document.getElementById("main");

const resultTextarea = document.getElementById("result");

const buttonDigit0 = document.getElementById("digit-0");
const buttonDigit1 = document.getElementById("digit-1");
const buttonDigit2 = document.getElementById("digit-2");
const buttonDigit3 = document.getElementById("digit-3");
const buttonDigit4 = document.getElementById("digit-4");
const buttonDigit5 = document.getElementById("digit-5");
const buttonDigit6 = document.getElementById("digit-6");
const buttonDigit7 = document.getElementById("digit-7");
const buttonDigit8 = document.getElementById("digit-8");
const buttonDigit9 = document.getElementById("digit-9");
const buttonDigitDot = document.getElementById("digit-dot");

const buttonOperationPlus = document.getElementById("operation-plus");
const buttonOperationMinus = document.getElementById("operation-minus");
const buttonOperationMultiply = document.getElementById("operation-multiply");
const buttonOperationDivide = document.getElementById("operation-divide");
const buttonOperationEquals = document.getElementById("operation-equals");
const buttonOperationBackspace = document.getElementById("operation-backspace");

buttonDigit0.onclick = () => { resultTextarea.textContent += "0"; };
buttonDigit1.onclick = () => { resultTextarea.textContent += "1"; };
buttonDigit2.onclick = () => { resultTextarea.textContent += "2"; };
buttonDigit3.onclick = () => { resultTextarea.textContent += "3"; };
buttonDigit4.onclick = () => { resultTextarea.textContent += "4"; };
buttonDigit5.onclick = () => { resultTextarea.textContent += "5"; };
buttonDigit6.onclick = () => { resultTextarea.textContent += "6"; };
buttonDigit7.onclick = () => { resultTextarea.textContent += "7"; };
buttonDigit8.onclick = () => { resultTextarea.textContent += "8"; };
buttonDigit9.onclick = () => { resultTextarea.textContent += "9"; };
buttonDigitDot.onclick = () => { resultTextarea.textContent += "."; };

buttonOperationPlus.onclick = () => { resultTextarea.textContent += "+"; };
buttonOperationMinus.onclick = () => { resultTextarea.textContent += "-"; };
buttonOperationMultiply.onclick = () => { resultTextarea.textContent += "*"; };
buttonOperationDivide.onclick = () => { resultTextarea.textContent += "/"; };

buttonOperationEquals.onclick = () => {
    resultTextarea.textContent = parseFormula(resultTextarea.textContent);
};

buttonOperationBackspace.onclick = () => {
    resultTextarea.textContent = resultTextarea.textContent.substring(0, resultTextarea.textContent.length - 1);
};

function parseFormula(input) {
    if (input == "") return;

    let currentNumber = "";
    const tokens = [];
    const isDigit = /[0-9.]/;

    // Parses string to token array
    for (let current in input) {
        if (isDigit.test(input[current])) {
            currentNumber += input[current];
        } else {
            if (currentNumber != "")  {
                tokens.push(parseFloat(currentNumber));
                currentNumber = "";
            } else continue;

            if (!isDigit.test(tokens[tokens.length - 1])) continue;
            tokens.push(input[current]);
        }
    }

    // Pushing remaining number
    if (currentNumber != "") {
        tokens.push(parseFloat(currentNumber));
        currentNumber = "";
    }

    // Operations priority in entrie formula
    const operationsEnumeration = { "+": 1, "-": 1, "*": 2, "/": 2 };

    // Used to apply operation to values and returns result
    function operate(secondInput, operation, firstInput) {
        let firstValue = parseFloat(firstInput);
        let secondValue = parseFloat(secondInput);

        switch (operation) {
            case "+":
                return firstValue + secondValue;
            case "-":
                return firstValue - secondValue;
            case "*":
                return firstValue * secondValue;
            case "/":
                if (secondValue == 0)
                    return "ERROR: Trying to divide by zero!";

                return firstValue / secondValue;
        }
    }

    const values = []
    const operations = []

    // Applying operations with tokens
    for (let token in tokens) {
        if (tokens[token] in operationsEnumeration) {
            while (operations.length > 0 && operationsEnumeration[operations[operations.length - 1]] >= operationsEnumeration[tokens[token]]) {
                values.push(operate(values.pop(), operations.pop(), values.pop()));
            }

            operations.push(tokens[token]);
        } else {
            values.push(tokens[token]);
        }
    }

    // Applying remaining operator
    while (operations.length > 0) {
        values.push(operate(values.pop(), operations.pop(), values.pop()));
    }

    return parseFloat(values.pop()).toFixed(2);
}
