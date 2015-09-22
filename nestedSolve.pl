/*§
  ===========================================================================
  WebSolver
  ===========================================================================
  Copyright (C) 2015 Gianluca Costa
  ===========================================================================
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ===========================================================================
*/

/**
 * nestedSolve(LocalDb, Goal)
 *
 * Meta-interpreter printing out every resolution step, indented according to its level.
 *
 * These /2 predicates are the interface to WebSolver and internally employ the implementation versions.
 */
nestedSolve(_, true) :- !.


nestedSolve(LocalDb, (LeftGoal, RightGoal)) :-
  !,
  nestedSolve(LocalDb, (LeftGoal, RightGoal), 0).


nestedSolve(LocalDb, LocalGoal) :-
  !,
  nestedSolve(LocalDb, LocalGoal, 0).


nestedSolve(_, GlobalGoal) :-
  nestedSolve(_, GlobalGoal, 0).


/**
 * nestedSolve(LocalDb, Goal, Level)
 *
 * Implementation functions
 */
nestedSolve(_, true, _) :- !.

nestedSolve(LocalDb, (LeftGoal, RightGoal), Level) :-
  !,

  printLevel(Level),
  format("Solving conjunction: (~w),(~w)...~n", [LeftGoal, RightGoal]),

  NextLevel is Level + 1,
  nestedSolve(LocalDb, LeftGoal, NextLevel),
  nestedSolve(LocalDb, RightGoal, NextLevel).


nestedSolve(LocalDb, LocalGoal, Level) :-
  findRule(LocalDb, LocalGoal, RuleBody),
  !,

  printLevel(Level),
  format("Solving local goal: ~w...~n", [LocalGoal]),

  NextLevel is Level + 1,
  nestedSolve(LocalDb, RuleBody, NextLevel).


nestedSolve(_, GlobalGoal, Level) :-
  printLevel(Level),
  format("Solving global goal: ~w...~n", [GlobalGoal]),
  catch(GlobalGoal, _, fail).


printLevel(0) :- !.

printLevel(Level) :-
  write("   "),
  PreviousLevel is Level - 1,
  printLevel(PreviousLevel).



:- begin_tests(nestedSolve).

test(solveTrue) :-
  nestedSolve(_, true).


test(solveLocalGoal) :-
  nestedSolve(
    [
      p(16) :- true
    ],

    p(16)
  ).


test(solveGlobalGoal) :-
  nestedSolve(_, 57 =:= 50 + 7).

test(solveAnd) :-
  nestedSolve(
    [
      p(16) :- true,
      q(_) :- true
    ],

    (p(16), q(30))
  ).

:- end_tests(nestedSolve).
