open Tail_plugin;;
open Harness;;
open Json;;

let ffactorial1 = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.factorial1)
;;
let ffactorial2 = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.factorial2)
;;
let ffactorial3 = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.factorial3)
;;
let ffibonacci = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.fibonacci)
;;

let fsqrt = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.sqrt)
;;
let fsqrt2 = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.sqrt2)
;;

let fmap = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.map)
;;
let fmap2 = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.map2)
;;
let frev = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.rev)
;;

let froots = fun () ->
  let module Tail = (val get_plugin () : PLUG) in
    (Tail.roots)
;;

let load_solution name = fun () ->
  let submission = name ^ ".ml" in
  let partial = name ^ "_plug_part.ml" in
  let output = name ^ "_plug.ml" in
  let compiled = name ^ "_plug.cmo" in
    let _ = run_cmd (String.concat " " ["cat"; submission; partial; ">"; output]) in
    let (status, output) = run_cmd (String.concat " " ["ocamlc"; "-c"; output]) in
        if status then 
          (Dynlink.loadfile compiled; Passed)
        else
          SuiteAbort (escape output);
