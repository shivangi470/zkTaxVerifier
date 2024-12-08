
# **ZKTax - Zero Knowledge Proof Tax Compliance Verification** 🧾🔐

## **Introduction** 🚀
ZKTax is a decentralized solution for tax compliance verification using **zk-SNARKs** (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge). It ensures that tax data is valid without revealing sensitive information. This project uses the **Groth16** protocol to generate proofs and verify them on the Ethereum blockchain.

![Untitled-1](https://github.com/user-attachments/assets/8d041939-4b96-4c72-9d4d-0ef41a11b64e)

![Untitled](https://github.com/user-attachments/assets/e2389c24-0dce-4708-a241-9b3afac5f90e)

---

## **Tech Stack** ⚙️
- **Rust** 🦀
- **Circom** 🔲
- **snarkjs** 🔑
- **Groth16** ⚖️
- **Ethereum** 🛠️
- **Remix IDE** 💻
- **WebAssembly** 🌐

---

## **Prerequisites** 📋

### **Install Required Tools** 💻

1. **Rust** 🦀:
   Rust is required to build the Circom compiler.

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source $HOME/.cargo/env
   ```

2. **Circom** 🔲:
   Circom is the circuit compiler used to define the logic of tax compliance.

   ```bash
   git clone https://github.com/iden3/circom.git
   cd circom
   cargo build --release
   export PATH=$PATH:$(pwd)/target/release
   ```

3. **snarkjs** 🔑:
   Install **snarkjs** to handle zk-SNARK operations such as proof generation, verification, and key management.

   Install globally:

   ```bash
   npm install -g snarkjs
   ```

   Or use **npx** for a local install:

   ```bash
   npm install snarkjs
   ```

---

## **Steps to Build ZKTax** 🔧

### **1. Write the ZKTax Circuit** 📝
Create the circuit that calculates the tax compliance logic. For example, create a file named `taxCompliance.circom` in the `circuits` directory.

Example:

```circom
pragma circom 2.0.0;

template TaxCompliance() {
    signal input income;
    signal input deductions;
    signal output taxPaid;

    taxPaid <== income - deductions;
}

component main = TaxCompliance();
```

---

### **2. Compile the Circuit** ⚡
Compile the circuit using **circom** to generate the necessary files for proof generation.

```bash
circom circuits/taxCompliance.circom --r1cs --wasm --sym
```

This generates:
- **taxCompliance.r1cs**: The constraint system.
- **taxCompliance.wasm**: WebAssembly file for the circuit.
- **taxCompliance.sym**: Symbol file for debugging.

---

### **3. Powers of Tau Ceremony** 🎉
The **Powers of Tau** ceremony is essential for creating the trusted setup required for zk-SNARKs.

#### **Initialize Ceremony** 🔄

```bash
snarkjs powersoftau new bn128 12 ceremony_0000.ptau -v
```

#### **Contribute Entropy** 🌍

Multiple contributors add randomness to the ceremony:

```bash
snarkjs powersoftau contribute ceremony_0000.ptau ceremony_0001.ptau --name="First Contributor" -v
snarkjs powersoftau contribute ceremony_0001.ptau ceremony_0002.ptau --name="Second Contributor" -v
```

#### **Prepare Phase 2** 🛠️

```bash
snarkjs powersoftau prepare phase2 ceremony_0002.ptau ceremony_final.ptau -v
```

#### **Verify Final File** ✅

```bash
snarkjs powersoftau verify ceremony_final.ptau -v
```

---

### **4. Setup Proving and Verification Keys** 🗝️

#### **Setup Proving Key** 🏗️

```bash
snarkjs groth16 setup circuits/taxCompliance.r1cs ceremony_final.ptau setup_0000.zkey
```

#### **Contribute to ZKey** 🛠️

```bash
snarkjs zkey contribute setup_0000.zkey setup_final.zkey --name="First Contributor" -v
```

#### **Verify ZKey** ✅

```bash
snarkjs zkey verify circuits/taxCompliance.r1cs ceremony_final.ptau setup_final.zkey -v
```

#### **Export Verification Key** 📜

```bash
snarkjs zkey export verificationkey setup_final.zkey verification_key.json
```

---

### **5. Generate Proof** 💡

#### **Create Input JSON** 📊
Create the `inputs.json` file with your tax data (income, deductions, etc.).

Example:

```json
{
  "income": "100000",
  "deductions": "20000"
}
```

#### **Generate Witness** 🧑‍💻

```bash
node circuits/taxCompliance_js/generate_witness.js circuits/taxCompliance_js/taxCompliance.wasm inputs.json witness.wtns
```

#### **Generate Proof** 🔏

```bash
snarkjs groth16 prove setup_final.zkey witness.wtns proof.json public.json
```

---

### **6. Verify Proof** ✅

#### **Verify Locally** 🌍

```bash
snarkjs groth16 verify verification_key.json public.json proof.json
```

#### **Export Solidity Verifier** 🧑‍💻

```bash
snarkjs zkey export solidityverifier setup_final.zkey verifier.sol
```

#### **Export Calldata** 📡

```bash
snarkjs zkey export soliditycalldata public.json proof.json
```

---

### **7. Deploy and Test On-Chain** 🛠️

#### **Deploy Verifier Contract** 📤

Deploy the **verifier.sol** Solidity contract on Ethereum (via **Remix IDE** or any Ethereum IDE).

#### **Submit Proof for Verification** ✅

Submit the exported **calldata** to the deployed smart contract for on-chain verification.

---

### **8. Optional Debugging** 🔍

#### **Debug Witness** 🔧

```bash
snarkjs wtns debug circuits/taxCompliance_js/taxCompliance.wasm witness.wtns circuits/taxCompliance.sym
```

#### **Export Witness for Analysis** 📈

```bash
snarkjs wtns export json witness.wtns witness.json
```

---

## **Conclusion** 🎉

By following these steps, you've successfully implemented a **zk-SNARK**-based tax compliance verification system. This ensures that tax data can be verified without revealing sensitive information. The system can be deployed on Ethereum and verified on-chain for a decentralized and secure tax system.

---

## **Helpful Links** 📚

- [Circom Documentation](https://docs.circom.io/)
- [snarkjs GitHub](https://github.com/iden3/snarkjs)
- [Powers of Tau Ceremony](https://github.com/ethereum-optimism/powers-of-tau)
- [Solidity Documentation](https://soliditylang.org/docs/)

---


![image](https://github.com/user-attachments/assets/9a42ed51-c4a6-4f23-bf1a-4ad4c863d2d6)

![image](https://github.com/user-attachments/assets/84d81e5f-c1ad-4a72-afe4-a07013880f6e)


## **License** 📜

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---


