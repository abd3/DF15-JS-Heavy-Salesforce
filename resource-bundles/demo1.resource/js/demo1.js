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

(function() {
  $(document).ready(function() {
    myApp.page = {
      searchTerm: $("#wpSearchTerm"),
      searchButton: $("#wpSearchButton"),
      searchResults: $("#wpSearchResults"),
      resultsTable: $("#wpResultsTable")
    };
    myApp.page.searchButton.click(myApp.wikipedia.search);
    myApp.page.results = myApp.page.resultsTable.DataTable( {
      columns: [
        { data: 'title' },
        { data: 'snippet' }
      ]
    } );
  });

  myApp.wikipedia = {
    baseUrl: "https://en.wikipedia.org/w/api.php?action=query&list=search&utf8=&format=json&srsearch=",
    search: function() {
      var handleSearchError = function(jqXHR, textStatus, errorThrown) {
        console.log('The Wikipedia search encountered an error: %s: %s, %O', textStatus, errorThrown, jqXHR);
      };

      var displaySearchResults = function(data, textStatus, jqXHR) {
        var searchResults = data.query.search;
        console.log('Search results from Wikipedia: %O', searchResults);
        if ( $.fn.dataTable.isDataTable( '#example' ) ) {
          table = $('#example').DataTable();
        }
        else {
          table = $('#example').DataTable( {
            paging: false
          } );
        }

        // if (myApp.page.results.ajax.url()) {
        //   myApp.page.results.ajax.reload();
        // } else {
        //   myApp.page.results.ajax.url(searchResults).load();
        // }

        myApp.wikipedia.results( {
          data: searchResults,
          columns: [
            { data: 'title' },
            { data: 'snippet' }
          ]
        } );
        myApp.page.searchResults.show();
      };

      console.log('Initiating a search');
      searchString = encodeURIComponent(myApp.page.searchTerm.val());
      // This request uses JSONP due to limitations with Wikipedia and cross-origin requests
      // This is not a very secure connection
      $.getJSON(myApp.wikipedia.baseUrl + searchString + "&callback=?")
        .done(displaySearchResults)
        .fail(handleSearchError);
    },

    retrieveExcerpt: function(title) {

    }
  };
}());

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

/* jshint ignore:start */
myApp.jsDemo.snippet = [
`x = 2 + 2;`,
`function upperCase(text) {
  console.log(text.toUpperCase());
}`,
`upperCase('Some String');`,
`myObject = {
  property1: 'Just a string',
  method1: function() {
    console.log('Just a method');
  },
  method2: upperCase
};`,
`myObject.method2('another string');`,
`MyClass = function() {
  this.property1 = "Initialized in the constructor";
};`,
`MyClass.prototype = {
  prototypeProperties: "Are shared by all instances of the class",
  prototypeMethods: function() {
    console.log("Prototype methods are functions that are shared by all members of a class");
  }
};`,
`var myInstance = new MyClass();`,
`var myInstance2 = new MyClass();`,
`myInstance.property1`,
`myInstance.property1 = "something new"`,
`myInstance.prototypeProperties`,
`MyClass.prototype.prototypeProperties = "changed everywhere"`,
`myInstance2.property1`,
`myInstance2.prototypeProperties`,

];
/* jshint ignore:end */

$(document).ready(function() {
  myApp.jsDemo.initializeHandlers();
});
