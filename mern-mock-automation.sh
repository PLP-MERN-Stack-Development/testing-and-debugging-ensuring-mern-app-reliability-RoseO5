#!/bin/bash

PROJECT=~/testing-and-debugging-ensuring-mern-app-reliability-RoseO5

echo "======================================"
echo "  MERN TESTING & COVERAGE AUTOMATION"
echo "======================================"

cd $PROJECT || exit

echo "Step 1: Cleaning project folders..."
rm -rf client/node_modules server/node_modules
rm -rf client/build client/.next
find . -type f -name "*.log" -delete

echo "Step 2: Ensuring package.json files exist..."

if [ ! -f server/package.json ]; then
  echo "Creating server package.json..."
  cd server
  npm init -y
fi

if [ ! -f client/package.json ]; then
  echo "Creating client package.json..."
  cd ../client
  npm init -y
fi

echo "Step 3: Installing SERVER dependencies..."
cd $PROJECT/server
npm install express mongoose dotenv
npm install --save-dev jest supertest mockingoose

# Ensure test script in server
npm set-script test "jest --coverage --watchAll=false"

echo "Step 4: Installing CLIENT dependencies..."
cd $PROJECT/client
npm install react react-dom react-scripts
npm install --save-dev jest @testing-library/react @testing-library/jest-dom

# Ensure test script in client
npm set-script test "jest --coverage --watchAll=false"

echo "Step 5: Running SERVER tests (mocked DB)..."
cd $PROJECT/server
SERVER_COVERAGE=$(npx jest --coverage --json --outputFile=server-test.json | grep '"statements"' | awk -F: '{print $2}' | tr -d ', ')

echo "Server coverage: $SERVER_COVERAGE%"

echo "Step 6: Running CLIENT tests..."
cd $PROJECT/client
CLIENT_COVERAGE=$(npx jest --coverage --json --outputFile=client-test.json | grep '"statements"' | awk -F: '{print $2}' | tr -d ', ')

echo "Client coverage: $CLIENT_COVERAGE%"

echo "Step 7: Updating README.md..."
cd $PROJECT

cat <<EOF >> README.md

---

## 🧪 Automated Test Coverage Report (Mock MongoDB)

### Server Coverage
- Statements: $SERVER_COVERAGE%

### Client Coverage
- Statements: $CLIENT_COVERAGE%

_This report was generated automatically by the MERN Testing Automation Script._

EOF

echo "Step 8: Final Project Structure:"
tree -L 2

echo "======================================"
echo " DONE! Your MERN testing environment is ready."
echo " Server uses mock MongoDB (mockingoose) for tests."
echo " Coverage added to README.md"
echo "======================================"
