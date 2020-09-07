#!/usr/bin/env bash

name=$1
Name="${name^}"

interface=${name}.mli

cat <<'EOF' > make_plug_part.awk
BEGIN{
    print "open " moduleName ";;";
    print "module M:PLUG =\n  struct";
}
{
    $1 = "let"
    print "    " $0 " = " $2;
}
END {
    print "  end\n\nlet() = p := Some (module M:PLUG)";
}
EOF

cp ${name}.ml ${name}_plugin.ml
awk -f make_plug_part.awk -v moduleName=${Name}_plugin_interface ${interface} >> ${name}_plugin.ml
rm -f make_plug_part.awk

cat <<'EOF' > make_plugin_loader.awk
BEGIN{
    print "open " moduleName ";;";
}
/val/ {
    print "let f" $2 " = fun () -> "
    print "  let module " module " = (val get_plugin () : PLUG) in"
    print "    (" module "." $2 ")"
}
EOF
cp partials/plugin_loader_part.ml ${name}_plugin_loader.ml 
awk -f make_plugin_loader.awk -v moduleName=${Name}_plugin_interface -v module=${Name} ${interface} >> ${name}_plugin_loader.ml
rm -f make_plugin_loader.awk

cat<<'EOF' > make_plugin_implementation.awk
BEGIN {
    print "module type PLUG = "
    print "  sig"
}
{
    print;
}
END {
    print "  end"
    print ";;"
    print "let p = ref None;;"
    print "let get_plugin () : (module PLUG)  = match !p with | Some s -> s | None -> failwith \"No plugin loaded\""
}
EOF

awk -f make_plugin_implementation.awk ${interface} > ${name}_plugin_interface.ml
rm -f make_plugin_implementation.awk
