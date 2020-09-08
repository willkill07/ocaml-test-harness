open Harness;;
open Json;;
open Codecheck;;

let float_comp eps a b = abs_float (a -. b) <= eps
let list_comp (op:'a -> 'a -> bool) l1 l2 =
  if List.length l1 <> List.length l2 then
    failwith "size mismatch -- this isn't good"
  else
    (List.map2 op l1 l2) |> List.fold_left (&&) true
let float_list_eq = list_comp (float_comp 0.00001)
let check_sqrt tol actual expected =
  abs_float (actual *. actual -. expected) <= tol
;;

(* these two lines would change based off the submission file expected *)
open Tail_plugin_loader;;
let file_base = "tail"
in
let compile_test = ("Compile", [
    test "Compile student submission" 0 (compile file_base);
    test "Check student submission for Array, Loops, and References" 0 (check_pervasives file_base);
    test "Load student submission" 0 (load_solution file_base)
  ])
in
let factorial_test = ("factorial1", [
      test "structure" 0 (check_style "factorial1" [check_non_tailrec; check_ite; check_non_match] "Must use if-then-else");
      test "factorial1(1)" 1 (runtest "wrong result" 1 (=) factorial1 1);
      test "factorial1(2)" 1 (runtest "wrong result" 2 (=) factorial1 2);
      test "factorial1(4)" 1 (runtest "wrong result" 24 (=) factorial1 4);
      test "factorial1(5)" 1 (runtest "wrong result" 120 (=) factorial1 5);
      test "factorial1(10)" 2 (runtest "wrong result" 3628800 (=) factorial1 10)
  ])
in
let factorial2_test = ("factorial2", [
    test "structure" 0 (check_style "factorial2" [check_match; check_non_ite] "Must use match");
    test "factorial2(1)" 1 (runtest "wrong result1" 1 (=) factorial2 1);
    test "factorial2(2)" 1 (runtest "wrong result" 2 (=) factorial2 2);
    test "factorial2(4)" 1 (runtest "wrong result" 24 (=) factorial2 4);
    test "factorial2(5)" 1 (runtest "wrong result" 120 (=) factorial2 5);
    test "factorial2(10)" 3 (runtest "wrong result" 3628800 (=) factorial2 10)
  ])
in
let factorial3_test = ("factorial3", [
    test "structure" 0 (check_style "factorial3" [check_tailrec] "Must use tail recursion");
    test "factorial3(1)" 1 (runtest "wrong result" 1 (=) factorial3 1);
    test "factorial3(2)" 1 (runtest "wrong result" 2 (=) factorial3 2);
    test "factorial3(4)" 1 (runtest "wrong result" 24 (=) factorial3 4);
    test "factorial3(5)" 1 (runtest "wrong result" 120 (=) factorial3 5);
    test "factorial3(10)" 3 (runtest "wrong result" 3628800 (=) factorial3 10)
  ])
in
let fibonacci_test = ("fibonacci", [
    test "structure" 0 (check_style "fibonacci" [check_tailrec;check_match;check_non_ite] "Must use match and tail recursion");
    test "fibonacci(0)" 1 (runtest "wrong answer" 0 (=) fibonacci 0);
    test "fibonacci(1)" 1 (runtest "wrong answer" 1 (=) fibonacci 1);
    test "fibonacci(2)" 1 (runtest "wrong answer" 1 (=) fibonacci 2);
    test "fibonacci(3)" 1 (runtest "wrong answer" 2 (=) fibonacci 3);
    test "fibonacci(4)" 1 (runtest "wrong answer" 3 (=) fibonacci 4);
    test "fibonacci(5)" 1 (runtest "wrong answer" 5 (=) fibonacci 5);
    test "fibonacci(6)" 1 (runtest "wrong answer" 8 (=) fibonacci 6);
    test "fibonacci(44)" 8 (runtest "wrong answer" 701408733 (=) fibonacci 44);
  ])
in
let sqrt_test = ("sqrt", [
    test "big tol, big number" 3 (runtest2 "wrong answer" 100.0 (check_sqrt 0.1) sqrt 0.1 100.0);
    test "big tol, small number" 3 (runtest2 "wrong answer" 7.0 (check_sqrt 0.1) sqrt 0.1 7.0);
    test "small tol, big number" 3 (runtest2 "wrong answer" 100.0 (check_sqrt 0.001) sqrt 0.001 100.0);
    test "small tol, small number" 3 (runtest2 "wrong answer" 100.0 (check_sqrt 0.001) sqrt 0.001 100.0);
    test "small tol, tiny number" 3 (runtest2 "wrong answer" 0.0001 (check_sqrt 0.000001) sqrt 0.000001 0.0001);
])
in
let sqrt2_test = ("sqrt2", [
    test "big number" 1 (runtest "wrong answer" 100.0 (check_sqrt 0.00001) sqrt2 100.0);
    test "small number" 2 (runtest "wrong answer (check around ~23)" 23.1406926328 (check_sqrt 0.00001) sqrt2 23.1406926328);
    test "tiny number" 2 (runtest "wrong answer" 0.5 (check_sqrt 0.00001) sqrt2 0.5);
])
in
let map_test = ("map", [
    test "structure" 0 (check_style "map" [check_non_tailrec] "Must not use tail recursion");
    (let lst = [10; 20; 30; 40; 50; 60] in
    let fn = string_of_int in
    let expected = (List.map fn lst) in
    test "testing map" 10 (runtest2 "wrong answer" expected (=) map fn lst))
])
in
let map2_test = ("map2", [
    test "structure" 0 (check_style "map2" [check_tailrec] "Must use tail recursion");
    (let lst = [10; 20; 30; 40; 50; 60] in
    let fn = string_of_int in
    let expected = (List.map fn lst) in
    test "testing map" 10 (runtest2 "wrong answer" expected (=) map2 fn lst))
])
in
let range_test = ("range", [
  test "range same" 1 (runtest2 "wrong answer" [100] (=) range 100 100);
  test "range small1" 1 (runtest2 "wrong answer" [1000] (=) range 1000 1000);
  test "range small2" 1 (runtest2 "wrong answer" [1000;1001] (=) range 1000 1001);
  test "range medium" 1 (runtest2 "wrong answer" [4;5;6;7;8] (=) range 4 8);
  test "range negative" 1 (runtest2 "wrong answer" [] (=) range 10 9)
])
in
let roots_answer =
  [1.; 1.41421356237309515; 1.73205080756887719; 2.; 2.23606797749979;
       2.44948974278317788; 2.64575131106459072; 2.82842712474619029; 3.;
       3.16227766016837952; 3.3166247903554; 3.46410161513775439;
       3.60555127546398912; 3.74165738677394133; 3.87298334620741702; 4.;
       4.12310562561766059; 4.24264068711928477; 4.35889894354067398;
       4.47213595499958] in
let roots_test = ("roots", [
  test "roots correct" 5 (runtest0 "wrong answer" roots_answer (float_list_eq) roots)
])
in
let all_tests = [compile_test; factorial_test; factorial2_test; factorial3_test; fibonacci_test; sqrt_test; sqrt2_test; map_test; map2_test; range_test; roots_test]
in
invoke_runner all_tests
;;