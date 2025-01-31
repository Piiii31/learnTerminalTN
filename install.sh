#!/bin/bash
set -e  # Exit immediately if any command fails

# Check for figlet installation
if ! command -v figlet &> /dev/null; then
    echo -e "${YELLOW}Installing figlet...${NC}"
    case "$DISTRO" in
        debian|ubuntu)
            sudo apt-get install -y figlet ;;
        opensuse*)
            sudo zypper install -y figlet ;;
        manjaro|arch)
            sudo pacman -Sy --noconfirm figlet ;;
        *)
            echo -e "${RED}Unsupported package manager${NC}" >&2
            exit 1
            ;;
    esac || {
        echo -e "${RED}Failed to install figlet${NC}" >&2
        exit 1
    }
fi

# Color definitions for installation messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check bash version (requires 4.0+ for associative arrays)
if (( BASH_VERSINFO[0] < 4 )); then
    echo -e "${RED}Error: This installation requires bash 4.0 or newer${NC}" >&2
    exit 1
fi

# Check for figlet installation
if ! command -v figlet &> /dev/null; then
    echo -e "${YELLOW}Installing figlet...${NC}"
    sudo apt-get install -y figlet || {
        echo -e "${RED}Failed to install figlet${NC}" >&2
        exit 1
    }
fi

# Installation paths
INSTALL_DIR="/usr/local/lib/learnTerminalTN"
BIN_PATH="/usr/local/bin/learnTerminalTN"

# Create installation directory with verification
echo -e "${YELLOW}Creating installation directory...${NC}"
sudo mkdir -p "$INSTALL_DIR" || {
    echo -e "${RED}Failed to create directory $INSTALL_DIR${NC}" >&2
    exit 1
}

# Set permissions for the installation directory
sudo chmod 755 "$INSTALL_DIR" || {
    echo -e "${RED}Failed to set permissions for $INSTALL_DIR${NC}" >&2
    exit 1
}

# Copy files with verification
echo -e "${YELLOW}Installing files...${NC}"

# Verify source files exist
for file in learnTerminalTN config.sh translation.sh help.sh; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Missing required file $file${NC}" >&2
        exit 1
    fi
done

# Copy main executable
sudo cp -v learnTerminalTN "$BIN_PATH" || {
    echo -e "${RED}Failed to copy main executable${NC}" >&2
    exit 1
}

# Set permissions for the main executable
sudo chmod 755 "$BIN_PATH" || {
    echo -e "${RED}Failed to set permissions for main executable${NC}" >&2
    exit 1
}

# Copy support files
sudo cp -v config.sh translation.sh help.sh "$INSTALL_DIR/" || {
    echo -e "${RED}Failed to copy support files${NC}" >&2
    exit 1
}

# Set permissions for support files
sudo chmod 755 "$INSTALL_DIR"/translation.sh || {
    echo -e "${RED}Failed to set permissions for translation.sh${NC}" >&2
    exit 1
}

sudo chmod 644 "$INSTALL_DIR"/config.sh "$INSTALL_DIR"/help.sh || {
    echo -e "${RED}Failed to set permissions for config.sh or help.sh${NC}" >&2
    exit 1
}

# Verify installation
echo -e "${YELLOW}Verifying installation...${NC}"
if [ ! -x "$BIN_PATH" ]; then
    echo -e "${RED}Main executable not found or not executable${NC}" >&2
    exit 1
fi

for file in config.sh translation.sh help.sh; do
    if [ ! -f "$INSTALL_DIR/$file" ]; then
        echo -e "${RED}Missing installed file: $INSTALL_DIR/$file${NC}" >&2
        exit 1
    fi
done

# Success message
echo -e "\n${GREEN}Installation successful!${NC}"
echo -e "Version: $(date +%Y-%m-%d_%H%M%S)"
echo -e "Run command: ${GREEN}learnTerminalTN${NC} to start\n"

# Final check
echo -e "${YELLOW}Installation summary:${NC}"
ls -l "$BIN_PATH"
ls -l "$INSTALL_DIR"
