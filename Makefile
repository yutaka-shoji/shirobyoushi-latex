# ============================================================
# Makefile for SHASE Transactions white-cover manuscript
# (shirobyoushi-latex)
# ============================================================

MAIN      := manuscript
TEX_FILES := $(MAIN).tex
BIB_FILES := references.bib
OUT_DIR   := out

# Diff: pass TAG=<git-tag-or-commit> on the command line
TAG       ?=

# Tools
LATEXMK   := latexmk
LATEXDIFF_VC := latexdiff-vc
TEX_FMT   := tex-fmt
CHKTEX    := chktex
TYPOS     := typos

# --- Phony targets -------------------------------------------
.PHONY: all pdf lint lint-chktex lint-typos check format diff clean cleanall help

# --- Default -------------------------------------------------
all: pdf

# --- PDF build -----------------------------------------------
pdf:
	$(LATEXMK)

# --- Lint ----------------------------------------------------
lint: lint-chktex lint-typos

lint-chktex:
	$(CHKTEX) $(TEX_FILES)

lint-typos:
	$(TYPOS) $(TEX_FILES) $(BIB_FILES)

# --- Format --------------------------------------------------
check:
	$(TEX_FMT) --check $(TEX_FILES)

format:
	$(TEX_FMT) $(TEX_FILES)

# --- Diff compilation ----------------------------------------
diff:
ifndef TAG
	$(error TAG is not set. Usage: make diff TAG=v1.0)
endif
	$(LATEXDIFF_VC) --git --force -r $(TAG) $(TEX_FILES)
	$(LATEXMK) $(MAIN)-diff*.tex

# --- Clean ---------------------------------------------------
clean:
	$(LATEXMK) -c
	rm -f $(MAIN)-diff*
	rm -f $(OUT_DIR)/$(MAIN)-diff*

cleanall: clean
	$(LATEXMK) -C

# --- Help ----------------------------------------------------
help:
	@echo "Usage:"
	@echo "  make              Build PDF"
	@echo "  make pdf          Build PDF only"
	@echo "  make lint         Run chktex and typos"
	@echo "  make check        Check formatting (tex-fmt --check)"
	@echo "  make format       Auto-format .tex files (tex-fmt)"
	@echo "  make diff TAG=v1  Build diff PDF against git tag/commit"
	@echo "  make clean        Remove intermediate files"
	@echo "  make cleanall     Remove all generated files"
	@echo "  make help         Show this help"
