##After you clone take the following steps:

*Make sure you have Node.js installed on your system: https://nodejs.org/

*Run the following command from the root of the salesforce repo in order to install all of the Node packages listed in **package.json**:

```
npm install
```

*Run the following command to start Karma (which was automatically installed in the previous step):

```
./node_modules/karma/bin/karma start karma.conf.js
```

##Autowatch
By default, our **karma.conf.js** file (the main Karma config file) is set up to autowatch the files listed in it. By using autowatch, Karma will run the tests anytime you save a change to the files listed in the config.  This is awesome.  The Jenkins CI job overrides this setting at the command line by using the --single-run parameter.  **Use autowatch.  It is awesome.**

##Adding Files for Testing
In order for Karma to pick up new files, you need to make sure they are included in the **files** array inside of the Karma config file.  Add any new JavaScript files to this array or they will not be included in the test run.  Make sure you add the file you are testing and the file that contains the unit tests.

##Code Coverage Reports
An html report is written to **reports/coverage/lcov-report/index.html**.

A file is also output in the lcov format accepted by Sonar:
reports/coverage/lcov.info

##Troubleshooting in the Browser
You can also load this file in any browser to execute tests: **test/index.html**

This is helpful when you want to debug your code in the browser's console. Make sure you update the **index.html** file with any new JS files you need for debugging.

Alternately, you can change the **browsers** setting in the **karma.conf.js** file to use "Chrome".  Then, when you run Karma again, it will launch Chrome when it runs the tests.  You can then debug from the console.

##Sinon.js Library
We use the sinon.js library to mock and stub functions.  The is an incredibly important thing for writing good unit tests. Sinon allows you to create a mocked version of a function and define exactly how this mocked version behaves.

##Note:
1. You may have to 'export PHANTOMJS_BIN=<path to phantomjs>'
    * I tried adding the phantomjs node_module and exporting the location of that bin. It worked a few times then started failing to load phantomjs

