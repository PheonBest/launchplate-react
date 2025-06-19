import path from 'node:path';
import { fileURLToPath } from 'node:url';

import type { Request, Response } from 'express';

import dotenv from 'dotenv';
import express from 'express';

// Get base path from env (fallback to '/')
const basePath = '/';
const port = 3060;

const app = express();

// Serve static files under the base path
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use(basePath, express.static(path.join(__dirname, '..', 'dist')));

// SPA fallback route
app.get(`${basePath}/{*splat}`, (req: Request, res: Response) => {
  res.sendFile(path.join(__dirname, '..', 'dist', 'index.html'));
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}${basePath}`);
});
