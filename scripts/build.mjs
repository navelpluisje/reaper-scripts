#!/usr/bin/env node

import { config as envConfig } from 'dotenv';
import fs from 'fs';
import path from 'path';
import chalk from 'chalk';
import { subtractArgs, copyFile } from './utils/index.mjs';
import fse from 'fs-extra';
import { zip } from 'zip-a-folder';

const _ = envConfig();
const args = subtractArgs()

if (!process.env.REAPER_PATH) {
  throw new Error('REAPER_PATH has not been set');
}

if (args._.includes('help')) {
  console.log('HELPPPPP');
  process.exit(0);
}

console.clear()

if (args._.includes('watch')) {
  console.log(chalk.blue('================================================================================'));
  console.log(chalk.blue('Watching for changes'));
  console.log(chalk.blue('================================================================================\n'));
  fs.watch(
    path.join(process.cwd(), 'src', 'Scripts'),
    {
      recursive: true,
    },
    (x, file) => {
      copyFile(path.join(process.cwd(), 'src', 'Scripts'), path.join(process.env.REAPER_PATH, 'Scripts', 'Navelpluisje'), file);
    },
  );
}

if (args._.includes('build')) {
  console.log(chalk.blue('================================================================================'));
  console.log(chalk.blue('Build for Release'));
  console.log(chalk.blue('================================================================================\n'));

  fse.copy(path.join(process.cwd(), 'src'), path.join(process.cwd(), 'out', 'reasonus-faderport'), async (err) => {

    await zip(path.join(process.cwd(), 'out', 'reasonus-faderport'), path.join(process.cwd(), 'out', 'reasonus-faderport.zip'));
  });


  console.log('GO ONNNNNN')
}
