.PHONY : all clean interface tidy

INTERFACE_SRC := json.mli harness.mli codecheck.mli tail.mli
INTERFACE_OBJ := $(INTERFACE_SRC:.mli=.cmi)
GENERATED_SRC := tail_plugin.ml tail_plugin_loader.ml tail_plugin_interface.ml

SRC := json.ml harness.ml codecheck.ml tail_plugin_interface.ml tail_plugin_loader.ml test.ml
OBJ := $(SRC:.ml=.cmo)

grade : all
	./test

all : interface generated_files test

interface : $(INTERFACE_OBJ)

generated_files : $(GENERATED_SRC)

$(GENERATED_SRC) : 
	./make_files.sh tail

test : $(OBJ)
	ocamlc -o $@ unix.cma str.cma dynlink.cma $^

%.cmi : %.mli
	ocamlc -c $^

clean :
	-@rm -vf *.cmi *.cmo tail_plug.ml test *.cmt 

tidy : clean
	-@rm -vf $(GENERATED_SRC)

%.cmo : %.ml
	ocamlc -c $^

-include $(SHELL ocamldep *.ml))