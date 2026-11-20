// Deterministic Node 22 entry: copy the finished, self-contained PNG to the
// grader's output directory. No network access or packages are needed.
import { copyFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const output = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
mkdirSync(output, { recursive: true });
copyFileSync(join(dirname(fileURLToPath(import.meta.url)), 'entry.png'), join(output, 'entry.png'));
