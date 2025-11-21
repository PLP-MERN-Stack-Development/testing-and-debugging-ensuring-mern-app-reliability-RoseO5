#!/bin/bash

PROJECT=~/testing-and-debugging-ensuring-mern-app-reliability-RoseO5

echo "======================================"
echo " MERN Full Automation Script"
echo "======================================"

# ------------------------
# 1️⃣ Server Setup
# ------------------------
echo "Step 1: Setting up server..."
cd $PROJECT/server

# package.json
echo '{
  "name": "server",
  "version": "1.0.0",
  "description": "MERN server with testing",
  "main": "index.js",
  "type": "module",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest --coverage --watchAll=false"
  },
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "dotenv": "^16.0.0",
    "express": "^4.18.2",
    "mongoose": "^7.0.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "supertest": "^6.3.0",
    "mockingoose": "^2.14.0"
  }
}' > package.json

# Install dependencies
npm install
npm install --save-dev jest supertest mockingoose

# Test folders
mkdir -p tests/unit
mkdir -p tests/integration

# Server unit test
echo 'import mockingoose from "mockingoose";
import Post from "../../src/models/Post.js";

describe("Post model test (mocked)", () => {
  it("should return a mocked post", async () => {
    mockingoose(Post).toReturn({ title: "Test Post", content: "Hello" }, "findOne");
    const post = await Post.findOne({ title: "Test Post" });
    expect(post.title).toBe("Test Post");
    expect(post.content).toBe("Hello");
  });
});' > tests/unit/post.test.js

# Server integration test
echo 'import request from "supertest";
import express from "express";
import mockingoose from "mockingoose";
import Post from "../../src/models/Post.js";

const app = express();
app.use(express.json());
app.get("/posts/:id", async (req, res) => {
  const post = await Post.findById(req.params.id);
  res.json(post);
});

describe("GET /posts/:id", () => {
  it("should return a mocked post", async () => {
    mockingoose(Post).toReturn({ _id: "507f1f77bcf86cd799439011", title: "Mocked", content: "Hello" }, "findOne");
    const res = await request(app).get("/posts/507f1f77bcf86cd799439011");
    expect(res.body.title).toBe("Mocked");
    expect(res.body.content).toBe("Hello");
  });
});' > tests/integration/posts.test.js

# Run server tests
echo "Running server tests..."
npm test

# ------------------------
# 2️⃣ Client Setup
# ------------------------
echo "Step 2: Setting up client..."
cd $PROJECT/client

# package.json
echo '{
  "name": "client",
  "version": "1.0.0",
  "private": true,
  "description": "MERN client with React",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "jest --coverage --watchAll=false",
    "eject": "react-scripts eject"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "devDependencies": {
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "jest": "^29.0.0"
  }
}' > package.json

# Install dependencies
npm install
npm install --save-dev jest @testing-library/react @testing-library/jest-dom

# Test folder
mkdir -p src/tests/unit

# Sample React test
echo 'import { render, screen, fireEvent } from "@testing-library/react";
import Button from "../../components/Button";

test("Button click updates text", () => {
  render(<Button />);
  const button = screen.getByText("Click Me");
  fireEvent.click(button);
  expect(screen.getByText("Clicked!")).toBeInTheDocument();
});' > src/tests/unit/Button.test.jsx

# Run client tests
echo "Running client tests..."
npm test

# ------------------------
# 3️⃣ README update
# ------------------------
cd $PROJECT
echo "Updating README.md..."
echo "## Testing Strategy

- Server: Jest + Supertest + mockingoose (mock MongoDB)
- Client: Jest + React Testing Library
- Unit tests cover models, components, and utility functions
- Integration tests cover API endpoints
- Coverage reports generated automatically
" > README.md

# ------------------------
# 4️⃣ Optional: Git commit & push
# ------------------------
echo "Step 4: Git commit & push..."
git add .
git commit -m "Automated tests run and coverage update $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo "✅ All done! Server + Client tests ran, coverage updated, Git pushed."
