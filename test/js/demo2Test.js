var assert = chai.assert;
var expect = chai.expect;
var SObjectModel = {
  acct_jsShorthand: function() {}
};

describe("Demo2 Test Suite: ", function() {
  describe("create accounts", function() {
    before(function() {
      sinon.stub(SObjectModel, 'acct_jsShorthand', function() {});
    });

    it("should allow us to create an account", function() {
      var successResponse = {};

    });

    after(function() {
      SObjectModel.acct_jsShorthand.restore();
    });
  });

  describe("retrieve accounts", function() {
    before(function() {
      // Because these unit tests don't have access to the DOM we actually need to
      // mock up the DOM by creating page elements equivalent to those we'll be inspecting
      var acctDiv = $('<div>', {id: "accountList"});
      $('body').append(acctDiv);
      // These unit tests also don't have access to Visualforce-specific functionality
      // like Remote Objects. We therefore need to mock up the the Javascript
      // that is created by VisualForce. A mocking tool like Sinon is indispensable for this.
      // In this way our unit tests are truly independent tests of the Javascript code.
      sinon.stub(SObjectModel, 'acct_jsShorthand', function() {});
    });

    it("should allow us to retrieve accounts", function() {
      var successResponse = {};

    });

    after(function() {
      SObjectModel.acct_jsShorthand.restore();
    });
  });

  describe("update accounts", function() {
    before(function() {
      sinon.stub(SObjectModel, 'acct_jsShorthand', function() {});
    });

    it("should allow us to update an account", function() {
      var successResponse = {};

    });

    after(function() {
      SObjectModel.acct_jsShorthand.restore();
    });
  });

  describe("delete accounts", function() {
    before(function() {
      sinon.stub(SObjectModel, 'acct_jsShorthand', function() {});
    });

    it("should allow us to delete an account", function() {
      var successResponse = {};

    });

    after(function() {
      SObjectModel.acct_jsShorthand.restore();
    });
  });
});