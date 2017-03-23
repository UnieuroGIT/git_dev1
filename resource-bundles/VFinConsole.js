/* 01/2017 Matteo Facchini
 * N.B. heavy use of function callbacks is needed because of the asynchronous execution of the salesforce toolkit methods
*/
function afterSave(caseID){

	//If we are not in the salesforce console, then we simply refresh the page loading the new case ID
	if(!sforce.console.isInConsole())
		window.open('/' + caseID);
	
	// If we are in the salesforce console, then we refresh or recreate the primary tab along with its subtabs
	sforce.console.getEnclosingPrimaryTabId(getSubTabList);

	// retrieving the list of the open subtab ids in the current primary tab
	function getSubTabList(PrimaryTabRequestResult){
		PrimaryTabID = PrimaryTabRequestResult.id;
		sforce.console.getSubtabIds(PrimaryTabRequestResult.id, getCurrentSubTab);
	}

	// retrieving the current subtab id, that is the subtab containing the Save button
	function getCurrentSubTab(SubTabListRequestResult){
		SubTabList = SubTabListRequestResult.ids;
		console.log('CCCC: ' + SubTabList);
		sforce.console.getFocusedSubtabId(getFirstSubtabInfo);
	}

	// retrieving first subtab information
	function getFirstSubtabInfo(FocusedSubTabResult){
		FocusedSubtabID = FocusedSubTabResult.id;

		sforce.console.getPageInfo(FocusedSubTabResult.id, 
			function(PageInfoResult){
				// retrieving the salesforce URL of the first subtab as a global variable
				var FirstSubtabInfo = JSON.parse(PageInfoResult.pageInfo);
				FirstSubtabSForceURL = FirstSubtabInfo.url;
				var FirstSubtabPartialURL = FirstSubtabSForceURL.slice(FirstSubtabSForceURL.indexOf('/500/e'));

				// If we are in Edit mode, then the FirstSubtabSForceURL == '/' + caseID and we need to refresh the page
				// Else we are in New Case mode and we need to proceed
				if(FirstSubtabSForceURL == '/500/e'){	
					console.log('CREATING NEW CASE');
					console.log('FIRST SUBTAB URL IS: ' + FirstSubtabSForceURL);
					CleanSubTabList(FocusedSubTabResult);
				}					
				else{
					console.log('FIRST SUBTAB URL IS: ' + FirstSubtabSForceURL);
					console.log('EDITING EXISTING CASE. THE CONTROLLER EXTENSION DOES EVERYTHING');
				}
			});
	}
	
	// removing the current subtab id from the subtab list and opening a new primary tab pointing to the case detail page
	function CleanSubTabList(CurrentSubTabRequestResult){

		// removing current subtab id from the list
		var indexToRemove = SubTabList.indexOf(FocusedSubtabID);
		SubTabList.splice(indexToRemove,1);
		Length = SubTabList.length;
		index = 0;

		// If we have at least another subtab
		if(Length != 0){
			console.log('RRRRRR: ' + Length);
			sforce.console.openPrimaryTab(null, '/' + caseID, true, undefined, openSubTabs);
		}
		else{
			console.log('RRRRRR: ' + Length);
			sforce.console.openPrimaryTab(PrimaryTabID, '/' + caseID, true, undefined);
			
		}
		

	}

	// function that loops on the subtab list to reopen each subtab in the new primary tab
	// at the end of the execution, the starting primary tab is closed
	function openSubTabs(PrimaryTabResponse){
		
		if(index < Length){
			// page info structure containing information about the subtab urls
			sforce.console.getPageInfo(SubTabList[index],
				function reOpenSubTab(result){
					var pInfo = JSON.parse(result.pageInfo);
					
					if(pInfo.objectId != undefined){
						sforce.console.openSubtab(PrimaryTabResponse.id, '/' + pInfo.objectId, true, undefined, null);
					}
					else{
						var urlString = pInfo.url;
						var urlSubString = urlString.slice(urlString.indexOf('com') + 3);
						sforce.console.openSubtab(PrimaryTabResponse.id, urlSubString , true, undefined, null);
					}

					index = index + 1;
					return openSubTabs(PrimaryTabResponse);
				});
		}else{
			sforce.console.closeTab(PrimaryTabID);
		}
	}
}

function afterCancel(){

	// If we are in the console, then we close the current tab
	if(sforce.console.isInConsole()){
		sforce.console.getEnclosingTabId(closeCurrentTAB);

		function closeCurrentTAB(result){
			sforce.console.closeTab(result.id);
		}

	}//If we are not in the salesforce console, then we return to the previous page
	else{
		window.history.back();
	}
}