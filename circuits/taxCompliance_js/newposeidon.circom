pragma circom 2.0.0;

template PoseidonHash(t, useSparse) {
    signal input inputs[t]; 
    signal output out;      

    // Parameters
    var p = 21888242871839275222246405745257275088548364400416034343698204186575808495617; // Prime field
    var rounds = 8;  
    var alpha = 5;   

    // Generate Dense Matrix Dynamically
    function generateDenseMatrix(t) -> matrix {
        matrix = [];
        for (var i = 0; i < t; i++) {
            matrix.push([]);
            for (var j = 0; j < t; j++) {
                matrix[i].push((i + j + 1) % p); 
            }
        }
    }
    var denseMatrix = generateDenseMatrix(t);

    // Dense Matrix Example (for t=4):
    // denseMatrix = [
    //   [1, 2, 3, 4],
    //   [2, 3, 4, 5],
    //   [3, 4, 5, 6],
    //   [4, 5, 6, 7]
    // ]
    
    // Generate Sparse Matrix Dynamically
    function generateSparseMatrix(t) -> matrix {
        matrix = [];
        for (var i = 0; i < t; i++) {
            matrix.push([]);
            for (var j = 0; j < t; j++) {
                if ((i + j) % 2 == 0) {
                    matrix[i].push(1); 
                } else {
                    matrix[i].push(0); 
                }
            }
        }
    }
    var sparseMatrix = generateSparseMatrix(t);

    // Sparse Matrix Example (for t=4):
    // sparseMatrix = [
    //   [1, 0, 1, 0],
    //   [0, 1, 0, 1],
    //   [1, 0, 1, 0],
    //   [0, 1, 0, 1]
    // ]

    // Generate Round Constants
    function generateRoundConstants(rounds) -> constants {
        constants = [];
        for (var i = 0; i < rounds; i++) {
            // Example round constant: use a fixed sequence or generate dynamically based on a cryptographic design
            constants.push(i + 1); 
        }
        return constants;
    }
    var roundConstants = generateRoundConstants(rounds);

    // Initialize the state with inputs
    signal state[t];
    for (var i = 0; i < t; i++) {
        state[i] <== inputs[i];
    }

    // Main Poseidon Rounds
    var switchToSparseRound = rounds * 0.2; 
    
    for (var r = 0; r < rounds; r++) {

        
        // Add Round Constant
        for (var i = 0; i < t; i++) {
            newState[i] <== newState[i] + roundConstants[r] % p; 
        }
        // S-Box: Non-linear transformation
        for (var i = 0; i < t; i++) {
            state[i] <== state[i] ** alpha % p;
        }

        // Matrix Multiplication
        var newState = [];
        
        if (r >= switchToSparseRound) {
            // Use Sparse Matrix after 20% of the rounds (1st round in a 5-round case)
            for (var i = 0; i < t; i++) {
                var sum = 0;
                for (var j = 0; j < t; j++) {
                    if (sparseMatrix[i][j] != 0) {
                        sum += state[j] * sparseMatrix[i][j];
                    }
                }
                newState.push(sum % p); // Modulo operation
            }
        } else {
            // Use Dense Matrix during the initial rounds (before the 20% mark)
            for (var i = 0; i < t; i++) {
                var sum = 0;
                for (var j = 0; j < t; j++) {
                    sum += state[j] * denseMatrix[i][j];
                }
                newState.push(sum % p); 
            }
        }


        // Update the state
        for (var i = 0; i < t; i++) {
            state[i] <== newState[i];
        }
    }

    // Output the first element of the final state as the hash
    out <== state[0];
}

// Usage: Provide the array of inputs and specify whether to use a sparse or dense matrix
component main = PoseidonHash(4, 1); 
