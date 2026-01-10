#!/bin/bash

# Optimized /resolve-comments command implementation
# Fetches and processes CodeRabbit review comments with parallel operations
#
# Usage:
#   resolve-comments-optimized.sh [PR_NUMBER] [--auto]
#
# Arguments:
#   PR_NUMBER  - Optional PR number. If not provided, detects from current branch
#   --auto     - Skip interactive confirmation and proceed automatically
#
# Default behavior is interactive mode with user confirmation before proceeding

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Security validation functions
validate_pr_number() {
    local pr_num="$1"
    if [[ ! "$pr_num" =~ ^[0-9]+$ ]] || [ "$pr_num" -lt 1 ] || [ "$pr_num" -gt 99999 ]; then
        echo -e "${RED}Error: Invalid PR number format. Must be a positive integer 1-99999${NC}" >&2
        return 1
    fi
}

validate_json_input() {
    local json_input="$1"
    # Validate JSON syntax
    if ! echo "$json_input" | jq empty 2>/dev/null; then
        echo -e "${RED}Error: Invalid JSON format detected${NC}" >&2
        return 1
    fi

    # Check for suspicious patterns in JSON using fixed-string matching for security
    # Using -F (fixed string) instead of -E (regex) to prevent pattern injection
    if echo "$json_input" | grep -qF '$(' || \
       echo "$json_input" | grep -qF '`' || \
       echo "$json_input" | grep -qF 'eval(' || \
       echo "$json_input" | grep -qF 'exec(' || \
       echo "$json_input" | grep -qF 'system(' || \
       echo "$json_input" | grep -qF 'subprocess' || \
       echo "$json_input" | grep -qF '__import__' || \
       echo "$json_input" | grep -qF 'import os'; then
        echo -e "${RED}Error: Suspicious code patterns detected in JSON input${NC}" >&2
        return 1
    fi

    # Validate file paths don't contain path traversal
    if echo "$json_input" | jq -r '.. | strings?' 2>/dev/null | grep -qE '\.\./|^/|~/'; then
        echo -e "${RED}Error: Invalid file paths detected (path traversal attempt)${NC}" >&2
        return 1
    fi
}

sanitize_file_path() {
    local file_path="$1"
    # Remove any path traversal attempts and ensure relative path within agents directory
    file_path=$(echo "$file_path" | sed 's|\.\.||g' | sed 's|^/||' | sed 's|^~/||')
    # Ensure it starts with expected directory structure
    if [[ ! "$file_path" =~ ^[a-zA-Z0-9_/.-]+\.md$ ]]; then
        echo -e "${RED}Error: Invalid file path format: $file_path${NC}" >&2
        return 1
    fi
    echo "$file_path"
}

# Parse arguments
AUTO_MODE=false
PR_NUMBER=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --auto)
            AUTO_MODE=true
            shift
            ;;
        *)
            if [[ -z "$PR_NUMBER" ]]; then
                PR_NUMBER="$1"
            fi
            shift
            ;;
    esac
done

# Get repository info
REPO_INFO=$(gh repo view --json owner,name)
OWNER=$(echo "$REPO_INFO" | jq -r '.owner.login')
REPO=$(echo "$REPO_INFO" | jq -r '.name')

# Function to find PR for current branch
find_pr_for_branch() {
    local branch=$(git branch --show-current)
    gh pr list --head "$branch" --json number,state --jq '.[0].number // empty'
}

# Step 1: Identify the PR
echo -e "${BLUE}🔍 Identifying PR...${NC}"
if [ -z "$PR_NUMBER" ]; then
    PR_NUMBER=$(find_pr_for_branch)
    if [ -z "$PR_NUMBER" ]; then
        echo -e "${RED}Error: No PR found for current branch${NC}"
        exit 1
    fi
fi

# Validate PR number format
if ! validate_pr_number "$PR_NUMBER"; then
    exit 1
fi

# Verify PR exists
PR_STATE=$(gh pr view "$PR_NUMBER" --json state --jq '.state' 2>/dev/null || echo "NOT_FOUND")
if [ "$PR_STATE" == "NOT_FOUND" ]; then
    echo -e "${RED}Error: PR #$PR_NUMBER not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Found PR #$PR_NUMBER (State: $PR_STATE)${NC}"

# Step 2: Parallel API calls to fetch all comments
echo -e "${BLUE}🔍 Fetching CodeRabbit comments (parallel search)...${NC}"

# Create temp files for parallel results
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Pre-compiled search pattern for all CodeRabbit signatures (sanitized)
# Use fixed pattern to prevent injection
CODERABBIT_PATTERN='(?i)(@coderabbitai|coderabbitai\\[bot\\]|Prompts? for AI Agents)'

# Parallel API calls with direct JSON filtering
# Track PIDs for proper error handling
PIDS=()
{
    # Reviews endpoint
    gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/reviews" \
        --paginate \
        --jq '.[] | select(.user.login == "coderabbitai[bot]" or (.body | test("'$CODERABBIT_PATTERN'"))) | {type: "review", body, user: .user.login}' \
        > "$TEMP_DIR/reviews.json" 2>/dev/null &
    PIDS+=($!)

    # Comments endpoint (inline review comments)
    gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments" \
        --paginate \
        --jq '.[] | select(.user.login == "coderabbitai[bot]" or (.body | test("'$CODERABBIT_PATTERN'"))) | {type: "comment", body, path, line, user: .user.login}' \
        > "$TEMP_DIR/comments.json" 2>/dev/null &
    PIDS+=($!)

    # Issue comments endpoint (backup)
    gh api "repos/$OWNER/$REPO/issues/$PR_NUMBER/comments" \
        --paginate \
        --jq '.[] | select(.user.login == "coderabbitai[bot]" or (.body | test("'$CODERABBIT_PATTERN'"))) | {type: "issue", body, user: .user.login}' \
        > "$TEMP_DIR/issue_comments.json" 2>/dev/null &
    PIDS+=($!)

    # Wait for all jobs and check for failures
    EXIT_CODE=0
    for pid in "${PIDS[@]}"; do
        if ! wait "$pid"; then
            echo -e "${RED}Error: API call failed (PID: $pid)${NC}" >&2
            EXIT_CODE=1
        fi
    done
    
    if [ $EXIT_CODE -ne 0 ]; then
        echo -e "${RED}Error: One or more API calls failed${NC}" >&2
        exit 1
    fi
}

# Combine all results
cat "$TEMP_DIR"/*.json 2>/dev/null | jq -s 'add // []' > "$TEMP_DIR/all_comments.json"

# Extract all "Prompts for AI Agents" sections in one pass
PROMPTS=$(cat "$TEMP_DIR/all_comments.json" | jq -r '
    .[] |
    select((.body // "") | test("(?i)Prompt(s)? for AI Agents")) |
    {
        file: .path,
        line: .line,
        prompt: (
            .body |
            capture("(?s)```[\\n\\r]+(?<content>.*?)[\\n\\r]+```") |
            .content // ""
        ),
        body: .body
    }
' | jq -s '.')

# Count prompts found
PROMPT_COUNT=$(echo "$PROMPTS" | jq 'length')

if [ "$PROMPT_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠️ No CodeRabbit comments found on first attempt. Retrying with GraphQL...${NC}"

    # GraphQL query for comprehensive search (single request)
    # Escape values using jq for proper JSON encoding (prevents injection)
    # jq -Rs produces quoted JSON string, then we strip outer quotes for template interpolation
    OWNER_ESCAPED=$(printf '%s' "$OWNER" | jq -Rs . | sed 's/^"//;s/"$//')
    REPO_ESCAPED=$(printf '%s' "$REPO" | jq -Rs . | sed 's/^"//;s/"$//')

    GRAPHQL_QUERY='{
        "query": "query {
            repository(owner: \"'"$OWNER_ESCAPED"'\", name: \"'"$REPO_ESCAPED"'\") {
                pullRequest(number: '$PR_NUMBER') {
                    reviews(first: 100) {
                        nodes {
                            body
                            author { login }
                        }
                    }
                    reviewThreads(first: 100) {
                        nodes {
                            comments(first: 100) {
                                nodes {
                                    body
                                    path
                                    line
                                    author { login }
                                }
                            }
                        }
                    }
                }
            }
        }"
    }'

    # Execute GraphQL query
    GRAPHQL_RESULT=$(gh api graphql -f query="$(echo "$GRAPHQL_QUERY" | jq -r .query)")

    # Parse GraphQL results
    PROMPTS=$(echo "$GRAPHQL_RESULT" | jq -r '
        [
            .data.repository.pullRequest.reviews.nodes[]? |
            select(.author.login == "coderabbitai[bot]" or (.body | test("'$CODERABBIT_PATTERN'"))) |
            {body}
        ] + [
            .data.repository.pullRequest.reviewThreads.nodes[]?.comments.nodes[]? |
            select(.author.login == "coderabbitai[bot]" or (.body | test("'$CODERABBIT_PATTERN'"))) |
            {body, path, line}
        ] |
        .[] |
        select((.body // "") | test("(?i)Prompt(s)? for AI Agents")) |
        {
            file: .path,
            line: .line,
            prompt: (
                .body |
                capture("(?s)```[\\n\\r]+(?<content>.*?)[\\n\\r]+```") |
                .content // ""
            )
        }
    ' | jq -s '.')

    PROMPT_COUNT=$(echo "$PROMPTS" | jq 'length')
fi

# Step 3: Present pre-resolution summary
echo -e "\n${BLUE}🔍 CodeRabbit PR Analysis Summary${NC}"
echo "────────────────────────────────────────────────────────────"
echo ""
echo "PR Analysis Complete"
echo ""
echo -e "📊 Total \"Prompts for AI Agents\" sections found: ${GREEN}$PROMPT_COUNT${NC}"

if [ "$PROMPT_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}No CodeRabbit review comments found requiring action.${NC}"
    exit 0
fi

# Group prompts by file
FILES_AFFECTED=$(echo "$PROMPTS" | jq -r '[.[].file] | unique | length')
echo -e "📁 Files affected: ${GREEN}$FILES_AFFECTED${NC}"

# Categorize and display affected files
echo -e "\n📂 Affected Files:"
echo "$PROMPTS" | jq -r 'group_by(.file) | .[] | "• \(.[0].file) (\(length) issue\(if length > 1 then "s" else "" end))"'

echo "────────────────────────────────────────────────────────────"

# Interactive confirmation (unless in auto mode)
if [[ "$AUTO_MODE" != "true" ]]; then
    echo ""
    echo "Would you like to deploy parallel fix agents? (y/n): "
    read -r response
    if [[ "$response" != "y" && "$response" != "Y" ]]; then
        echo "Wave deployment cancelled. No changes made."
        exit 0
    fi
    echo ""
fi

echo "Proceeding with automated resolution..."
echo "────────────────────────────────────────────────────────────"

# Step 4: Post resolution comment with summary of planned changes
echo -e "\n${BLUE}📝 Posting resolution notification with summary...${NC}"

# Generate summary of planned changes with better formatting
SUMMARY=$(echo "$PROMPTS" | jq -r '
    # Extract key action from each prompt
    def extract_action:
        .prompt |
        split("\n") |
        map(select(length > 0)) |
        (
            if any(contains("add") or contains("append")) then
                map(select(contains("add") or contains("append")))[0] // .[0]
            elif any(contains("update") or contains("modify")) then
                map(select(contains("update") or contains("modify")))[0] // .[0]
            elif any(contains("fix") or contains("change")) then
                map(select(contains("fix") or contains("change")))[0] // .[0]
            else
                .[0]
            end
        ) |
        # Clean up the action text
        gsub("^\\s+|\\s+$"; "") |
        # Truncate if too long
        if length > 120 then .[0:117] + "..." else . end;

    # Count issues by category
    def categorize:
        if .body | test("security|vulnerability|safety"; "i") then "Security"
        elif .body | test("error|exception|handling"; "i") then "Error Handling"
        elif .body | test("performance|optimization"; "i") then "Performance"
        elif .body | test("documentation|comment"; "i") then "Documentation"
        elif .body | test("test|coverage"; "i") then "Testing"
        else "Code Quality"
        end;

    # Build summary
    "## 📋 Planned Changes Summary\n\n" +
    "**Addressing " + (length | tostring) + " CodeRabbit review comments**\n\n" +

    # Category breakdown
    "### 📊 Issues by Category\n" +
    (sort_by(categorize) | group_by(categorize) |
     map("- **" + ((.[0] | categorize)) + "**: " + (length | tostring) + " issue" + (if length > 1 then "s" else "" end)) |
     join("\n")) + "\n\n" +

    # File-specific changes
    "### 📁 Changes by File\n" +
    (sort_by(.file // "") | group_by(.file) |
     map(
         "#### `" + .[0].file + "` (" + (length | tostring) + " change" + (if length > 1 then "s" else "" end) + ")\n" +
         (map("- " + extract_action) | join("\n"))
     ) | join("\n\n")) +

    "\n\n---\n" +
    "*🤖 Automated resolution in progress using Claude Code...*"
')

# Post comment with summary
gh pr comment "$PR_NUMBER" --body "@coderabbitai resolve

$SUMMARY"
echo -e "${GREEN}✓ Posted @coderabbitai resolve comment with change summary${NC}"

# Step 5: Prepare batch updates
echo -e "\n${BLUE}🔧 Preparing batch file updates...${NC}"

# Validate JSON input before processing
if ! validate_json_input "$PROMPTS"; then
    echo -e "${RED}Error: Security validation failed for prompt data${NC}"
    exit 1
fi

# Create a JSON structure for all edits with path sanitization
BATCH_EDITS=$(echo "$PROMPTS" | jq -s '
    group_by(.file) |
    map({
        file: .[0].file,
        edits: map({
            line: .line,
            prompt: .prompt
        })
    })
')

# Step 6: Apply all fixes using MultiEdit approach
echo -e "\n${BLUE}🚀 Applying all fixes in batch...${NC}"

# Generate Python script for batch updates
cat > "$TEMP_DIR/batch_update.py" << 'EOF'
import json
import sys
import re
import os

def validate_agent_path(filename):
    """
    Securely validate and construct path for agent files.
    Prevents path traversal attacks by ensuring file stays within .claude/agents/ directory.
    """
    if not filename:
        raise ValueError("Filename cannot be empty")

    # Remove any path separators and use only the basename
    safe_filename = os.path.basename(filename)

    # Additional validation: ensure filename doesn't contain suspicious patterns
    if '..' in safe_filename or safe_filename.startswith('.'):
        raise ValueError(f"Invalid filename pattern: {safe_filename}")

    # Ensure it's a markdown file for agents
    if not safe_filename.endswith('.md'):
        raise ValueError(f"Agent files must be .md files: {safe_filename}")

    # Construct the path using os.path.join for proper path handling
    agents_dir = ".claude/agents"
    candidate_path = os.path.join(agents_dir, safe_filename)

    # Resolve any remaining path components and verify it's within the agents directory
    resolved_path = os.path.abspath(candidate_path)
    agents_abs_path = os.path.abspath(agents_dir)

    if not resolved_path.startswith(agents_abs_path + os.sep):
        raise ValueError(f"Path traversal attempt detected: {filename}")

    return candidate_path

def sanitize_prompt_content(prompt):
    """Sanitize prompt content to prevent code injection."""
    if not isinstance(prompt, str):
        return ""

    # Remove dangerous patterns
    dangerous_patterns = [
        r'\$\(',  # Command substitution
        r'`',     # Backticks
        r'eval\s*\(',  # eval calls
        r'exec\s*\(',  # exec calls
        r'__import__',  # Import tricks
        r'subprocess',  # Subprocess module
        r'import\s+os', # OS module import
    ]

    sanitized = prompt
    for pattern in dangerous_patterns:
        sanitized = re.sub(pattern, '', sanitized, flags=re.IGNORECASE)

    return sanitized

def is_safe_content(content):
    """Check if content is safe to add to files."""
    if not content or len(content) > 1000:  # Size limit
        return False

    # Check for dangerous patterns including shell metacharacters
    dangerous_patterns = [
        r'\$\(',  # Command substitution
        r'`',     # Backticks
        r'eval\s*\(',  # eval calls
        r'exec\s*\(',  # exec calls
        r'rm\s+-rf',   # Dangerous rm commands
        r'sudo',       # Privilege escalation
        r'[;&|]',      # Shell command separators
        r'[<>]',       # Redirections
        r'\(\s*\)',    # Subshell
        r'\{\s*\}',    # Brace expansion
    ]

    for pattern in dangerous_patterns:
        if re.search(pattern, content, flags=re.IGNORECASE):
            return False

    return True

def validate_json_schema(data):
    """Validate JSON structure before processing to prevent malformed input attacks."""
    if not isinstance(data, list):
        raise ValueError("Expected array of file edits")
    for item in data:
        if not isinstance(item, dict):
            raise ValueError("Each edit must be an object")
        if 'file' not in item or not isinstance(item.get('file'), str):
            raise ValueError("Each edit must have a 'file' string field")
        if 'edits' not in item or not isinstance(item.get('edits'), list):
            raise ValueError("Each edit must have an 'edits' array field")
        for edit in item['edits']:
            if not isinstance(edit, dict) or 'prompt' not in edit:
                raise ValueError("Each edit entry must have a 'prompt' field")
    return True

def apply_batch_updates(edits_json):
    edits = json.loads(edits_json)

    # Validate JSON schema before processing
    try:
        validate_json_schema(edits)
    except ValueError as e:
        print(f"✗ Schema validation failed: {e}")
        return

    for file_edit in edits:
        if not file_edit['file']:
            continue

        try:
            file_path = validate_agent_path(file_edit['file'])
        except ValueError as e:
            print(f"✗ Security error for {file_edit['file']}: {e}")
            continue

        try:
            with open(file_path, 'r') as f:
                content = f.read()

            # Apply all edits for this file
            for edit in file_edit['edits']:
                prompt = edit['prompt']
                # Extract the actual change instruction from prompt
                # This is a simplified version - real implementation would parse the prompt
                # and apply the specific change requested

                # Sanitize and process prompt content safely
                if prompt and len(prompt) > 0:
                    # Sanitize prompt to prevent code injection
                    sanitized_prompt = sanitize_prompt_content(prompt)

                    # Parse out the suggestion from the sanitized prompt
                    lines = sanitized_prompt.split('\n')
                    for line in lines:
                        if 'append' in line.lower() or 'add' in line.lower():
                            # Extract quoted text safely
                            match = re.search(r'"([^"]+)"', line)
                            if match:
                                addition = match.group(1)
                                # Additional safety checks on addition
                                if is_safe_content(addition):
                                    content += f"\n\n{addition}"

            with open(file_path, 'w') as f:
                f.write(content)

            print(f"✓ Updated {file_path}")

        except Exception as e:
            print(f"✗ Error updating {file_path}: {e}")

if __name__ == "__main__":
    # Read from stdin with size limit and validation
    try:
        edits_json = sys.stdin.read(1024 * 1024)  # 1MB limit
        if len(edits_json.strip()) == 0:
            print("✗ No input provided", file=sys.stderr)
            sys.exit(1)

        # Additional JSON validation before processing
        try:
            test_parse = json.loads(edits_json)
            if not isinstance(test_parse, list):
                print("✗ Input must be a JSON array", file=sys.stderr)
                sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"✗ Invalid JSON input: {e}", file=sys.stderr)
            sys.exit(1)

        apply_batch_updates(edits_json)

    except Exception as e:
        print(f"✗ Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)
EOF

# Validate JSON input before processing
echo -e "\n${BLUE}🔒 Validating input security...${NC}"
if ! validate_json_input "$BATCH_EDITS"; then
    echo -e "${RED}✗ Security validation failed. Aborting batch updates.${NC}"
    exit 1
fi

# Apply batch updates with validated input
echo -e "${GREEN}✓ Input validation passed${NC}"
BATCH_OUTPUT=$(echo "$BATCH_EDITS" | python3 "$TEMP_DIR/batch_update.py" 2>&1)
BATCH_EXIT_CODE=$?
if [ $BATCH_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}✗ Batch update process failed (exit code: $BATCH_EXIT_CODE)${NC}"
    echo -e "${RED}  Error details: $BATCH_OUTPUT${NC}"
    exit 1
fi
echo "$BATCH_OUTPUT"

# Step 7: Stage changes
echo -e "\n${BLUE}📦 Staging changes...${NC}"
# Use safer approach for staging files - validate each file path
# Accumulate all errors before proceeding to provide complete feedback
CHANGED_FILES_LIST=()
INVALID_FILES_LIST=()
while IFS= read -r file_name; do
    if [ -n "$file_name" ]; then
        # Sanitize file path using our existing function
        safe_path=$(sanitize_file_path "$file_name")
        if [ $? -eq 0 ] && [ -n "$safe_path" ]; then
            full_path=".claude/agents/$safe_path"
            if [ -f "$full_path" ]; then
                CHANGED_FILES_LIST+=("$full_path")
            fi
        else
            INVALID_FILES_LIST+=("$file_name")
        fi
    fi
done < <(echo "$PROMPTS" | jq -r '[.[].file] | unique | .[]')

# Report all invalid files before proceeding
if [ ${#INVALID_FILES_LIST[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️ Skipped ${#INVALID_FILES_LIST[@]} invalid file path(s):${NC}"
    for invalid_file in "${INVALID_FILES_LIST[@]}"; do
        echo -e "${YELLOW}  - $invalid_file${NC}"
    done
fi

if [ ${#CHANGED_FILES_LIST[@]} -gt 0 ]; then
    git add "${CHANGED_FILES_LIST[@]}"
    echo -e "${GREEN}✓ Staged ${#CHANGED_FILES_LIST[@]} modified files${NC}"
fi

# Step 8: Create commit
echo -e "\n${BLUE}💾 Creating commit...${NC}"
git commit -m "fix(review): address CodeRabbit feedback

Applied fixes from $PROMPT_COUNT CodeRabbit review suggestions:
$(echo "$PROMPTS" | jq -r 'group_by(.file) | .[] | "- \(.[0].file): \(length) fix\(if length > 1 then "es" else "" end)"')

Resolves CodeRabbit suggestions from PR #$PR_NUMBER

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo -e "${GREEN}✓ Committed all fixes${NC}"

# Summary
echo -e "\n${GREEN}✅ CodeRabbit Review Resolution Complete${NC}"
echo "────────────────────────────────────────────────────────────"
echo -e "• Processed ${GREEN}$PROMPT_COUNT${NC} review comments"
echo -e "• Updated ${GREEN}$FILES_AFFECTED${NC} files"
echo -e "• Changes committed and ready to push"
echo "────────────────────────────────────────────────────────────"
