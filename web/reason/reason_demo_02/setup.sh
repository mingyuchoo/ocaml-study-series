#!/bin/bash

echo "=== Address Book Setup ==="
echo ""
echo "Installing dependencies..."
opam install . --deps-only --yes

echo ""
echo "Building project..."
dune build

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To run the application:"
echo "  make run"
echo ""
echo "Or manually:"
echo "  dune exec reason_demo_02"
echo ""
echo "The server will start on http://localhost:8080"
