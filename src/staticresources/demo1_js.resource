var demo1Controller = demo1Controller || {};
demo1Controller.asynchronousMethod = demo1Controller.asynchronousMethod || function() {};
var globalVariables = "Should be avoided!";
// But do create a namespace variable and define the data
// If myApp already exists, use that. Otherwise, create myApp as an empty global "namespace" object
var myApp = myApp || {};

// This is called an IIFE ("Immediately-invoked Function Expression")
// This best practice ensures that any variables declared within it
// are not part of the global scope but are within a function-local scope
// (function() {
//   // Variable scoping:
//   // There are about 950+ global variables aleady defined in a typical Salesforce install.
//   var locallyScopedVariables = "Are easier to work with in the debugger" +
//     "and don't run the risk of any namespace conflicts";
//   // The following variable names are all among the 950 that would cause problems if you
//   // tried to use them in the global scope:
//   var toolbar, top, status, pick, parent, org, ns, name;

//   myApp.characteristic = "Properties are defined like this";

//   myApp.behavior = function() {
//     console.log("Methods are defined like this");
//   };

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
//         console.log("Even asynchronous routines have access to %s, %s, and %s variables",
//           deep, deeper, deeperStill);
//       };
//       demo1Controller.asynchronousMethod(callback);

//       // Closure demo:
//       myApp.closureDemo = function() {
//         console.log("Closures give access to %s, %s, and %s variables that are in *Lexical Scope*.",
//           deep, deeper, deeperStill);
//       };
//     }
//     localFunction();
//   };
// }());

// myApp.scopeDemo();

// // Closure demo results:
// demo1Controller.asynchronousMethod(function() {
//   myApp.closureDemo();
//   console.log("Even if that function is executed somewhere completely different");
// });


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

/* Without using Closures */

var asyncFunction = function() {
  var status = 'Executing a nested callback routine.';
  console.log(status);
  if(acctDiv) {
    console.log('Even nested callbacks still have access to variables that are in lexical scope thanks to closures.');
    debugger;
  }
};

var processRetrievedRecords = function(err, records, event){
  var status = 'Executing a callback routine.';
  console.log(status);
  if (acctDiv) {
    console.log('Because of closures, the callback routine still has access to variables that are in lexical scope.');
    setTimeout(asyncFunction, 3000);
  }
};

var retrieveAccounts = function(){
  console.log('Retrieving accounts by Remote Objects');
  var acctDiv = document.getElementById("accountList");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();
  // Use the Remote Object to query for account records
  acct.retrieve({limit: 100}, processRetrievedRecords);
  console.log("Execution of the retrieve command has finished.");
};




/* Using Closures */

var retrieveAccountsClosures = function(){
  console.log('Retrieving accounts by Remote Objects');
  var acctDiv = document.getElementById("accountList");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();
  var processRetrievedRecords = function(err, records, event){
    var status = 'Executing a callback routine.';
    console.log(status);
    if (acctDiv) {
      console.log('Because of closures, the callback routine still has access to variables that are in lexical scope.');
      var asyncFunction = function() {
        var status = 'Executing a nested callback routine.';
        console.log(status);
        if(acctDiv) {
          console.log('Even nested callbacks still have access to variables that are in lexical scope thanks to closures.');
          debugger;
        }
      };
      setTimeout(asyncFunction, 3000);
    }
  };
  // Use the Remote Object to query for account records
  acct.retrieve({limit: 100}, processRetrievedRecords);
  console.log("Execution of the retrieve command has finished.");
};


/* jshint ignore:start */
myApp.jsDemo.snippet = [
`document.getElementById("snippet");`,
`$("#someImage").show();`,
`$("[id $= someImage]").show();`,
`$("[id $= someImage]").hide();`,
`var acct = new SObjectModel.acct_jsShorthand();
acct;`,
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
});`,
`retrieveAccounts;
retrieveAccounts();`,
`retrieveAccountsClosures
retrieveAccountsClosures();`
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

