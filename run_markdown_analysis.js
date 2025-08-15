const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('=== Markdownlint Analysis for docs/ directory ===\n');

try {
  // Change to the project directory
  process.chdir('/Users/daelegbe/Documents/Projects/claude-config');
  
  // Get all markdown files in docs directory
  const docsDir = './docs';
  const files = fs.readdirSync(docsDir, { recursive: true })
    .filter(file => file.endsWith('.md'))
    .map(file => path.join(docsDir, file));
    
  console.log(`Found ${files.length} markdown files to analyze:\n`);
  files.forEach(file => console.log(`  - ${file}`));
  console.log('\n');
  
  // Run markdownlint-cli2 on docs directory
  const command = `npx markdownlint-cli2 ${files.join(' ')} --config .markdownlint-cli2.jsonc`;
  console.log(`Running command: ${command}\n`);
  
  const output = execSync(command, { 
    encoding: 'utf8',
    stdio: ['pipe', 'pipe', 'pipe']
  });
  
  if (output.trim()) {
    console.log('Markdownlint Output:');
    console.log(output);
  } else {
    console.log('✅ No linting issues found! All markdown files pass validation.');
  }
  
} catch (error) {
  if (error.stdout) {
    console.log('Markdownlint found issues:\n');
    console.log(error.stdout);
  }
  
  if (error.stderr) {
    console.log('Errors:\n');
    console.log(error.stderr);
  }
  
  console.log(`\nExit code: ${error.status || 'unknown'}`);
}