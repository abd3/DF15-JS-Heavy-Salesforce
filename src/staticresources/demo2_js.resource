// JavaScript to make Remote Objects calls
var retrieveAccounts = function(){
  console.log('Retrieving accounts by Remote Objects');
  var acctDiv = document.getElementById("accountList");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();

  var processRetrievedRecords = function(err, records, event){
    console.log('Executing a callback routine.');
    if (acctDiv) {
      console.log('Because of closures, the callback routine still has access to variables that are in lexical scope.');
      setTimeout(function() {
        if(acctDiv) {
          console.log('Even callbacks called from callbacks still have access to variables that are in lexical scope.');
        }
      }, 3000);
    }
    var htmlString=getDataTablePre();
    acctDiv.innerHTML='';

    if(err) {
      alert(err.message);
    }
    else {
      var tabIndex=1;

      records.forEach(function(record) {
        htmlString += '<tr id="tr_'+record.get("Id")+'""><td><input type="checkbox" class="chkbox" value="'+  record.get("Id") +'"/></td>';
        htmlString +='<td><a href="/apex/Demo2_detail?id='+record.get("Id")+'" target="_blank">'+record.get("Name")+'</a></td>';
        htmlString +='<td><input type="text" tabindex='+ tabIndex++ +' value="'+record.get("Site")+'" id="Site_'+record.get("Id")+'"/></td>';
        htmlString +='<td> '+ getDisplayDate(record.get("LastModifiedDate"))+'</td>';
        htmlString +='</tr>';
      });
    }
    htmlString+='</tbody></table>';

    acctDiv.innerHTML=htmlString;

    $('#remoteObjectsTable').DataTable({
           // "iDisplayLength": 50,
            "bPaginate": false,
            "bFilter": false});
    setCheck();
  };
  // Use the Remote Object to query for account records
  acct.retrieve({
        where: {
          Site: {ne: 'Remote'}
        },
        orderby: [ {Name: 'DESC'} ],
        limit: 100
    }, processRetrievedRecords);
  console.log("Execution of the retrieve command has finished.");
};





function updateAccountsWithRemoteObjects(){
  //bulk updates are uniform from Remote Objects. can only have one value for all records that are being updated.
  console.log('Updating account(s) by Remote Objects');
  var newSiteValue = document.getElementById('newSiteValue').value;
  var acctsToUpdate = [];

  if(newSiteValue.length > 0)
    acctsToUpdate = getSelectedAccounts();

  if (acctsToUpdate.length > 0){
    var acct = new SObjectModel.acct_jsShorthand();
    acct.update(
      acctsToUpdate,
      { Site: newSiteValue},
      function(err, ids) {
        if (err) {
          console.log(err);
        } else {
          // Reload the contacts with current list
          console.log('Account(s) updated');
          retrieveAccounts();
        }
    });
  }
  else console.log('nothing to update');
}




function updateAccountsWithJavaScriptRemoting(){
  console.log('Updating account(s) by JavaScript Remoting');
  var acctArray = [];

  var records = getSelectedAccounts();
  //console.log(records);

  records.forEach(function(record) {
    var acct = {};
    acct.Id = record;
    acct.Site = document.getElementById('Site_'+record).value;
    acctArray.push(acct);
  });

  var acctJSONstr = JSON.stringify(acctArray);

  var afterUpdatingAccounts = function(result, event){
    console.log(event);
    if (event.status) {
      console.log(result.toString());
      console.log('Account(s) updated');
      retrieveAccounts();
    } else if (event.type === 'exception') {
      console.log(event.message + "-" + event.where);
    } else {
      console.log(event.message);
    }
  };
  demo2_remoter.updateAccounts(acctJSONstr, afterUpdatingAccounts);
}







function createAccount(){
  console.log('Creating account');
  var acctDetails = { Name: document.getElementById('acctName').value , Site: document.getElementById('acctSite').value };

  // Call create() on an empty account model, passing in field values
  var acct = new SObjectModel.acct_jsShorthand();
  acct.create(acctDetails, function(err) {
    if(err) {
      console.log(err);
      alert(err.message);
    }
    else {
      console.log(acct.log());
      console.log(acct.get('Id'));
    }
  });
  retrieveAccounts();
}

function deleteAccounts(){
  console.log('Deleting Account(s) by Remote Objects');
  vals = getSelectedAccounts();
  if(vals.length>0){
    var acct = new SObjectModel.acct_jsShorthand(vals);
    acct.del(vals, function(err) {
    if (err)
      console.log(err);
    else
      console.log('deleted');
      retrieveAccounts();
    });
  }
  else{
    console.log('nothing to delete');
  }
}


function getSelectedAccounts(){
  var checkedIds = $('input:checkbox:checked').map(function() {
    if (this.value !== 'on'){ //don't return the select all checkbox
      return this.value;
    }
  }).get();
  return checkedIds;
}

function getDisplayDate(inDate){
  inDate=inDate+'';
  var pieces = inDate.split(' ');
  return pieces[1] +' '+ pieces[2] +' @'+ pieces[4];
}

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

function setCheck(){
//check or uncheck all
$(document).ready(function(){
    $('#selectAll').on('click',function(){
        if ($(this).is(':checked')) {
            $('.chkbox').each(function(){
                //console.log(this);
                this.checked = true;
            });
        }else{
            $('.chkbox').each(function(){
                this.checked = false;
            });
        }
    });
});
}

$(window).load(function() {
  console.clear();
});







