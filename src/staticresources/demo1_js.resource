var demo1Controller = demo1Controller || {};
demo1Controller.asynchronousMethod = demo1Controller.asynchronousMethod || function() {};
// But do create a namespace variable and define the data
// If myApp already exists, use that. Otherwise, create myApp as an empty global "namespace" object
var myApp = myApp || {};

myApp.jsDemo = {
  selected: 0,
  showSnippet: function() {
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
  },
  initializeHandlers: function() {
    $snippetSelector = $("#snippet");
    $snippetSelector.prop("size", this.snippet.length);
    this.snippet.forEach(function(snippetText, index) {
      $snippetSelector
        .append($("<option>", { value: index, text: snippetText }));
    });
    $snippetSelector.change(this.showSnippet);
  }
};

var style = {
  synchronous: 'color: darkgrey;',
  async: 'color:darkblue;',
  success: 'color: green; margin-left: 20px;',
  error: 'color: red; margin-left: 20px;'
};

/* Without using Closures */
var asyncFunction = function() {
  console.log('%cAsync code: Executing a nested callback routine.', style.async);
  if(typeof acctDiv !== "undefined") {
    console.log('%cEven nested callbacks still have access to variables that are in lexical scope thanks to closures.', style.success);
  } else {
    console.log("%cWe can execute global callbacks but they don't have access to our local variables", style.error);
  }
};

var processRetrievedRecords = function(err, records, event){
  console.log('%cAsync code: Executing a callback routine.', style.async);
  if(typeof acctDiv !== "undefined") {
    console.log('%cBecause of closures, the callback routine still has access to variables that are in lexical scope.', style.success);
    setTimeout(asyncFunction, 1000);
  } else {
    console.log("%cWe can execute global callbacks but they don't have access to our local variables", style.error);
  }
};

var retrieveAccounts = function(){
  console.log("var processRetrievedRecords = ", processRetrievedRecords);
  console.log("var asyncFunction = ", asyncFunction);
  console.log('%cSynchronous Code: Retrieving accounts by Remote Objects', style.synchronous);
  var acctDiv = $("[id $= accountList]");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();
  // Use the Remote Object to query for account records
  acct.retrieve({limit: 100}, processRetrievedRecords);
  console.log("%cSynchronous Code: Execution of the retrieve command has finished.", style.synchronous);
};




/* Using Closures */

var retrieveAccountsClosures = function(){
  console.log('%cSynchronous Code: Retrieving accounts by Remote Objects', style.synchronous);
  var acctDiv = $("[id $= accountList]");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();
  var processRetrievedRecords = function(err, records, event){
    var localVar = "Async code: Executing a callback routine.";
    console.log('%c' + localVar, style.async);
    function asyncFunction() {
      var nestedVar = "Async code: Executing a nested callback routine.";
      console.log('%c' + nestedVar, style.async);
      debugger;
      if(acctDiv) {
        console.log('%cEven nested callbacks still have access to variables that are in lexical scope thanks to closures.', style.success);
      }
    }
    debugger;
    if(acctDiv) {
      console.log('%cBecause of closures, the callback routine still has access to variables that are in lexical scope.', style.success);
      setTimeout(asyncFunction, 1000);
    }
  };
  // Use the Remote Object to query for account records
  acct.retrieve({limit: 100}, processRetrievedRecords);
  console.log("%cSynchronous Code: Execution of the retrieve command has finished.", style.synchronous);
};


/* jshint ignore:start */
myApp.jsDemo.snippet = [
`document.getElementById("someImage")`,
`$("#someImage").hide()`,
`$("[id $= someImage]").hide()`,
`$("[id $= someImage]").show()`,
`var acct = new SObjectModel.acct_jsShorthand();
acct`,
`if (acct && acct.retrieve) {
  console.log(acct.retrieve);
}`,
`acct.retrieve({ limit: 100 }, function(err, records, event){
  var htmlString=getDataTablePre();
  if(err) {
    alert(err.message);
  }
  else {
  }
})`,
`retrieveAccounts`,
`retrieveAccountsClosures`
];
/* jshint ignore:end */

$(document).ready(function() {
  console.clear();
  myApp.jsDemo.initializeHandlers();
});

function getDataTablePre(){
  var fields ='      <tr>';
    fields+='        <th><input type="checkbox" id="selectAll"/></th>';
    fields+='        <th>Name</th>';
    fields+='        <th>Site</th>';
    fields+='        <th>Last Modified</th>';
    fields+='      </tr>';

  var returnString ='<table id="remoteObjectsTable" class="display" cellspacing="0" width="100%">';
    returnString+='    <thead>';
    returnString+=     fields;
    returnString+='    </thead>';
    /*returnString+='    <tfoot>';
    returnString+=     fields;
    returnString+='    </tfoot>';*/
    returnString+='    <tbody>';
  return returnString;
}

