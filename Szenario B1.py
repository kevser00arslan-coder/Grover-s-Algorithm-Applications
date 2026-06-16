import numpy as np
import matplotlib.pyplot as plt
from qiskit import QuantumCircuit, transpile
from qiskit_aer import AerSimulator

n = 8                                          # Anzahl der Qubits
ziele = ["00010001", "01010101", "10101010"]  # drei gesuchte Loesungen
shots = 4096                                   # Anzahl der Messungen

def markiere(qc, ziel):
    for i in range(n):
        if ziel[n - 1 - i] == "0":
            qc.x(i)
    # multi-controlled Z: flips the phase of the |11..1> state
    qc.h(n - 1)
    qc.mcx(list(range(n - 1)), n - 1)
    qc.h(n - 1)
    for i in range(n):
        if ziel[n - 1 - i] == "0":
            qc.x(i)

def oracle(qc):
    for ziel in ziele:
        markiere(qc, ziel)

def diffusion(qc):
    qc.h(range(n))
    qc.x(range(n))
    qc.h(n - 1)
    qc.mcx(list(range(n - 1)), n - 1)
    qc.h(n - 1)
    qc.x(range(n))
    qc.h(range(n))

qc = QuantumCircuit(n)
qc.h(range(n))

M = len(ziele)
iterationen = int(round(np.pi / 4 * np.sqrt(2 ** n / M) - 0.5))
for _ in range(iterationen):
    oracle(qc)
    diffusion(qc)

qc.measure_all()

sim = AerSimulator()
schaltung = transpile(qc, sim)
ergebnis = sim.run(schaltung, shots=shots).result()
counts = ergebnis.get_counts()

print("Anzahl der Iterationen:", iterationen)
for z in ziele:
    print(z, "->", counts.get(z, 0))

alle_zustaende = [format(i, "08b") for i in range(2 ** n)]
haeufigkeiten = [counts.get(z, 0) for z in alle_zustaende]

plt.figure(figsize=(16, 5))
balken = plt.bar(range(2 ** n), haeufigkeiten, width=1.0, color="#3B6FB6")
sichtbar = [i for i, h in enumerate(haeufigkeiten) if h > 0]
plt.xticks(sichtbar, [format(i, "08b") for i in sichtbar], rotation=70)

# Haeufigkeit schreiben
for i in sichtbar:
    plt.text(i, haeufigkeiten[i], str(haeufigkeiten[i]),
             ha="center", va="bottom", fontsize=8)

plt.title("Grover-Algorithmus, 3 Ziele (" + str(shots) + " shots)")
plt.xlabel("Measurement outcome")
plt.ylabel("Frequency")
plt.xlim(-1, 2 ** n)
plt.margins(y=0.12)
plt.tight_layout()
plt.show()