# zkTaxVerifier




Here’s a detailed guide based on the reference steps and your current file structure:
1. Initial Powers of Tau Setup

# Initialize the initial Powers of Tau file
snarkjs powersoftau new bn128 12 ceremony_0000.ptau -v

# Contribute entropy
snarkjs powersoftau contribute ceremony_0000.ptau ceremony_0001.ptau --name="First Contributor" -v
snarkjs powersoftau contribute ceremony_0001.ptau ceremony_0002.ptau --name="Second Contributor" -v

# Verify the Powers of Tau
snarkjs powersoftau verify ceremony_0002.ptau -v


2. Phase 2 Randomness

# Prepare Phase 2
snarkjs powersoftau prepare phase2 ceremony_0002.ptau ceremony_final.ptau -v

# Verify the final Powers of Tau file
snarkjs powersoftau verify ceremony_final.ptau -v


3. Compile the Circuit

# Compile your circuit
circom circuits/taxCompliance.circom --r1cs --wasm --sym


4. Generate the Proving Key

# Setup Groth16 proving key
snarkjs groth16 setup circuits/taxCompliance.r1cs ceremony_final.ptau setup_0000.zkey

5. Contribute to zkey

# Contribute to zkey
snarkjs zkey contribute setup_0000.zkey setup_final.zkey --name="First Contributor" -v


6. Verify the zkey


snarkjs zkey verify circuits/taxCompliance.r1cs ceremony_final.ptau setup_final.zkey -v

7. Generate Proof


# Generate proof
snarkjs groth16 fullprove inputs/input.json circuits/taxCompliance_js/taxCompliance.wasm setup_final.zkey proof.json public.json

8. Export Solidity Verifier


# Export Solidity Verifier
snarkjs zkey export solidityverifier setup_final.zkey verifier.sol

9. Export Solidity calldata for Remix


# Export calldata for Remix
snarkjs zkey export soliditycalldata public.json proof.json

Deploy and Verify in Remix

You can now use Remix IDE to deploy the generated verifier.sol smart contract and use the exported calldata to verify the proof on-chain.

This should complete your zk-SNARK proof setup and verification. Let me know if you need any further clarifications!