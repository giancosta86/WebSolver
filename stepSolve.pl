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
 * stepSolve(LocalDb, Goal)
 *
 * Meta-interpreter printing out every resolution step
 */

stepSolve(_, true) :- !.


stepSolve(LocalDb, (LeftGoal, RightGoal)) :-
  !,
  format("Solving conjunction: (~w),(~w)...~n", [LeftGoal, RightGoal]),
  stepSolve(LocalDb, LeftGoal),
  stepSolve(LocalDb, RightGoal).


stepSolve(LocalDb, LocalGoal) :-
  findRule(LocalDb, LocalGoal, RuleBody),
  !,
  format("Solving local goal: ~w...~n", [LocalGoal]),
  stepSolve(LocalDb, RuleBody).


stepSolve(_, GlobalGoal) :-
  format("Solving global goal: ~w...~n", [GlobalGoal]),
  catch(GlobalGoal, _, fail).



:- begin_tests(stepSolve).

test(solveTrue) :-
  stepSolve(_, true).


test(solveLocalGoal) :-
  stepSolve(
    [
      p(16) :- true
    ],

    p(16)
  ).


test(solveGlobalGoal) :-
  stepSolve(_, 57 =:= 50 + 7).


test(solveAnd) :-
  stepSolve(
    [
      p(16) :- true,
      q(_) :- true
    ],

    (p(16), q(30))
  ).

:- end_tests(stepSolve).
