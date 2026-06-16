OPENQASM 2.0;
include "qelib1.inc";

// Grover-Suche mit 4 Qubits, gesuchter Zustand: 0101 (q3 q2 q1 q0)


qreg q[4];
creg c[4];

// Drei-fach kontrolliertes Z 
gate cccz a,b,c,d {
  u1(pi/8) a;
  u1(pi/8) b;
  u1(pi/8) c;
  u1(pi/8) d;
  cx a,b;
  u1(-pi/8) b;
  cx a,b;
  cx b,c;
  u1(-pi/8) c;
  cx a,c;
  u1(pi/8) c;
  cx b,c;
  u1(-pi/8) c;
  cx a,c;
  cx c,d;
  u1(-pi/8) d;
  cx b,d;
  u1(pi/8) d;
  cx c,d;
  u1(-pi/8) d;
  cx a,d;
  u1(pi/8) d;
  cx c,d;
  u1(-pi/8) d;
  cx b,d;
  u1(pi/8) d;
  cx c,d;
  u1(-pi/8) d;
  cx a,d;
}

// Superposition 
h q[0];
h q[1];
h q[2];
h q[3];

// Iteration 1 n
x q[1];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[1];
x q[3];
// Diffusor
h q[0];
h q[1];
h q[2];
h q[3];
x q[0];
x q[1];
x q[2];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[0];
x q[1];
x q[2];
x q[3];
h q[0];
h q[1];
h q[2];
h q[3];

// Iteration 2
x q[1];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[1];
x q[3];
h q[0];
h q[1];
h q[2];
h q[3];
x q[0];
x q[1];
x q[2];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[0];
x q[1];
x q[2];
x q[3];
h q[0];
h q[1];
h q[2];
h q[3];

// Iteration 3
x q[1];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[1];
x q[3];
h q[0];
h q[1];
h q[2];
h q[3];
x q[0];
x q[1];
x q[2];
x q[3];
cccz q[0],q[1],q[2],q[3];
x q[0];
x q[1];
x q[2];
x q[3];
h q[0];
h q[1];
h q[2];
h q[3];

// Messen
measure q[0] -> c[0];
measure q[1] -> c[1];
measure q[2] -> c[2];
measure q[3] -> c[3];
