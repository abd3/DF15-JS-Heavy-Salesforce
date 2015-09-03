var assert = chai.assert;
var expect = chai.expect;

describe("Demo2 Test Suite: ", function() {
  // Disable timeouts for testing purposes
  this.timeout(0);
  describe("retrieve accounts", function() {
    console.log('Testing account retrieval.');
    // Because these unit tests don't have access to the DOM we actually need to
    // mock up the DOM by creating page elements equivalent to those we'll be inspecting
    var $acctDiv = $('<div>', {id: "accountList", style: "display: none;"});
    $('body').append($acctDiv);

    before(function() {
      // These unit tests also don't have access to Visualforce-specific functionality
      // like Remote Objects. We therefore need to mock up the the Javascript
      // that is created by VisualForce. A mocking tool like Sinon is indispensable for this.
      // In this way our unit tests are truly independent tests of the Javascript code.
      var successResponse = {};
      sinon.stub(SObjectModel.acct_jsShorthand.prototype, 'retrieve');
      // Stub the alert method so that it doesn't pop while running tests
      sinon.stub(window, "alert", function(message) {
        console.log(message);
      });
    });

    it("should allow us to retrieve accounts", function() {
      var testId = "1234";
      var testAccount = "Test Account";
      // Define the return values for the remote object
      // The return values are actually arrays of functions that give access to data stored in private variables
      var record = {
        get: function(){}
      };
      sinon.stub(record, "get");
      record.get.withArgs("Id").returns(testId);
      record.get.withArgs("Name").returns(testAccount);
      record.get.withArgs("Site").returns("Test Site");
      record.get.withArgs("LastModifiedDate").returns("Wed Sep 02 2015 20:18:51 GMT-0400 (EDT)");
      var records = [record];
      // Force the method to bypass the call to Salesforce and just execute the callback
      SObjectModel.acct_jsShorthand.prototype.retrieve.yields(null, records, null);
      retrieveAccounts();
      assert.equal($acctDiv.find(".chkbox").first().val(), testId);
    });

    it("should handle retrieval errors", function() {
      var err = {message: "There was an error"};
      // Force the method to bypass the call to Salesforce and just execute the callback
      SObjectModel.acct_jsShorthand.prototype.retrieve.yields(err, null, null);
      retrieveAccounts();
      assert(alert.calledOnce, "The error handler was not called");
    });

    after(function() {
      SObjectModel.acct_jsShorthand.prototype.retrieve.restore();
      alert.restore();
    });
  });

  describe("update accounts", function() {
    before(function() {
      var successResponse = {};
      sinon.stub(SObjectModel.acct_jsShorthand.prototype, 'update', function() {
        return successResponse; });
    });

    it("should allow us to update an account", function() {

    });

    after(function() {
      SObjectModel.acct_jsShorthand.prototype.update.restore();
    });
  });

  describe("create accounts", function() {
    before(function() {
      var successResponse = {};
      sinon.stub(SObjectModel.acct_jsShorthand.prototype, 'create', function() {
        return successResponse; });
    });

    it("should allow us to create an account", function() {

    });

    after(function() {
      SObjectModel.acct_jsShorthand.prototype.create.restore();
    });
  });

  describe("delete accounts", function() {
    before(function() {
      var successResponse = {};
      sinon.stub(SObjectModel.acct_jsShorthand.prototype, 'del', function() {
        return successResponse; });
    });

    it("should allow us to delete an account", function() {

    });

    after(function() {
      SObjectModel.acct_jsShorthand.prototype.del.restore();
    });
  });
});