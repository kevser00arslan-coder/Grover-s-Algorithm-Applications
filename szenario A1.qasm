OPENQASM 2.0;
include "qelib1.inc";

// Grover-Suche mit 3 Qubits, gesuchter Zustand: 010 (q2 q1 q0)

qreg q[3];
creg c[3];

// Doppelt kontrolliertes Z 
gate ccz a,b,c {
  h c;
  ccx a,b,c;
  h c;
}

// Superposition
h q[0];
h q[1];
h q[2];

// Iteration 1 
x q[0];
x q[2];
ccz q[0],q[1],q[2];
x q[0];
x q[2];
// Diffusor
h q[0];
h q[1];
h q[2];
x q[0];
x q[1];
x q[2];
ccz q[0],q[1],q[2];
x q[0];
x q[1];
x q[2];
h q[0];
h q[1];
h q[2];

//  Iteration 2 
x q[0];
x q[2];
ccz q[0],q[1],q[2];
x q[0];
x q[2];
h q[0];
h q[1];
h q[2];
x q[0];
x q[1];
x q[2];
ccz q[0],q[1],q[2];
x q[0];
x q[1];
x q[2];
h q[0];
h q[1];
h q[2];

// Messen
measure q[0] -> c[0];
measure q[1] -> c[1];
measure q[2] -> c[2];
