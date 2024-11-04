.PHONY: w c

w:
	typst w example/example.typ --root .
	
c:
	typst c example/example.typ --root .
