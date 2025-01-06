pragma circom 2.1.6;

include "poseidon.circom";


template TaxCompliance() {
    // Input signals
    signal input income;
    signal input deductions;
    signal input taxable_amount;
    signal input tax_paid;
    signal input public_hash; // Public hash for verification

    // Output signals
    signal calc_taxable_amount;
    signal calc_tax_paid;
    signal computed_hash;

    // Constants
    signal input tax_rate; // Tax rate as an input

    // Calculate taxable amount
    calc_taxable_amount <== income - deductions;
    calc_taxable_amount === taxable_amount;

    // Calculate tax paid
    calc_tax_paid <== taxable_amount * tax_rate;
    calc_tax_paid === tax_paid;

    // Poseidon hash computation for inputs
    component poseidon = Poseidon(5); // Define with correct number of inputs
    poseidon.inputs[0] <== income;
    poseidon.inputs[1] <== deductions;
    poseidon.inputs[2] <== taxable_amount;
    poseidon.inputs[3] <== tax_paid;
    poseidon.inputs[4] <== tax_rate;
    computed_hash <== poseidon.out;

    // Public hash verification
    computed_hash === public_hash;
}

// Main circuit
component main = TaxCompliance();



template TaxCompliance() {
    // Input signals
    signal input income;
    signal input deductions;
    signal input taxable_amount;
    signal input tax_paid;
    signal input public_hash; // Public hash for verification

    // Output signals
    signal calc_taxable_amount;
    signal calc_tax_paid;
    signal computed_hash;

    // Constants
    signal input tax_rate; // Tax rate as an input

    // Calculate taxable amount
    calc_taxable_amount <== income - deductions;
    calc_taxable_amount === taxable_amount;

    // Calculate tax paid
    calc_tax_paid <== taxable_amount * tax_rate;
    calc_tax_paid === tax_paid;

    // Poseidon hash computation for inputs
    component poseidon = Poseidon(5); // Define with correct number of inputs
    poseidon.inputs[0] <== income;
    poseidon.inputs[1] <== deductions;
    poseidon.inputs[2] <== taxable_amount;
    poseidon.inputs[3] <== tax_paid;
    poseidon.inputs[4] <== tax_rate;
    computed_hash <== poseidon.out;

    // Public hash verification
    computed_hash === public_hash;
}

// Main circuit
component main = TaxCompliance();
