var demo1Controller = demo1Controller || {};
demo1Controller.asynchronousMethod = demo1Controller.asynchronousMethod || function() {};
var globalVariables = "Should be avoided!";
// But do create a namespace variable and define the data
// If myApp already exists, use that. Otherwise, create myApp as an empty global "namespace" object
var myApp = myApp || {};

// This is called an IIFE ("Immediately-invoked Function Expression")
// This best practice ensures that any variables declared within it
// are not part of the global scope but are within a function-local scope
(function() {
  // Variable scoping:
  // There are about 950+ global variables aleady defined in a typical Salesforce install.
  var locallyScopedVariables = "Are easier to work with in the debugger" +
    "and don't run the risk of any namespace conflicts";
  // The following variable names are all among the 950 that would cause problems if you
  // tried to use them in the global scope:
  var toolbar, top, status, pick, parent, org, ns, name;

  myApp.characteristic = "Properties are defined like this";

  myApp.behavior = function() {
    console.log("Methods are defined like this");
  };

//   var deep = "deep";
//   myApp.scopeDemo = function() {
//     var deeper = "deeper";
//     // Local scope demo:
//     function localFunction() {
//       var deeperStill = "deeper still";
//       console.log("%s, %s, and %s variables are in the execution context here.",
//         deep, deeper, deeperStill);

//       // Asynchronous demo:
//       var callback = function() {
//         console.log("But asynchronous routines still have access to %s, %s, and %s variables",
//           deep, deeper, deeperStill);
//       };
//       demo1Controller.asynchronousMethod(callback);

//       // Closure demo:
//       // myApp.closureDemo = function() {
//       //   console.log("Closures give access to %s, %s, and %s variables that are in *Lexical Scope*.",
//       //     deep, deeper, deeperStill);
//       // };
//       console.log("Execution of localFunction has ended.");
//     }
//     localFunction();
//   };
}());


var globalVars = "global variables";
myApp.scopeDemo = function(privateParams) {
  var localVars = "local variables", privateVars = "private variables";
  console.log("All functions have access to %s and %s.", localVars, globalVars);
  myApp.closureDemo = function() {
    console.log("But functions nested inside of other functions have access to *%s* and *%s* " +
                "from the functions that enclose them, even if they are called from " +
                "somewhere else and the enclosing functions have finished executing.",
                privateParams, privateVars);
    console.log("%c(Time since the enclosing function's execution ended: %s seconds.)",
                "color: rgb(66, 129, 235);", (new Date().getTime() - startTime)/1000);
  };
  console.log("%cExecution of the enclosing function has ended.", "background-color: pink;");
  var startTime = new Date().getTime();
};
myApp.scopeDemo("private parameters");

if(typeof privateVars === "undefined" && typeof privateParams === "undefined") {
  console.log("A function's private variables and parameters are not accessible from outside.");
}
setTimeout(myApp.closureDemo, 10000);



var parallelRequestFailed = function() {};
var doTheNextThing = function() {};
var handleFailureGracefully = function() {};
request1 = $.Deferred();
request2 = $.Deferred();
var sendParallelRequests = $.when(request1, request2)
                            .done(function(response1, response2) {
                              // Process Parallel Responses
                            })
                            .fail(parallelRequestFailed);
var urlRequest = $.ajax({
  url: "/apex/Demo1_JavascriptConcepts.page"
})
.done(sendParallelRequests)
.done(doTheNextThing)
.fail(handleFailureGracefully);


var thingy, thingamabob, myvar = 15, tempVar;
var moreVars, lotsaVars, endlessVars, globalScopeGetsFullOfJunk = true;
// The following variable names are all among the 950 that would cause problems if you
// tried to use them in the global scope:
// var toolbar, top, status, pick, parent, org, ns, name;

function showSnippet() {
  var snippetText = myApp.jsDemo.snippet[this.value];
  $("#jsDemoCode").text(snippetText);
  console.clear();
  console.log("%c" + snippetText, "color: blue;");
  // Using eval indirectly, with an alias, forces code to run in global scope
  var globalEval = eval;
  console.log(globalEval(snippetText));
  // Also execute any global functions directly
  if(snippetText.match(/^[a-zA-Z_]*$/) && window[snippetText]) {
    globalEval(window[snippetText]());
  }
}

function initializeHandlers() {
  $snippetSelector = $("#snippet");
  $snippetSelector.prop("size", this.snippet.length);
  this.snippet.forEach(function(snippetText, index) {
    $snippetSelector
      .append($("<option>", { value: index, text: snippetText }));
  });
  $snippetSelector.change(this.showSnippet);
}
