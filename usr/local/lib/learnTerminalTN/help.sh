#!/bin/bash
INSTALL_DIR="/usr/local/lib/learnTerminalTN"

source "$INSTALL_DIR/config.sh"

show_help() {
    echo -e "${GREEN}Available commands:${NC}\n"
    
    for human in "${!COMMAND_MAP[@]}"; do
        # Base command and explanation
        echo -e "${BLUE}Command: ${YELLOW}$human${NC}"
        echo -e "${GREEN}Execution: ${MAGENTA}${COMMAND_MAP[$human]}${NC}"
        echo -e "${CYAN}Description: ${EXPLANATIONS[$human]}${NC}"
        
        # Argument explanations
        case "$human" in
            list|go)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                echo -e "  ${CYAN}-a${NC}    Show hidden files"
                echo -e "  ${CYAN}-h${NC}    Human-readable sizes"
                echo -e "  ${CYAN}-l${NC}    Long listing format"
                echo -e "  ${CYAN}-t${NC}    Sort by modification time"
                ;;
            
            create_file)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                echo -e "  ${CYAN}-t${NC}    Set timestamp (format: [[CC]YY]MMDDhhmm[.ss])"
                echo -e "  ${CYAN}-r${NC}    Use reference file's timestamps"
                ;;
                
            compress|decompress_gz)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                echo -e "  ${CYAN}-v${NC}    Verbose output"
                echo -e "  ${CYAN}-f${NC}    Specify archive filename"
                echo -e "  ${CYAN}-z${NC}    Filter through gzip"
                echo -e "  ${CYAN}-x${NC}    Extract files from archive"
                ;;
            
            install_pkg|update_pkg|upgrade_system)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                case "$DISTRO" in
                    debian|ubuntu)
                        echo -e "  ${CYAN}-y${NC}    Assume 'yes' to prompts"
                        echo -e "  ${CYAN}--no-install-recommends${NC}    Skip optional dependencies" ;;
                    manjaro|arch)
                        echo -e "  ${CYAN}--noconfirm${NC}    Bypass confirmation prompts"
                        echo -e "  ${CYAN}--needed${NC}    Only install if not present" ;;
                    opensuse*)
                        echo -e "  ${CYAN}-y${NC}    Auto-confirm changes"
                        echo -e "  ${CYAN}--no-recommends${NC}    Exclude recommended packages" ;;
                esac
                ;;
            
            search)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                echo -e "  ${CYAN}-i${NC}    Case-insensitive search"
                echo -e "  ${CYAN}-R${NC}    Recursive directory search"
                echo -e "  ${CYAN}-n${NC}    Show line numbers"
                echo -e "  ${CYAN}-C 3${NC}    Show 3 lines of context"
                ;;
            
            manage_services)
                echo -e "\n${MAGENTA}Common arguments:${NC}"
                echo -e "  ${CYAN}start${NC}    Start a service"
                echo -e "  ${CYAN}stop${NC}    Stop a service"
                echo -e "  ${CYAN}restart${NC}    Restart a service"
                echo -e "  ${CYAN}enable${NC}    Enable auto-start at boot"
                ;;
            
            terminate)
                echo -e "\n${MAGENTA}Common signals:${NC}"
                echo -e "  ${CYAN}-9${NC}    SIGKILL (forceful termination)"
                echo -e "  ${CYAN}-15${NC}   SIGTERM (graceful termination)"
                echo -e "  ${CYAN}-2${NC}    SIGINT (keyboard interrupt)"
                ;;
            
            change_permissions)
                echo -e "\n${MAGENTA}Common modes:${NC}"
                echo -e "  ${CYAN}755${NC}    rwx for owner, rx for others"
                echo -e "  ${CYAN}644${NC}    rw for owner, r for others"
                echo -e "  ${CYAN}-R${NC}     Recursive permission change"
                ;;
            
            config_network)
                echo -e "\n${MAGENTA}Common subcommands:${NC}"
                echo -e "  ${CYAN}addr show${NC}    Display IP addresses"
                echo -e "  ${CYAN}link set dev eth0 up${NC}    Enable network interface"
                echo -e "  ${CYAN}route add default gw 192.168.1.1${NC}    Add default gateway"
                ;;
        esac
        
        echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    done
    
    # Add general argument explanation
    echo -e "${YELLOW}Argument Legend:${NC}"
    echo -e "  ${CYAN}-<letter>${NC}    Single-character option"
    echo -e "  ${CYAN}--<word>${NC}     Multi-character option"
    echo -e "  ${CYAN}${UNDERLINE}CAPS${NC}        Placeholder for actual value"
    echo -e "\n${MAGENTA}Use 'man <command>' for full documentation${NC}"
}