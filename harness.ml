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
      (`Assoc [("passed", `Bool false); ("points", `Int 0); ("hint", `String "Not run due to critical failure earlier")], prev)
    | Init | Result (Passed) | Result (Failed _) ->
      (* run the test *)
      let result = res() in 
      Printf.printf "[%d pts] Test \"%s\": Passed=%B\n  Info: %s\n"
        points
        name
        (match result with Passed -> true | _ -> false)
        (match result with Passed -> "" | Failed m | Abort m | SuiteAbort m -> m);
      match result with
      | Passed ->
          (`Assoc [("passed", `Bool true); ("points", `Int points)], Result result)
      | Failed msg | SuiteAbort msg | Abort msg ->
          (`Assoc [("passed", `Bool false); ("points", `Int 0); ("hint", `String msg)], Result result)
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

let runtest tag expected func = fun x () ->
  try
      let actual = (func ()) x in
      if actual = expected then
        Passed
      else
        Failed "factorial 0 not correct"
  with Failure str -> Failed str
;;

let runtest2 tag expected func = fun x y () ->
    try
      let actual = (func ()) x y in
      if actual = expected then
        Passed
      else
        Failed "factorial 0 not correct"
    with Failure str -> Failed str
;;

let runtest3 tag expected func = fun x y z () ->
    try
      let actual = (func ()) x y z in
      if actual = expected then
        Passed
      else
        Failed "factorial 0 not correct"
    with Failure str -> Failed str
;;