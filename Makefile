# Makefile for Building Books
# Automatically detects chapters in specified directory and generates a PDF

# Variables
BOOK_DIR ?= economics
OUTPUT_DIR = output
OUTPUT_FILE = $(OUTPUT_DIR)/$(BOOK_DIR)_book.pdf
PANDOC = pandoc

# Pandoc options
PANDOC_OPTS = --toc \
              --toc-depth=2 \
              --number-sections \
              -V geometry:margin=1in \
              -V documentclass=book \
              -V fontsize=12pt \
              -V linkcolor=blue \
              --pdf-engine=xelatex

# Automatically find all markdown files and sort them
CHAPTERS := $(sort $(wildcard $(BOOK_DIR)/*.md))

.PHONY: all clean help check

# Default target
all: $(OUTPUT_FILE)

# Create output directory if it doesn't exist
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Build the PDF book
$(OUTPUT_FILE): $(CHAPTERS) | $(OUTPUT_DIR)
	@echo "Building PDF book from $(words $(CHAPTERS)) chapters..."
	@echo "Chapters: $(CHAPTERS)"
	$(PANDOC) $(PANDOC_OPTS) -o $@ $(CHAPTERS)
	@echo "Book created: $@"

# Check if pandoc is installed
check:
	@command -v $(PANDOC) >/dev/null 2>&1 || { echo "Error: pandoc is not installed. Install with: sudo zypper install pandoc texlive" >&2; exit 1; }
	@echo "pandoc is installed: $$($(PANDOC) --version | head -n 1)"

# Clean generated files
clean:
	rm -rf $(OUTPUT_DIR)
	@echo "Cleaned output directory"

# List detected chapters
list:
	@echo "Detected chapters ($(words $(CHAPTERS))):"
	@for chapter in $(CHAPTERS); do echo "  - $$chapter"; done

# Help target
help:
	@echo "Book Builder Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make                    - Build the PDF book (default: economics)"
	@echo "  make BOOK_DIR=<folder>  - Build book from specified folder"
	@echo "  make check              - Check if pandoc is installed"
	@echo "  make list               - List all detected chapters"
	@echo "  make clean              - Remove generated files"
	@echo "  make help               - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make BOOK_DIR=economics"
	@echo "  make BOOK_DIR=english"
	@echo ""
	@echo "Current: BOOK_DIR=$(BOOK_DIR), Output=$(OUTPUT_FILE)"
