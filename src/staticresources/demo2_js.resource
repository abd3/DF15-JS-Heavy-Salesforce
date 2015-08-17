// JavaScript to make Remote Objects calls
var retrieveAccounts = function(){
  console.log('Retrieving accounts');
  var acctDiv = document.getElementById("accountList");

  // Create a new Remote Object
  var acct = new SObjectModel.acct_jsShorthand();

  // Use the Remote Object to query for account records
  acct.retrieve({ limit: 100 }, function(err, records, event){
    var htmlString=getDataTablePre();
    acctDiv.innerHTML='';

    if(err) {
      alert(err.message);
    }
    else {
      records.forEach(function(record) {
        htmlString += '<tr><td><input type="checkbox" value="'+  record.get("Id") +'"/></td>';
        htmlString +='<td>'+record.get("Name")+'</td>';
        htmlString +='<td>'+record.get("Website")+'</td>';
        htmlString +='<td>'+record.get("Id")+'</td>';
        htmlString +='<td>'+record.get("Site")+'</td>';
        htmlString +='<td>'+record.get("CreatedDate")+'</td>';
        htmlString +='</tr>';

      });
    }
    htmlString+='</tbody></table>';
    acctDiv.innerHTML=htmlString;
    $('#remoteObjectsTable').DataTable({"iDisplayLength": 50});

  });
};

function createAccount(){
  console.log('Creating account');
  var acctDetails = { Name: document.getElementById('acctName').value , Website: document.getElementById('acctWebsite').value };

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
  console.log('Deleting account');
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

function updateAccounts(){
  console.log('Updating account');
  //bulk updates are uniform
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
          retrieveAccounts();
          console.log(ids.length + ' record(s) updated.');
        }
    });
  }
  else console.log('nothing to update');
}

function getSelectedAccounts(){
  var checkedIds = $('input:checkbox:checked').map(function() {
    return this.value;
  }).get();
  return checkedIds;
}

function getDataTablePre(){
  var fields ='      <tr>';
    fields+='        <th>&nbsp;</th>';
    fields+='        <th>Name</th>';
    fields+='        <th>Website</th>';
    fields+='        <th>Id</th>';
    fields+='        <th>Site</th>';
    fields+='        <th>Created Date</th>';
    fields+='      </tr>';

  var returnString ='<table id="remoteObjectsTable" class="display" cellspacing="0" width="100%">';
    returnString+='    <thead>';
    returnString+=     fields;
    returnString+='    </thead>';
    returnString+='    <tfoot>';
    returnString+=     fields;
    returnString+='    </tfoot>';
    returnString+='    <tbody>';
  return returnString;
}