FILENAME = "one_file_report"
TEX_FILENAME = $(FILENAME).tex
NUWEB = nuweb
CI = ci
CO = co
RCSDIFF = rcsdiff
PDFLATEX = pdflatex
BIBTEX = bibtex
GENERATOR = generator.m
INPUTS = "4 2 0\n100 90 1\n300 200 3\n600 500 6\n1000 900 10\n1500 900 15\n2000 900 20\n2500 1000 25\n3000 300 30"

all: pdflatex-final

nuweb: 
	@echo "Running $(NUWEB) -c $(FILENAME)..."
	$(NUWEB) -c $(FILENAME).w 
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(NUWEB) -c failed"; \
		exit 1; \
	else \
		echo "$(NUWEB) -c completed successfully."; \
	fi

rcs: 
	@if [ ! -f "RCS/$(FILENAME).w,v" ]; then \
		echo "Adding $(FILENAME).w to RCS..."; \
		$(CI) -l $(FILENAME).w; \
		if [ $$? -ne 0 ]; then \
			echo "Error: Failed to add $(FILENAME).w to RCS"; \
			exit 1; \
		fi \
	else \
		echo "$(FILENAME).w is already under RCS control."; \
	fi
	$(CO) -l $(FILENAME).w

check-changes: 
	@echo "Checking for changes in $(RCS_FILENAME)..."
	@rcsdiff_output=`$(RCSDIFF) $(FILENAME).w`; \
	if [ -n "$$rcsdiff_output" ]; then \
		echo "Changes detected. Committing new version..."; \
		$(CI) -u $(FILENAME).w; \
		if [ $$? -ne 0 ]; then \
			echo "Error: Failed to commit new version of $(FILENAME).w"; \
			exit 1; \
		fi \
	else \
		echo "No changes detected in $(FILENAME).w."; \
	fi

pdflatex: 
	$(PDFLATEX) $(TEX_FILENAME) > pdflatex.log
	$(NUWEB) -c $(FILENAME).w

	@echo "Running $(PDFLATEX) $(FILENAME)..."
	$(PDFLATEX) $(FILENAME) > pdflatex.log
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(PDFLATEX) failed"; \
		exit 1; \
	else \
		echo "$(PDFLATEX) completed successfully."; \
	fi


bibtex: 
	@echo "Running $(BIBTEX) $(FILENAME)..."
	$(BIBTEX) $(FILENAME) > bibtex.log
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(BIBTEX) failed"; \
		exit 1; \
	else \
		echo "$(BIBTEX) completed successfully."; \
	fi

pdflatex-final: nuweb rcs check-changes pdflatex bibtex pdflatex pdflatex
	@echo "Running $(PDFLATEX) $(FILENAME) for the final time..."
	$(PDFLATEX) $(FILENAME) > pdflatex.log
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(PDFLATEX) failed"; \
		exit 1; \
	else \
		echo "$(PDFLATEX) completed successfully."; \
	fi
	@echo "Running $(PDFLATEX) $(FILENAME) for the final time..."
	$(PDFLATEX) $(FILENAME) > pdflatex.log
	@if [ $$? -ne 0 ]; then \
		echo "Error: $(PDFLATEX) failed"; \
		exit 1; \
	else \
		echo "$(PDFLATEX) completed successfully."; \
	fi
auto-generate: run_all


run_all:
	echo -e $(INPUTS) | while read num_vertices max_degree file_name; do \
		echo -e "$$num_vertices\n$$max_degree\n$$file_name\n" | octave $(GENERATOR); \
	done
generate:
	echo -e "$(NUM_VERTICES)\n$(MAX_DEGREE)\n$(FILE_NAME)" | octave $(GENERATOR)
clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz $(FILENAME).tex
