.PHONY : all clean interface tidy

name := tail
Name := Tail

INTERFACE_SRC := json.mli harness.mli codecheck.mli tail.mli
INTERFACE_OBJ := $(INTERFACE_SRC:.mli=.cmi)
GENERATED_SRC := ${name}_plugin.ml ${name}_plugin_loader.ml ${name}_plugin_interface.ml

SRC := json.ml harness.ml codecheck.ml ${name}_plugin_interface.ml ${name}_plugin_loader.ml test.ml
OBJ := $(SRC:.ml=.cmo)

grade : all 
	./test

all : interface test ${name}_plugin.ml

interface : $(INTERFACE_OBJ)

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

INTERFACE := ${name}.mli
MODULE_NAME := ${Name}_plugin_interface

${name}_plugin.ml: ${name}.ml
	cp $< $@
	awk -f ./awks/make_plugin -v moduleName=${MODULE_NAME} ${INTERFACE} >> $@

${name}_plugin_loader.ml : partials/plugin_loader_part.ml
	cp partials/plugin_loader_part.ml $@
	awk -f ./awks/make_plugin_loader -v moduleName=${MODULE_NAME} -v module=${Name} ${INTERFACE} >> $@

${name}_plugin_interface.ml :
	awk -f ./awks/make_plugin_implementation ${INTERFACE} > $@
