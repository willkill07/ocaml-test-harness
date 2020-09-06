.PHONY : all clean interface

INTERFACE_SRC := json.mli harness.mli codecheck.mli tail.mli
INTERFACE_OBJ := $(INTERFACE_SRC:.mli=.cmi)

SRC := json.ml harness.ml codecheck.ml tail_plugin.ml tail_plugin_loader.ml test.ml
OBJ := $(SRC:.ml=.cmo)

grade : all
	./test

all : interface test

interface : $(INTERFACE_OBJ)

test : $(OBJ)
	ocamlc -o $@ unix.cma str.cma dynlink.cma $^

%.cmi : %.mli
	ocamlc -c $^

clean :
	-@rm -vf *.cmi *.cmo tail_plug.ml test *.cmt 

%.cmo : %.ml
	ocamlc -c $^

-include $(SHELL ocamldep *.ml))