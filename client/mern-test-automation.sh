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

echo "Step 2: Verifying package.json files..."
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
npm install --save-dev jest supertest mongodb-memory-server

echo "Configuring server test script..."
npm set-script test "jest --coverage"

echo "Step 4: Installing CLIENT dependencies..."
cd $PROJECT/client

npm install react react-dom react-scripts
npm install --save-dev jest @testing-library/react @testing-library/jest-dom

echo "Configuring client test script..."
npm set-script test "jest --coverage --watchAll=false"

echo "Step 5: Running SERVER tests..."
cd $PROJECT/server
SERVER_JSON=$(npx jest --coverage --json --outputFile=server-test.json)
SERVER_COVERAGE=$(jq '.coverageMap["Total"].statements.pct' server-test.json 2>/dev/null)

echo "Server coverage: $SERVER_COVERAGE%"

if (( $(echo "$SERVER_COVERAGE >= 70" | bc -l) )); then
  echo "✅ Server meets 70% coverage"
else
  echo "⚠️ Server below 70%"
fi

echo "Step 6: Running CLIENT tests..."
cd $PROJECT/client
CLIENT_JSON=$(npx jest --coverage --json --outputFile=client-test.json)
CLIENT_COVERAGE=$(jq '.coverageMap["Total"].statements.pct' client-test.json 2>/dev/null)

echo "Client coverage: $CLIENT_COVERAGE%"

if (( $(echo "$CLIENT_COVERAGE >= 70" | bc -l) )); then
  echo "✅ Client meets 70% coverage"
else
  echo "⚠️ Client below 70%"
fi

echo "Step 7: Updating README.md..."

cd $PROJECT

cat <<EOF >> README.md

---

## 🧪 Automated Test Coverage Report

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
echo " Coverage added to README.md"
echo "======================================"
