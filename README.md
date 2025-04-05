# Algorithms from Scratch

This repository contains implementations of fundamental algorithms and data structures built from scratch in various programming languages (C, Python, Haskell). The implementations are designed for educational purposes to demonstrate how these algorithms work at their core.

## Table of Contents
- [Implemented Algorithms](#implemented-algorithms)
- [Data Structures](#data-structures)
- [Language Breakdown](#language-breakdown)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Implemented Algorithms

### Sorting Algorithms
1. **Radix Sort** (C)
   - Implementation using Counting Sort as the underlying stable sort
   - Handles 10-digit integers
   - Time complexity: O(d(n+k)) where d is digit count

2. **Quicksort on Linked Lists** (Python)
   - Lomuto partitioning scheme
   - In-place sorting of singly linked lists
   - Average time complexity: O(n log n)

### Graph Algorithms
1. **A* Pathfinding** (Haskell)
   - Optimal pathfinding algorithm for grid-based maps
   - Uses Manhattan distance heuristic
   - Includes terrain passability checks

2. **Propositional Satisfiability Checker** (Python)
   - Determines if a 2-SAT formula has a satisfying assignment
   - Uses implication graph and cycle detection
   - Handles formulas with pairs of literals

### Other Algorithms
1. **Robot Tournament Simulation** (Python)
   - Simulates robot battles until last survivor
   - Uses max-heap-like approach to select combatants
   - Returns remaining hit points of last robot

## Data Structures

1. **Linked List** (Python)
   - Singly linked list implementation
   - Supports basic operations (add, get, set values)
   - Used as base for Quicksort implementation

2. **Binary Search Tree** (Python)
   - Height-balanced BST from linked list
   - In-order traversal implementation
   - Conversion algorithm maintains balance

3. **Game Map Grid** (Haskell)
   - 2D grid representation with various terrain types
   - Pathfinding and navigation capabilities
   - Door state management system

## Language Breakdown

### C Implementations
- `q3-radixsort.c`: Radix sort for large integers
- Focus on memory management and low-level operations

### Python Implementations
- `q4-prop-sat.py`: Propositional satisfiability checker
- `q5b-linked-list-quicksort.py`: Linked list Quicksort
- `q5c-linked-list-to-balanced-tree.py`: BST conversion
- `q6b-robot-tournament.py`: Robot tournament simulation

### Haskell Implementation
- `cwsub.hs`: Contains A* pathfinding algorithm
- Functional programming approach to grid navigation
- Includes comprehensive game map system

## Getting Started

### Prerequisites
- Python 3.x
- GHC (for Haskell files)
- GCC (for C files)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/algorithms-from-scratch.git
   cd algorithms-from-scratch

2. Run individual implementations:
   ```bash
   # Python implementations
   python q4-prop-sat.py
   python q5b-linked-list-quicksort.py
   python q5c-linked-list-to-balanced-tree.py
   python q6b-robot-tournament.py
   
   # C implementation
   gcc q3-radixsort.c -o radixsort
   ./radixsort
   
   # Haskell implementation
   ghc cwsub.hs -o pathfinder
   ./pathfinder

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Fork the repository
2. Create a new branch for your feature (`git checkout -b feature/your-feature`)
3. Commit your changes with descriptive messages (`git commit -am 'Add new sorting algorithm'`)
4. Push to your branch (`git push origin feature/your-feature`)
5. Open a pull request with a clear description of your changes


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


**Acknowledgments**
- CLRS Introduction to Algorithms
- University coursework that inspired these implementations
- Open source algorithm visualization tools
