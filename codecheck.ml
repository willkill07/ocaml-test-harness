open Harness;;
open Json;;

let tailrec_bin = "/home/autograde/ocaml-tailrec/tailrec"

let check_for_tailrec_string s =
  let exitc = Sys.command ("cat tailrec.txt | fgrep -e '" ^ s ^ "' > /dev/null") in exitc == 0;;
let check_non_tailrec f = check_for_tailrec_string ("Non-tail-recursion function used: "^f);;
let check_tailrec f = not (check_non_tailrec f);;
let check_ite f = check_for_tailrec_string ("If-then-else used in: "^f);;
let check_non_ite f = not (check_ite f);;
let check_match f = check_for_tailrec_string ("Pattern matching used in: "^f);;
let check_non_match f = not (check_match f);;

let check_style (name:string) checks info = fun () ->  
  let status =
    checks
    |> List.map (fun x -> x name)
    |> List.fold_left (&&) true
  in
  if status then
    Passed
  else
    Abort info
;;

let compile (name:string) = fun () ->
  let (status, output) = run_cmd ("ocamlc -bin-annot -c " ^ name ^".ml") in
  if status then Passed else SuiteAbort output

let check_pervasives (name:string) = fun () -> 
  let _ = run_cmd (tailrec_bin^ " " ^name ^".cmt > tailrec.txt") in
  let (status, output) = run_cmd "fgrep -e \"Array used in:\" -e \"Loop used in:\" -e \"Reference used in:\" tailrec.txt" in
  if status then Abort (output) else Passed