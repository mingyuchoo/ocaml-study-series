# Vanilla RNN Implementation in OCaml

A simple Recurrent Neural Network (RNN) implementation in OCaml for educational purposes.

## Features

- Pure OCaml implementation with no external dependencies
- Vanilla RNN with tanh activation
- Softmax output layer
- Backpropagation through time (BPTT)
- Cross-entropy loss
- Gradient descent optimization

## Structure

- `lib/vanilla_rnn_init.ml` - Main RNN implementation
- `bin/main.ml` - Executable entry point
- `test/test_vanilla_rnn_init.ml` - Test suite

## Building

```bash
dune build
```

## Running

```bash
dune exec vanilla_rnn_init
```

## Testing

```bash
dune test
```

## Example

The implementation includes a simple sequence learning task where the RNN learns to predict the next element in a sequence:
- Input: [1,0,0] → Output: [0,1,0]
- Input: [0,1,0] → Output: [0,0,1]
- Input: [0,0,1] → Output: [1,0,0]

After 200 epochs of training, the model achieves high accuracy (>98%) on this task.

## Implementation Details

The RNN includes:
- **Forward pass**: Computes hidden states and outputs for a sequence
- **Backward pass**: Computes gradients using BPTT
- **Parameter updates**: Simple gradient descent with configurable learning rate
- **Initialization**: Random initialization with small weights

### Key Functions

- `init_rnn` - Initialize RNN parameters
- `rnn_forward` - Forward pass through the network
- `compute_simple_gradients` - Compute gradients via BPTT
- `train_loop` - Training loop with loss monitoring
- `train_example` - Example training scenario
