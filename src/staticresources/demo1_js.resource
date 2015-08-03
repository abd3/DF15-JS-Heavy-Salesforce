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

  var deep = "deep";
  myApp.scopeDemo = function() {
    var deeper = "deeper";

    // Local scope demo:
    function localFunction() {
      var deeperStill = "deeper still";
      console.log("%s, %s, and %s variables are in the execution context here.",
        deep, deeper, deeperStill);

      // Asynchronous demo:
      var callback = function() {
        console.log("Even asynchronous routines have access to %s, %s, and %s variables",
          deep, deeper, deeperStill);
      };
      demo1Controller.asynchronousMethod(callback);

      // Closure demo:
      myApp.closureDemo = function() {
        console.log("Closures give access to %s, %s, and %s variables that are in *Lexical Scope*.",
          deep, deeper, deeperStill);
      };
    }
    localFunction();

  };


}());

myApp.scopeDemo();

// Closure demo results:
demo1Controller.asynchronousMethod(function() {
  myApp.closureDemo();
  console.log("Even if that function is executed somewhere completely different");
});

