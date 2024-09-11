pragma circom 2.0.0;

template TaxCompliance() {
    signal input income;
    signal input deductions;
    signal input taxPaid;

    signal output taxCalculated;
    taxCalculated <== income - deductions;

    // Check if the tax is correct by using a signal difference
    signal isValid;
    isValid <== (taxCalculated - taxPaid) === 0;
}

component main = TaxCompliance();
