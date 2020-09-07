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

val run_cmd : string -> bool * string
val runtest : string -> 'res -> (unit -> 'arg1 -> 'res) -> 'arg1 -> unit -> result
val runtest2 : string -> 'res -> (unit -> 'arg1 -> 'arg2 -> 'res) -> 'arg1 -> 'arg2 -> unit -> result
val runtest3 : string -> 'res -> (unit -> 'arg1 -> 'arg2 -> 'arg3 -> 'res) -> 'arg1 -> 'arg2 -> 'arg3 -> unit -> result
val runtest4 : string -> 'res -> (unit -> 'arg1 -> 'arg2 -> 'arg3 -> 'arg4 -> 'res) -> 'arg1 -> 'arg2 -> 'arg3 -> 'arg4 -> unit -> result
val runtest5 : string -> 'res -> (unit -> 'arg1 -> 'arg2 -> 'arg3 -> 'arg4 -> 'arg5 -> 'res) -> 'arg1 -> 'arg2 -> 'arg3 -> 'arg4 -> 'arg5 -> unit -> result
