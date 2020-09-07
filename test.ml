open Harness;;
open Json;;
open Codecheck;;
open Tail_plugin_loader;;

let file_base = "tail";;

let compile_test = ("Compile", [
    test "Compile student submission" 0 (compile file_base);
    test "Check student submission for Array, Loops, and References" 0 (check_pervasives file_base);
    test "Load student submission" 0 (load_solution file_base)
  ])
in
let factorial_test = ("factorial1", [
      test "structure" 0 (check_style "factorial1" [check_non_tailrec; check_ite; check_non_match] "Must use if-then-else");
      test "factorial1(1)" 1 (runtest "factorial1 1" 1 (=) factorial1 1);
      test "factorial1(2)" 1 (runtest "factorial1 2" 2 (=) factorial1 2);
      test "factorial1(4)" 1 (runtest "factorial1 4" 24 (=) factorial1 4);
      test "factorial1(5)" 1 (runtest "factorial1 5" 120 (=) factorial1 5);
      test "factorial1(10)" 2 (runtest "factorial1 10" 3628800 (=) factorial1 10)
  ])
in
let factorial2_test = ("factorial2", [
    test "structure" 0 (check_style "factorial2" [check_match; check_non_ite] "Must use match");
    test "factorial2(1)" 1 (runtest "factorial2 1" 1 (=) factorial2 1);
    test "factorial2(2)" 1 (runtest "factorial2 2" 2 (=) factorial2 2);
    test "factorial2(4)" 1 (runtest "factorial2 4" 24 (=) factorial2 4);
    test "factorial2(5)" 1 (runtest "factorial2 5" 120 (=) factorial2 5);
    test "factorial2(10)" 3 (runtest "factorial2 10" 3628800 (=) factorial2 10)
  ])
in
let factorial3_test = ("factorial3", [
    test "structure" 0 (check_style "factorial3" [check_tailrec] "Must use tail recursion");
    test "factorial3(1)" 1 (runtest "factorial3 1" 1 (=) factorial3 1);
    test "factorial3(2)" 1 (runtest "factorial3 2" 2 (=) factorial3 2);
    test "factorial3(4)" 1 (runtest "factorial3 4" 24 (=) factorial3 4);
    test "factorial3(5)" 1 (runtest "factorial3 5" 120 (=) factorial3 5);
    test "factorial3(10)" 3 (runtest "factorial3 10" 3628800 (=) factorial3 10)
  ])
in
let fibonacci_test = ("fibonacci", [
    test "structure" 0 (check_style "fibonacci" [check_tailrec;check_match;check_non_ite] "Must use match and tail recursion");
    test "fibonacci(0)" 1 (runtest "base case" 0 (=) fibonacci 0);
    test "fibonacci(1)" 1 (runtest "base case" 1 (=) fibonacci 1);
    test "fibonacci(2)" 1 (runtest "recursive case 1" 1 (=) fibonacci 2);
    test "fibonacci(3)" 1 (runtest "recursive case 2" 2 (=) fibonacci 3);
    test "fibonacci(4)" 1 (runtest "recursive case 3" 3 (=) fibonacci 4);
    test "fibonacci(5)" 1 (runtest "recursive case 4" 5 (=) fibonacci 5);
    test "fibonacci(6)" 1 (runtest "recursive case 5" 8 (=) fibonacci 6);
    test "fibonacci(44)" 8 (runtest "big recursive case" 701408733 (=) fibonacci 44);
  ])
in
let sqrt_test = ("sqrt", [
    test "a" 1 (fun () -> Passed);
])
in
let sqrt2_test = ("sqrt2", [
    test "a" 1 (fun () -> Passed);
])
in
let map_test = ("map", [
    test "structure" 0 (check_style "map" [check_non_tailrec] "Must not use tail recursion");
    (let lst = [10; 20; 30; 40; 50; 60] in
    let fn = string_of_int in
    let expected = (List.map fn lst) in
    test "testing map" 10 (runtest2 "map with some list and some function" expected (=) map fn lst))
])
in
let map2_test = ("map2", [
    test "structure" 0 (check_style "map2" [check_tailrec] "Must use tail recursion");
    (let lst = [10; 20; 30; 40; 50; 60] in
    let fn = string_of_int in
    let expected = (List.map fn lst) in
    test "testing map" 10 (runtest2 "map with some list and some function" expected (=) map2 fn lst))
])
in
let range_test = ("range", [
  test "range empty" 1 (runtest2 "range with same args" [] (=) range 100 100);
  test "range single" 1 (runtest2 "rev with small size" [1000] (=) range 1000 1000);
  test "range small" 1 (runtest2 "rev with small size" [1000;1001] (=) range 1000 1001);
  test "range medium" 1 (runtest2 "range with medium size" [4;5;6;7;8] (=) range 4 8);
  test "range reversed" 1 (runtest2 "range with reversed args" [] (=) range 10 9)
])
in
let roots_test = ("roots", [
  test "range empty" 1 (runtest2 "range with same args" [] (=) range 100 100);
])
in
let all_tests = [compile_test; factorial_test; factorial2_test; factorial3_test; fibonacci_test; sqrt_test; sqrt2_test; map_test; map2_test; range_test; roots_test]
in
invoke_runner all_tests
;;