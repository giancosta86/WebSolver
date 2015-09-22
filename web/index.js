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

var fullRuleRegex = /^\s*([^:]+?)\s*:-\s*(.+?)\s*\.?$/;

$(document).ready(function() {
  $("#rulesArea").val(
    [
      "%",
      "% Empty lines and comment lines will be ignored",
      "%",
      "",
      "p(16).",
      "q(_).",
      "r(X) :- 0 is (X mod 2).",
      "z(X, Y) :- (p(X), q(Y), r(X)).",
    ].join("\n")
  )


  $("#solveButton").click(requestSolution)


  $("#projectButton").click(function() {
    window.open("https://github.com/giancosta86/WebSolver", "_blank")
  })

  $("#authorButton").click(function() {
    window.open("http://gianlucacosta.info/", "_blank")
  })
})


function requestSolution() {
  function encodeSolver() {
    var solver = $.trim($("#solverField").val())

    if (solver === "") {
      alert("The 'Solver' field cannot be left blank")
      $("#solverField").focus()
      return
    }

    return encodeURIComponent(solver)
  }


  function encodeRules() {
    var rulesString = ""

    var lines = $("#rulesArea").val().split("\n")
    for(var i = 0; i < lines.length; i++){
      var line = $.trim(lines[i])

      if (line === "" || line.match("^%")) {
        continue
      }

      var fullRuleMatch = fullRuleRegex.exec(line)

      var rule
      if (fullRuleMatch != null) {
        rule = fullRuleMatch[1] + ' :- (' + fullRuleMatch[2] + ')'
      } else {
        rule = line
      }

      rulesString += "&rule=" + encodeURIComponent(rule)
    }

    return rulesString
  }


  function encodeGoal() {
    var goal = $.trim($("#goalField").val())

    if (goal === "") {
      alert("The 'Goal' field cannot be left blank")
      $("#goalField").focus()
      return
    }

    return encodeURIComponent(goal)
  }


  var encodedSolver = encodeSolver()
  if (encodedSolver === undefined) {
    return
  }

  var rulesString = encodeRules()

  var encodedGoal = encodeGoal()
  if (encodedGoal === undefined) {
    return
  }

  var serviceUrl = "/solve"
  var requestUrl = serviceUrl + "?solver=" + encodedSolver + "&goal=" + encodedGoal + rulesString

  $("#outputArea").val("Waiting for response...")

  $.ajax({
    url: requestUrl
  }).done(function(data) {
    $("#outputArea").val(data)
  }).fail(function(jqXHR, textStatus, errorThrown) {
    $("#outputArea").val("*** ERROR ***\n\n" + errorThrown + "\n\nRequest URL:\n" + requestUrl)
  })
}
