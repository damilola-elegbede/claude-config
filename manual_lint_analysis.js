const fs = require('fs');
const path = require('path');

console.log('=== Manual Markdownlint Analysis ===\n');

// Common markdownlint violations based on the configuration
const rules = {
  MD001: 'Heading levels should only increment by one level at a time',
  MD009: 'Trailing spaces (more than 2)',
  MD013: 'Line length exceeds 120 characters',
  MD022: 'Headings should be surrounded by blank lines',
  MD024: 'Multiple headings with the same content',
  MD025: 'Multiple top level headings in document',
  MD031: 'Fenced code blocks should be surrounded by blank lines',
  MD032: 'Lists should be surrounded by blank lines',
  MD040: 'Fenced code blocks should have a language specified',
  MD047: 'Files should end with a single newline character'
};

function analyzeFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');
  const issues = [];
  
  let prevHeadingLevel = 0;
  let hasTopLevelHeading = false;
  let topLevelHeadingCount = 0;
  const headings = [];
  
  lines.forEach((line, index) => {
    const lineNumber = index + 1;
    
    // MD013: Line length
    if (line.length > 120) {
      issues.push({
        rule: 'MD013',
        line: lineNumber,
        description: `Line too long (${line.length}/120 characters)`,
        content: line.substring(0, 80) + '...'
      });
    }
    
    // MD009: Trailing spaces (more than 2)
    const trailingSpaces = line.match(/\s+$/);
    if (trailingSpaces && trailingSpaces[0].length > 2) {
      issues.push({
        rule: 'MD009',
        line: lineNumber,
        description: `${trailingSpaces[0].length} trailing spaces`,
        content: line
      });
    }
    
    // Heading analysis
    const headingMatch = line.match(/^(#+)\s+(.+)/);
    if (headingMatch) {
      const level = headingMatch[1].length;
      const headingText = headingMatch[2];
      
      // MD001: Heading levels should only increment by one
      if (prevHeadingLevel > 0 && level > prevHeadingLevel + 1) {
        issues.push({
          rule: 'MD001',
          line: lineNumber,
          description: `Heading level ${level} should follow ${prevHeadingLevel}`,
          content: line
        });
      }
      
      // MD025: Multiple top level headings
      if (level === 1) {
        topLevelHeadingCount++;
        if (topLevelHeadingCount > 1) {
          issues.push({
            rule: 'MD025',
            line: lineNumber,
            description: 'Multiple top level headings found',
            content: line
          });
        }
      }
      
      // MD024: Duplicate headings
      if (headings.includes(headingText)) {
        issues.push({
          rule: 'MD024',
          line: lineNumber,
          description: `Duplicate heading: "${headingText}"`,
          content: line
        });
      }
      
      headings.push(headingText);
      prevHeadingLevel = level;
      hasTopLevelHeading = hasTopLevelHeading || (level === 1);
      
      // MD022: Headings should be surrounded by blank lines
      if (index > 0 && lines[index - 1].trim() !== '') {
        issues.push({
          rule: 'MD022',
          line: lineNumber,
          description: 'Heading should have blank line before it',
          content: line
        });
      }
      if (index < lines.length - 1 && lines[index + 1].trim() !== '') {
        issues.push({
          rule: 'MD022',
          line: lineNumber,
          description: 'Heading should have blank line after it',
          content: line
        });
      }
    }
    
    // MD040: Fenced code blocks should have language
    if (line.startsWith('```') && line.trim() === '```') {
      issues.push({
        rule: 'MD040',
        line: lineNumber,
        description: 'Code block should specify language',
        content: line
      });
    }
    
    // MD031: Fenced code blocks should be surrounded by blank lines
    if (line.startsWith('```')) {
      if (index > 0 && lines[index - 1].trim() !== '') {
        issues.push({
          rule: 'MD031',
          line: lineNumber,
          description: 'Code block should have blank line before it',
          content: line
        });
      }
    }
    
    if (line === '```') {
      if (index < lines.length - 1 && lines[index + 1].trim() !== '') {
        issues.push({
          rule: 'MD031',
          line: lineNumber,
          description: 'Code block should have blank line after it',
          content: line
        });
      }
    }
  });
  
  // MD047: Files should end with single newline
  if (!content.endsWith('\n')) {
    issues.push({
      rule: 'MD047',
      line: lines.length,
      description: 'File should end with a single newline',
      content: ''
    });
  } else if (content.endsWith('\n\n')) {
    issues.push({
      rule: 'MD047',
      line: lines.length,
      description: 'File should end with a single newline (found multiple)',
      content: ''
    });
  }
  
  return issues;
}

// Get all markdown files in docs directory
function getAllMarkdownFiles(dir) {
  const files = [];
  
  function walkDir(currentPath) {
    const items = fs.readdirSync(currentPath);
    
    for (const item of items) {
      const fullPath = path.join(currentPath, item);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        walkDir(fullPath);
      } else if (item.endsWith('.md')) {
        files.push(fullPath);
      }
    }
  }
  
  walkDir(dir);
  return files;
}

const docsPath = '/Users/daelegbe/Documents/Projects/claude-config/docs';
const files = getAllMarkdownFiles(docsPath);

console.log(`Found ${files.length} markdown files to analyze:\n`);

let totalIssues = 0;
const fileResults = {};

files.forEach(file => {
  const relativePath = path.relative(docsPath, file);
  console.log(`Analyzing: docs/${relativePath}`);
  
  try {
    const issues = analyzeFile(file);
    fileResults[relativePath] = issues;
    totalIssues += issues.length;
    
    if (issues.length > 0) {
      console.log(`  ❌ ${issues.length} issues found`);
    } else {
      console.log(`  ✅ No issues found`);
    }
  } catch (error) {
    console.log(`  ⚠️  Error analyzing file: ${error.message}`);
  }
});

console.log(`\n=== DETAILED RESULTS ===\n`);

if (totalIssues === 0) {
  console.log('✅ No linting issues found! All markdown files pass validation.');
} else {
  console.log(`Found ${totalIssues} total issues across ${Object.keys(fileResults).filter(f => fileResults[f].length > 0).length} files:\n`);
  
  Object.entries(fileResults).forEach(([file, issues]) => {
    if (issues.length > 0) {
      console.log(`📄 docs/${file} (${issues.length} issues):`);
      issues.forEach(issue => {
        console.log(`   ${issue.rule}:${issue.line} ${issue.description}`);
        if (issue.content) {
          console.log(`     → ${issue.content}`);
        }
      });
      console.log('');
    }
  });
}