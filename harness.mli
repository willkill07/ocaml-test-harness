open Json;;

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

val test : string ->
           int ->
           (unit -> result) ->
           runner_result ->
           runner_result * (string * Json.json)
(* test [name] [points] [runner] *)

val invoke_runner : (string * (runner_result -> runner_result * (string * Json.json)) list) list -> unit
(* parameter usage: [ ("key", [ tests* ]), ..., ("keyN", [ tests* ]) ] *)

val load_solution : string -> unit -> result

val run_cmd : string -> bool * string
val runtest0 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'r) -> unit -> result
val runtest1 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'r) -> 'a1 -> unit -> result
val runtest2 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'a2 -> 'r) -> 'a1 -> 'a2 -> unit -> result
val runtest3 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'a2 -> 'a3 -> 'r) -> 'a1 -> 'a2 -> 'a3 -> unit -> result
val runtest4 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'a2 -> 'a3 -> 'a4 -> 'r) -> 'a1 -> 'a2 -> 'a3 -> 'a4 -> unit -> result
val runtest5 : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'a2 -> 'a3 -> 'a4 -> 'a5 -> 'r) -> 'a1 -> 'a2 -> 'a3 -> 'a4 -> 'a5 -> unit -> result
val runtest : string -> 'r -> ('r -> 'r -> bool) -> (unit -> 'a1 -> 'r) -> 'a1 -> unit -> result
