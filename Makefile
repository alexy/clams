SAVE_GRAPH=save_graph
SC=sc
DEBUG=-g
PACKAGES=batteries,tokyo_cabinet,json-wheel

all: $(SAVE_GRAPH) $(SAVE_GRAPH).opt $(SC) $(SC).opt

binary_graph.ml tokyo_graph.ml json_graph.ml: utils.ml

%.cmo: %.ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -c $^ -o $@

%.cmx: %.ml
	ocamlfind ocamlopt $(DEBUG) -package $(PACKAGES) -c $^ -o $@

$(SAVE_GRAPH):     utils.cmo json_graph.cmo tokyo_graph.cmo binary_graph.cmo  $(SAVE_GRAPH).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@
        
$(SAVE_GRAPH).opt: utils.cmx json_graph.cmx tokyo_graph.cmx binary_graph.cmx  $(SAVE_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

tokyo_graph.cmo: json_graph.cmo
tokyo_graph.cmx: json_graph.cmx

soc_run.cmo: utils.cmo graph.cmo
soc_run.cmx: utils.cmx graph.cmx

$(SC):     utils.cmo json_graph.cmo tokyo_graph.cmo binary_graph.cmo graph.cmo soc_run.cmo $(SC).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(SC).opt: utils.cmx json_graph.cmx tokyo_graph.cmx binary_graph.cmx graph.cmx soc_run.cmx $(SC).cmx
	ocamlfind ocamlopt $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

clean:
	rm -f *.cmi *.cmo *.cmx *.o *.opt sc save_graph

