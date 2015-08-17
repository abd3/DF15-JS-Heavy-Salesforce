var assert = chai.assert;
var expect = chai.expect;

// This object is set in the VisualForce based on the controller and so has to be mocked here:
var controller = {
  variable: 'Some variable from the controller',
  list: ['Some', 'List', 'Values'],
  integerMap: {1: 'One'},
  complexObject: {}
};

describe("Demo3 Test Suite: ", function() {
  describe("controller-binding demonstration", function() {

  });

  describe("logging functions", function() {
    it("should allow us to add logs", function() {
      var testString = "Test string";
      demo3.addToLog("First entry");
      demo3.addToLog(testString);
      demo3.addToLog("Third entry");
      var logResults = demo3.dumpLogs();
      console.log(logResults);
      assert.include(logResults, testString, "the log contains our message");
    });

    it("should not allow us to add logs endlessly", function() {
      var loggingSucceeds, attempts = 0;
      var tooMany = 100, wayTooMany = 500;
      do {
        loggingSucceeds = demo3.addToLog("Some test log");
        attempts++;
      } while (loggingSucceeds && attempts < wayTooMany);
      assert.isBelow(attempts, tooMany, "logging was prevented before too many were added");
    });
  });
});