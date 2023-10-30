package org.dimaxdd;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Calculator {

    public Optional<Double> solve(String line) {
        Optional<Double> optional = Optional.empty();
        Pattern pattern = Pattern.compile("^\\d+([+\\-*/]\\d+)*$");
        Matcher matcher = pattern.matcher(line);
        if (matcher.matches()) {
            List<CalculatorToken> tokens = new ArrayList<>();
            StringBuilder numberBuffer = new StringBuilder();
            for (int i = 0; i < line.length() + 1; i++) {
                if (i == line.length()) {
                    tokens.add(CalculatorToken.number(Double.valueOf(String.valueOf(numberBuffer)), tokens.size()));
                    break;
                }
                if (Pattern.compile("^[+\\-*/]$").matcher(String.valueOf(line.charAt(i))).matches()) {
                    if (numberBuffer.length() > 0) {
                        tokens.add(CalculatorToken.number(Double.valueOf(String.valueOf(numberBuffer)), tokens.size()));
                        numberBuffer = new StringBuilder();
                    }
                    tokens.add(CalculatorToken.operation(line.charAt(i), tokens.size()));
                } else {
                    numberBuffer.append(line.charAt(i));
                }
            }
            List<CalculatorToken> operations = tokens.stream().filter(new Predicate<CalculatorToken>() {
                @Override
                public boolean test(CalculatorToken token) {
                    return token.isOperation();
                }
            }).sorted(new Comparator<CalculatorToken>() {
                @Override
                public int compare(CalculatorToken token1, CalculatorToken token2) {
                    if ((token1.getOperation() == '*' || token1.getOperation() == '/')
                            && (token2.getOperation() == '+' || token2.getOperation() == '-'))
                        return -1;
                    else if ((token2.getOperation() == '*' || token2.getOperation() == '/')
                            && (token1.getOperation() == '+' || token1.getOperation() == '-'))
                        return 1;
                    else return 0;
                }
            }).collect(Collectors.toList());
            List<CalculatorToken> numbers = tokens.stream().filter(new Predicate<CalculatorToken>() {
                @Override
                public boolean test(CalculatorToken token) {
                    return token.isNumber();
                }
            }).collect(Collectors.toList());
            Double result = null;
            for (int i = 0; i < operations.size(); i++) {
                CalculatorToken operation = operations.get(i);
                double operand1 = 0;
                double operand2 = 0;
                Predicate<CalculatorToken> operandPredicate1 = new Predicate<CalculatorToken>() {
                    @Override
                    public boolean test(CalculatorToken number) {
                        return number.getIndex() == operation.getIndex() - 1;
                    }
                };
                Predicate<CalculatorToken> operandPredicate2 = new Predicate<CalculatorToken>() {
                    @Override
                    public boolean test(CalculatorToken number) {
                        return number.getIndex() == operation.getIndex() + 1;
                    }
                };
                if (result == null) {
                    Optional<CalculatorToken> op1 = numbers.stream().filter(operandPredicate1).findFirst();
                    if (op1.isPresent())
                        operand1 = op1.get().getNumber();
                    Optional<CalculatorToken> op2 = numbers.stream().filter(operandPredicate2).findFirst();
                    if (op2.isPresent())
                        operand2 = op2.get().getNumber();
                } else if (operations.get(i - 1).getIndex() > operation.getIndex()) {
                    Optional<CalculatorToken> op1 = numbers.stream().filter(operandPredicate1).findFirst();
                    if (op1.isPresent())
                        operand1 = op1.get().getNumber();
                    operand2 = result;
                } else if (operations.get(i - 1).getIndex() < operation.getIndex()) {
                    operand1 = result;
                    Optional<CalculatorToken> op2 = numbers.stream().filter(operandPredicate2).findFirst();
                    if (op2.isPresent())
                        operand2 = op2.get().getNumber();
                }
                switch (operation.getOperation()) {
                    case '+':
                        result = operand1 + operand2;
                        break;
                    case '-':
                        result = operand1 - operand2;
                        break;
                    case '*':
                        result = operand1 * operand2;
                        break;
                    case '/':
                        result = operand1 / operand2;
                        break;
                }
            }
            optional = Optional.ofNullable(result);
        }
        return optional;
    }
}
