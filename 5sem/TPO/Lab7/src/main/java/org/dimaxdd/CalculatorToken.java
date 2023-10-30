package org.dimaxdd;

import java.util.Objects;

class CalculatorToken {
    private final Double number;
    private final Character operation;
    private final int index;

    private CalculatorToken(Double number, int index) {
        this.number = number;
        this.operation = null;
        this.index = index;
    }

    private CalculatorToken(Character operation, int index) {
        this.number = null;
        this.operation = operation;
        this.index = index;
    }

    public static CalculatorToken number(Double number, int index) {
        return new CalculatorToken(number, index);
    }

    public static CalculatorToken operation(Character operation, int index) {
        return new CalculatorToken(operation, index);
    }

    boolean isNumber() {
        return number != null && operation == null;
    }

    boolean isOperation() {
        return number == null && operation != null;
    }

    public Double getNumber() {
        return number;
    }

    public Character getOperation() {
        return operation;
    }

    public int getIndex() {
        return index;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CalculatorToken that = (CalculatorToken) o;
        return index == that.index && Objects.equals(number, that.number) && Objects.equals(operation, that.operation);
    }

    @Override
    public int hashCode() {
        return Objects.hash(number, operation, index);
    }

    @Override
    public String toString() {
        return "CalculatorToken{" +
                "number=" + number +
                ", operation=" + operation +
                ", index=" + index +
                '}';
    }
}
