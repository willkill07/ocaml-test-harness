open Json;;
open Unix;;

type result =
  | Passed
  | Failed of string
  | Abort of string
  | SuiteAbort of string
;;

type runner_result =
  | Init
  | Result of result
;;

let test name points (res : unit -> result) (prev : runner_result): runner_result * (string * Json.json) =
  let (info, status) =
    match prev with
    | Result (Abort _) | Result (SuiteAbort _) ->
      (* don't run the test *)
      (`Assoc [("passed", `Bool false); ("hint", `String "Not run due to critical failure earlier")], prev)
    | Init | Result (Passed) | Result (Failed _) ->
      (* run the test *)
      let result = res() in 
      Printf.printf "[%d pts] Test \"%s\": %s\n  Info: %s\n"
        points
        name
        (match result with Passed -> "PASSED" | Failed _ -> "FAILED" | Abort _ -> "ABORT" | SuiteAbort _ -> "FATAL")
        (match result with Passed -> "Passed" | Failed m | Abort m | SuiteAbort m -> m);
      match result with
      | Passed ->
        (`Assoc [("passed", `Bool true); ("points", `Int points)], Result result)
      | Failed msg | SuiteAbort msg | Abort msg ->
        (`Assoc [("passed", `Bool false); ("hint", `String msg)], Result result)
  in (status, (name, info))
;;

let run_suite init suite =
  let rec runner status tests output =
    match tests with
    | [] -> (status, `Assoc (output |> List.rev))
    | curr::rest -> 
      let (status', data) = curr status in
      runner status' rest (data::output)
  in
  runner init suite []
;;

let run_all suite_of_suites = 
  let rec runner status suites output = 
    match suites with
    | [] -> (status, output |> List.rev)
    | (name,curr)::rest ->
      Printf.printf "==================== %-20s ====================\n" name;
      let (status', data) = run_suite status curr in
      (* if a suite abort error is encountered, propagate it; otherwise reset *)
      let status' = match status' with
        | Result SuiteAbort _ -> status'
        | _ -> Init
      in runner status' rest ((name, data)::output)
  in runner Init suite_of_suites []
;;
let autolab (x:int) = Printf.printf
    "{\"scores\":{\"auto\":%d},\"scoreboard\":[\"%d\"]}\n" x x
;;

let rec calculate_score json_data =
  match json_data with
  | `Assoc l ->
    let rec reducer acc x = 
      let (id,data) = x in
      acc + match data with
      | `Assoc a -> List.fold_left reducer 0 a
      | `Int i when id = "points" -> i
      | _ -> 0
    in  List.fold_left reducer 0 l
  | `Bool _ | `Null | `String _ | `Float _  | `List _ -> 0
  | `Int i -> i
;;

let invoke_runner mapping = 
  let (status, data) = run_all mapping in
  let stages = `List (data |> List.map fst |> List.map (fun x -> `String x)) in
  let data = ("_presentation", `String "semantic")::("stages", stages)::data in
  let json_data = `Assoc data in
  Json.print_json json_data;
  print_string "\n";
  autolab (calculate_score json_data)
;;

let run_cmd cmd =
  let ic = Unix.open_process_in (cmd ^ " 2>&1") in
  let rec read result =
    try read ((input_line ic)::result)
    with End_of_file -> result |> List.rev
  in
  let result = read [] in
  let output = String.concat "\n" result in
  let status = close_process_in ic in
  let success = match status with
    | WEXITED code -> (code = 0)
    | WSIGNALED _ | WSTOPPED _ -> false
  in (success, output)
;;

let invoke func = func ()

let runtest0 (tag:string) (expected:'exp) (op:'exp->'act->bool) func () =
  try
    let actual = invoke func in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest1 (tag:string) (expected:'exp) (op:'exp->'act->bool) func x () =
  try
    let actual = invoke func x in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest2 (tag:string) (expected:'exp) (op:'exp->'act->bool) func x y () =
  try
    let actual = invoke func x y in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest3 (tag:string) (expected:'exp) (op:'exp->'act->bool) func x y z () =
  try
    let actual = invoke func x y z in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest4 (tag:string) (expected:'exp) (op:'exp->'act->bool) func x y z a () =
  try
    let actual = invoke func x y z a in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest5 (tag:string) (expected:'exp) (op:'exp->'act->bool) func x y z a b () =
  try
    let actual = invoke func x y z a b in
    if op actual expected then
      Passed
    else
      Failed "mismatch between expected and actual value"
  with Failure str -> Failed str | e -> Failed (Printexc.to_string e)
;;

let runtest = runtest1
;;

let load_solution name = fun () ->
  let output = name ^ "_plugin.ml" in
  let compiled = name ^ "_plugin.cmo" in
    let (status, output) = run_cmd (String.concat " " ["ocamlc"; "-c"; output]) in
        if status then 
          (Dynlink.loadfile compiled; Passed)
        else
          SuiteAbort output;
