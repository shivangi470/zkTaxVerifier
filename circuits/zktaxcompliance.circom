
template IsEqual() {
    signal input a;
    signal input b;
    signal output out;

    signal diff;
    diff <== a - b;
    out <== 1 - diff * diff;  
}

template TaxCompliance() {
    signal input income;
    signal input deductions;
    signal input taxPaid;

    signal output taxCalculated;
    taxCalculated <== income - deductions;

    component eq = IsEqual();  
    eq.a <== taxCalculated;  
    eq.b <== taxPaid;         

    signal output isValid;
    isValid <== eq.out;       
}

component main = TaxCompliance();
