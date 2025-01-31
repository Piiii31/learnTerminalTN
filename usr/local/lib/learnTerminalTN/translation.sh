#!/bin/bash
INSTALL_DIR="/usr/local/lib/learnTerminalTN"

# Load configuration
source "$INSTALL_DIR/config.sh"

# Initialize the COMMAND_MAP array if not already done
declare -A COMMAND_MAP=(
    ["go"]="ls"  # Example, ensure all relevant commands are mapped here
)

# Security checks
if [ ${#1} -gt 200 ]; then
    echo -e "${RED}Command too long! (max 200 chars)${NC}" >&2
    exit 1
fi

# Sanitize input
sanitize_input() {
    local input="$1"
    # Remove control characters and suspicious patterns
    echo "$input" | tr -d '[:cntrl:]' | sed -E 's/(;|\||`|>|<|&)//g'
}

# Expand arguments
expand_arguments() {
    local args=("$@")
    local expanded=()
    
    for arg in "${args[@]}"; do
        case "$arg" in
            -[A-Za-z0-9]{2,})
                # Split combined flags
                flags=$(echo "$arg" | sed 's/./ -&/g' | xargs)
                expanded+=($flags) ;;
            *) expanded+=("$arg") ;;
        esac
    done
    
    echo "${expanded[@]}"
}

# Explain arguments
explain_arguments() {
    local cmd="$1"
    shift
    local explained=()
    
    for arg in "$@"; do
        explanation=$(get_argument_explanation "$cmd $arg")
        explained+=("${arg}${CYAN}(${explanation})${NC}")
    done
    
    echo "${explained[@]}"
}

# Translate arguments
translate_arguments() {
    local translated_cmd="$1"
    shift  # Remove the translated command
    local args=("$@")
    
    translated_args=()
    for arg in "${args[@]}"; do
        # Handle common argument patterns
        case "$arg" in
            -[A-Za-z0-9]*)
                # Split combined short options (-rvf → -r -v -f)
                if [[ "$arg" =~ ^-[A-Za-z0-9]{2,}$ ]]; then
                    split_args=$(echo "$arg" | sed 's/./ -&/g' | cut -c 2-)
                    read -ra split_args_array <<< "$split_args"
                    for split_arg in "${split_args_array[@]}"; do
                        explanation=$(get_argument_explanation "$translated_cmd$split_arg")
                        translated_args+=("${split_arg}${MAGENTA} ($explanation)${NC}")
                    done
                else
                    explanation=$(get_argument_explanation "$translated_cmd$arg")
                    translated_args+=("${arg}${MAGENTA} ($explanation)${NC}")
                fi
                ;;
            --[A-Za-z0-9]*)
                # Long arguments
                explanation=$(get_argument_explanation "$translated_cmd$arg")
                translated_args+=("${arg}${MAGENTA} ($explanation)${NC}")
                ;;
            *)
                # Regular arguments
                translated_args+=("$arg")
                ;;
        esac
    done
    
    echo "${translated_args[@]}"
}

# Ensure base_cmd is set
base_cmd="$1"  # Assuming first argument is the command

# Check if command exists in COMMAND_MAP
translated_cmd="${COMMAND_MAP[$base_cmd]}"
if [ -z "$translated_cmd" ]; then
    # If command not found in COMMAND_MAP, use the original command
    translated_cmd="$base_cmd"
fi

# Dangerous command confirmation
if [[ "$translated_cmd" =~ ^(rm|mv|chmod|chown|kill|apt-get|zypper|pacman) ]]; then
    echo -ne "${YELLOW}Confirm dangerous command '$translated_cmd' (y/n): ${NC}"
    read -r -n 1 confirmation
    echo
    [[ "$confirmation" != "y" ]] && exit 0
fi

# Safe argument processing
safe_args=()
for arg in "${input_array[@]:1}"; do
    safe_args+=("$(printf "%q" "$arg")")
done

# Translate arguments
translated_args=$(translate_arguments "$base_cmd" "${input_array[@]:1}")
full_command="$translated_cmd $translated_args"

# Output final command
echo "$translated_cmd ${safe_args[*]}"
exit 0
