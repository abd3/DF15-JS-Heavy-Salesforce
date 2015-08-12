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
        // if ( $.fn.dataTable.isDataTable( '#example' ) ) {
        //   table = $('#example').DataTable();
        // }
        // else {
        //   table = $('#example').DataTable( {
        //     paging: false
        //   } );
        // }
        debugger;
        if (myApp.page.results.ajax.url()) {
          myApp.page.results.ajax.reload();
        } else {
          myApp.page.results.ajax.url(searchResults).load();
        }

        // myApp.wikipedia.results( {
        //   data: searchResults,
        //   columns: [
        //     { data: 'title' },
        //     { data: 'snippet' }
        //   ]
        // } );
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
