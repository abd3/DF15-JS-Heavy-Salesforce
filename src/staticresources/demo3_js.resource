var demo3 = demo3 || {};

demo3.property1 = "Use a single global object as your namespace";
demo3.property2 = "Allows you to unit-test it's methods";
demo3.property3 = "Is encapsulated and therefore promotes better code";
demo3.property4 = "Prevents namespace conflicts and allows you to inspect all your properties and methods in one place";

function usingGlobalVariables() {
  if (globalVariable1.indexOf("careful") > -1) {
    console.log("global variable found");
  }
}
usingGlobalVariables();

function usingControllerBindings(value) {
  if (value) {
    console.log(value);
  }
}
usingControllerBindings(controller.variable);

(function loggingFunctions() {
  // This ""IIFE" notation is a nice way of creating a private memory space in JavaScript
  // Within this space you can include private variables and functions

  var privateLog = [];
  var privateMessageLimit = 10;

  var reachedThreshold = function() {
    return privateLog.length >= privateThreshold;
  };

  // Unit tests can only run on the publicly-exposed parts of this code
  // But if you write them carefully, they can exercise every part of the code
  demo3.addToLog = function(logMessage) {
    if (reachedThreshold) {
      console.log('Sorry, all full!');
      return false;
    } else {
      privateLog.push(logMessage);
      return true;
    }
  };

  demo3.dumpLogs = function() {
    var logContents = privateLog.join('\n');
    privateLog = [];
    return logContents;
  };
})();

