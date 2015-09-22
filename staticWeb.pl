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

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).

:- http_handler(root(.), http_reply_from_files("./web", []), [prefix]).

/*
 * startWebSolver(Port)
 *
 * Starts a web server on the given Port of localhost
 */
startWebSolver(Port) :-
  http_server(http_dispatch, [port(Port)]).


/*
 * startWebSolver
 *
 * Starts the server on a default port
 */
 startWebSolver :-
   startWebSolver(7000).
