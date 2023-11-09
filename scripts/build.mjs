#!/usr/bin/env node

import { config as envConfig } from 'dotenv';
import fs from 'fs';
import path from 'path';
import chalk from 'chalk';
import { subtractArgs, copyFile } from './utils/index.mjs';
import fse from 'fs-extra';
import { zip } from 'zip-a-folder';
import { bundle } from 'luabundle';

const _ = envConfig();
const args = subtractArgs()

if (!process.env.REAPER_PATH) {
  throw new Error('REAPER_PATH has not been set');
}

if (args._.includes('help')) {
  console.log('HELPPPPP');
  process.exit(0);
}

if (!fs.existsSync(path.join(process.cwd(), 'dist'))) {
  fs.mkdirSync(path.join(process.cwd(), 'dist'), {recursive: true});
}


console.clear()

if (args._.includes('watch')) {
  console.log(chalk.blue('================================================================================'));
  console.log(chalk.blue('Watching for changes'));
  console.log(chalk.blue('================================================================================\n'));
  const folder = path.join(process.cwd(), 'src', 'Scripts');
  const distFolder = path.join(process.cwd(), 'dist');
  fs.watch(
    folder,
    {
      recursive: true,
    },
    (event, file) => {
      if (event === 'change') {
        const content = bundle(path.join(folder, file), {
          paths: ['./src/snippets/?.lua'],
        });
        fs.writeFileSync(path.join(distFolder, file), content, {flag: 'w+'});
      }
    },
  );
  fs.watch(
    distFolder,
    {
      recursive: true,
    },
    (event, file) => {
        copyFile(distFolder, path.join(process.env.REAPER_PATH, 'Scripts', 'Navelpluisje'), file);
    },
  );
}

if (args._.includes('build')) {
  console.log(chalk.blue('================================================================================'));
  console.log(chalk.blue('Build for Release'));
  console.log(chalk.blue('================================================================================\n'));

  const folder = path.join(process.cwd(), 'src', 'Scripts');
  const distFolder = path.join(process.cwd(), 'dist');
  const zipFolder = path.join(process.cwd(), 'out');
  const files = fs.readdirSync(folder);

  for (const file in files) {
    const content = bundle(path.join(folder, files[file]), {
      paths: ['./src/snippets/?.lua'],
    });
    fs.writeFileSync(path.join(distFolder, files[file]), content, {flag: 'w+'});
  }

  if (!fs.existsSync(path.join(process.cwd(), 'out'))) {
    fs.mkdirSync(path.join(process.cwd(), 'out'), {recursive: true});
  }

  zip(path.join(distFolder), path.join(zipFolder, 'navelpluisje-reaper-scripts.zip'));

  console.log('GO ONNNNNN')
}
