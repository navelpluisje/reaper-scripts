import fs from 'fs';
import chalk from 'chalk';
import path from 'path';

export const copyFile = (fromDir, toDir, fileName) => {
  console.log(chalk.green(`${new Date().toISOString()}: `) + chalk.yellow(fileName) + chalk.green(` changed.`));

  if (!fs.existsSync(toDir)) {
    fs.mkdirSync(toDir, { recursive: true })
  }
  fs.copyFile(
    path.join(fromDir, fileName),
    path.join(toDir, fileName),
    0,
    (err) => {
      if (err) {
        console.log(chalk.red('error'), err);
      } else {
        console.log(`* ${chalk.yellow(fileName)} ${chalk.green('Copied successfully')}`);
      }
    }
  );
}
