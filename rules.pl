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
 * buildLocalDb(ListOfRulesAsStrings, LocalDb)
 *
 * If Rules is a list of strings expressing facts and rules in Prolog syntax, LocalDb is a list
 * of :-(Head, Body) predicates.
 *
 * For example, the list of rules could be:
 *
 * [
 *  "p(9).",
 *  "q(_)",
 *  "r(X) :- 0 is (X mod 2).",
 *  "z(X, Y) :- (p(X), q(Y), r(X))"
 * ]
 * ]
 *
 * The dot at the end of a rule is optional, but the parentheses around the body
 * are MANDATORY in case of 2 or more atoms.
 */
buildLocalDb(Rules, LocalDb) :- buildLocalDb(Rules, [], LocalDb).

buildLocalDb([], AccIn, AccOut) :- reverse(AccIn, AccOut).

buildLocalDb([Head | Tail], AccIn, AccOut) :-
  term_string(HeadAsAtom, Head),
  convertRule(HeadAsAtom, Rule),
  NextAccIn = [Rule|AccIn],
  buildLocalDb(Tail, NextAccIn, AccOut).


:- begin_tests(buildLocalDb).

test(buildEmptyDb) :-
  buildLocalDb([], []).


test(buildDbWithOneFact) :-
  buildLocalDb(
    ["p(8)"],
    [p(8) :- true]
  ).


test(buildDbWithOneRule) :-
  buildLocalDb(
    ["z(X, Y) :- (p(X), q(Y), r(X))"],
    [z(X, Y) :- (p(X), q(Y), r(X))]
  ).


test(buildDbWithFactsAndRules) :-
    buildLocalDb(
      [
        "p(9).",
        "q(_)",
        "r(X) :- 0 is (X mod 2).",
        "z(X, Y) :- (p(X), q(Y), r(X))"
      ],

      [
        p(9) :- true,
        q(_) :- true,
        r(X) :- (0 is (X mod 2)),
        z(X, Y) :- (p(X), q(Y), r(X))
      ]
    ).

:- end_tests(buildLocalDb).

/**
 * convertRule(RuleAtom, Rule)
 *
 * Converts a rule to its suitable :-(Head, Body) format used by meta-interpreters
 */
convertRule(
  :-(Head, Body),
  :-(Head, Body)
) :- !.

convertRule(
  Head,
  :-(Head, true)
).



:- begin_tests(convertRule).

test(convertFact) :-
  convertRule(
    p(6),
    p(6) :- true
  ).


test(convertRule) :-
  convertRule(
    p(X) :- X > 7,
    p(X) :- X > 7
  ).

:- end_tests(convertRule).


/**
 * findRule(LocalDb, RuleHead, RuleBody)
 *
 * Searches the given LocalDb for the requested :-(RuleHead, RuleBody) rule.
 */
findRule([FirstDbRule | _], RuleHead, RuleBody) :-
  FirstDbRule = :-(RuleHead, RuleBody).


findRule([_ | DbTail], RuleHead, RuleBody) :-
  findRule(DbTail, RuleHead, RuleBody).



:- begin_tests(findRule).

test(searchEmptyDb, [fail]) :-
  findRule(
    [],

    p(43), _
  ).


test(searchForFact, [nondet]) :-
  findRule(
    [
      q(80) :- true,
      p(10) :- true
    ],

    p(10), true
  ).

test(searchForRule, [nondet]) :-
  findRule(
    [
      q(80) :- true,
      p(X) :- X > 100
    ],

    p(X), X > 100
  ).

:- end_tests(findRule).
