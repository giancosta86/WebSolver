# WebSolver

*Prolog web architecture for meta-interpreters*


## Introduction

Prolog is an elegant and interesting programming language: it is general-purpose, but it shines in *symbolic manipulation* and *meta-programming*: in particular, Prolog is especially suitable for the creation of *meta-interpreters* - custom interpreters for the language written *in the language itself*.


**WebSolver** is a web infrastructure for interactively testing meta-interpreters running in the beautiful [SWI-Prolog](http://www.swi-prolog.org/) interpreter; WebSolver provides:

* *a RESTful web service* for executing an arbitrary meta-intepreter among the ones available in the current Prolog global environment

* *a web page* where the user can:
  * request a meta-interpreter (predefined or custom)
  * state the rules; blanks lines and comment lines (i.e., starting with *%*) are supported
  * run a query and read the output


* *2 predefined meta-interpreters*, showing their resolution steps. New meta-interpreters can be added just by defining them as procedures having the same arguments as the default meta-interpreters (called **stepSolve** and **nestedSolve**).

* a suite of unit tests, to increase overall robustness.


## Running WebSolver

1. Download [the latest release package](https://github.com/giancosta86/WebSolver/releases/latest) from Github and unpack it.

2. Run [SWI-Prolog](http://www.swi-prolog.org/) and consult all of the Prolog (.pl) files in WebSolver's root directory.

 For example, you could run, on your operating system's command line:

 ```
 cd <WebSolver's directory>
 swipl *.pl
 ```

 If you also want to use a custom meta-interpreter, you could invoke SWI-Prolog as follows:

 ```
 cd <WebSolver's directory>
 swipl *.pl <Your Prolog (.pl) source files>
 ```

3. Now, at SWI-Prolog's shell, type:

 ```
 startWebSolver.
 ```

 This will start the web server on port 7000 of *localhost*; you can also pass a custom port number as a parameter.

4. Open your web browser at [http://localhost:7000](http://localhost:7000) (or at the alternative port that you have chosen).

5. Click the **Solve** button in the web page: the default settings should correctly invoke the predefined metaintepreter and **TRUE** should be the very last line of the output.


To stop the server, just terminate the current SWI-Prolog instance.

Feel free to use WebSolver to test your own meta-interpreters! ^\_\_^


## Creating a meta-interpreter

Meta-interpreters in Prolog are structurally simple and elegant - and WebSolver just applies very few variations to the [vanilla meta-interpreter](http://kti.ms.mff.cuni.cz/~bartak/prolog/meta_interpret.html).

More precisely, the *LocalDb* parameter can be used as a layer above the global environment: it contains all the rules and facts declared for the current request. Of course, legacy meta-interpreters running in a single-user environment can safely ignore such element.

To exactly know the suggested interface that a meta-interpreter should expose in order to be plugged into WebSolver, please refer to the **stepSolve** and **nestedSolve** meta-interpreters (in files *stepSolve.pl* and *nestedSolve.pl*, respectively).


### Local and global environment

* Meta-interpreters should be designed to employ a local database of rules, passed as a parameter, because the global Prolog environment is shared between *different meta-interpreters* and even *different requests*.

* Within a rule, you can still use *assert*, *retract* and the other predicates altering the shared environment - just remember their global effects.


## Unit tests

SWI-Prolog supports [unit testing](http://www.swi-prolog.org/pldoc/package/plunit.html)! And WebSolver comes with a complete suite of tests, for a robust architecture.

If you wish to run them, just type:

```
run_tests.
```

at SWI-Prolog's command line, after consulting WebSolver's Prolog source files.


## Further references

* [SWI-Prolog](http://www.swi-prolog.org/): a modern, elegant open source Prolog environment. From web applications to web services, up to OOP and Semantic Web, SWI-Prolog includes a vast set of useful tools! ^\_\_^

* [Programmazione logica e Prolog](http://www-lia.deis.unibo.it/Books/libro_pl/): a great book for understanding the Logic theory behind Prolog, and an inspiring source for learning the language.
