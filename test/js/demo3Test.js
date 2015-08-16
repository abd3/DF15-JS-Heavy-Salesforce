var assert = chai.assert;
var expect = chai.expect;

describe("Controller-binding Test Suite", function() {
  var
});

describe("Demo3 Test Suite: ", function() {
  describe("Logging functions", function() {
    it("should allow us to add logs", function() {
      var testString = "Test string";
      demo3.addToLog("First entry");
      demo3.addToLog(testString);
      demo3.addToLog("Third entry");
      assert.include(demo3.dumpLogs, testString, "the log contains our message");
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