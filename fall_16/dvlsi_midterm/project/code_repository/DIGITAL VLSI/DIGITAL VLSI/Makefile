PAPER = main
TEX = $(wildcard *.tex)
BIB = ref.bib
FIGS = $(wildcard figures/*.pdf)

.PHONY: all figure clean

$(PAPER).pdf: $(TEX) $(BIB) $(FIGS) sig-alternate.cls
	pdflatex $(PAPER)
	bibtex $(PAPER)
	pdflatex $(PAPER)
	pdflatex $(PAPER)
	#open $(PAPER).pdf
	#acroread $(PAPER).pdf &

figure:
	cd figures; ./crop.sh; cd ..
clean:
	rm -f \#*\# *~ *.aux *.bbl *.blg *.log *.out $(PAPER).pdf

