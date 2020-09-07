open Harness;;
open Json;;

let load_solution name = fun () ->
  let output = name ^ "_plugin.ml" in
  let compiled = name ^ "_plugin.cmo" in
    let (status, output) = run_cmd (String.concat " " ["ocamlc"; "-c"; output]) in
        if status then 
          (Dynlink.loadfile compiled; Passed)
        else
          SuiteAbort (escape output);
