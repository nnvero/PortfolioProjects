
# Chi-Square
#### Video Demo:  https://youtu.be/QsXGvAN2G80

#### Description:

Welcome to the Chi-Square program, a powerful tool designed to quickly validate predictions about genetic populations. But first, let's delve into the meaning of the program's name.

### What is Chi?

The name "Chi" originates from the statistical concept χ2 (chi-square), a fundamental tool in genetics. This test helps determine if there are significant deviations between observed and expected outcomes of alleles in a population. The underlying assumption is that there are no substantial differences between the measured and predicted results.

## Program Overview

The Chi-Square program streamlines the process of validating predictions by calculating the chi-square statistic. Here's a breakdown of what the program does:

1. **Population and Prediction:**
   - You provide the program with a population and a predicted ratio between classes (e.g., 9:3:3:1).

2. **Chi-Square Calculation:**
   - The program handles the complex formula, sparing you from manual calculations.
   - It requires inputs such as the ratio and the number of each phenotype class.

3. **Automated Operations:**
   - The program calculates the theoretical value of each class, multiplies it by the ratio, determines degrees of freedom, finds the necessary probability, and compares the result with reference values.

4. **User-Friendly GUI:**
   - Developed as a desktop application in Python.
   - GUI implementation using the tkinter package for a seamless user experience.

5. **Reference Value Comparison:**
   - Utilizes the csv module to compare results with reference values stored in a .csv file.

## Why Use Chi-Square?

Manually performing chi-square calculations can be time-consuming and error-prone due to the complexity of the formula and multiple required inputs. The Chi-Square program simplifies this process, providing quick and accurate results to validate population predictions.

## Getting Started

To use the Chi-Square program:

Main inputs are the ratio, number of phenotype classes and probability level. Ratio and number of classes are entered manually, probability level is set via drop-down list.
1. Define ratio and number of phenotype classes
Ratio and number of class are added as pairs after clicking on "Add values" button.

Example: the ratio is 9:3:3:1, number of phenotype classes are 315 (meets ratio 9), 108 (meets ratio 3), 101 (meets ratio 3) and 32 (meets ratio 1). Pairs 9/315, 3/108, 3/101, 1/32 must be added one by one.
2. Define probability level
In the drop-down list select probability level depending on your requirements. It is set to 0.95 by default, so change it only if you need.
3. Get a result
Click "Get Chi" button. Calculated Chi-Square and conclusion will be printed out below.

## System Requirements

- Python installed on your system.
- Dependencies: tkinter, csv module.

## Installation

Clone the repository and run the program on your local machine:

```bash

