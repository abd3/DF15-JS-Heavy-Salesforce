var demo3 = demo3 || {};
var controller = controller || {};

demo3.property1 = "Use a single global object as your namespace";
demo3.property2 = "Allows you to unit-test it's methods";
demo3.property3 = "Is encapsulated and therefore promotes better code";
demo3.property4 = "Prevents namespace conflicts and allows you to inspect all your properties and methods in one place";

function usingGlobalVariables() {
  if (demo3.property1.indexOf("careful") > -1) {
    console.log("global variable found");
  }
}
usingGlobalVariables();

function showValue(value) {
  if (value) {
    console.log(value);
  }
}
showValue(controller.variable);
if (controller.complexObject && controller.complexObject.areYouKidding.first[2][10].Name) {
  showValue(controller.complexObject.areYouKidding.first[2][10].Name);
}

(function loggingFunctions() {
  // This ""IIFE" notation is a nice way of creating a private memory space in JavaScript
  // Within this space you can include private variables and functions

  var privateLog = [];
  var privateThreshold = 10;

  var reachedThreshold = function() {
    return privateLog.length >= privateThreshold;
  };

  // Unit tests can only run on the publicly-exposed parts of this code
  // But if you write them carefully, they can exercise every part of the code
  demo3.addToLog = function(logMessage) {
    if (reachedThreshold()) {
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

