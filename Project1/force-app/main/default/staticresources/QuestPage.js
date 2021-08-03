// @created by: Zackary Frazier
// @last modified project: Project 1
// @desc : collection of utilites for QuestPage
// @note : really this should be a util class and a quest page class
//       : as some of these methods are used throughout the pages 


// @desc 		: insert an HTML string to an element's child given an id
// @id   		: <string> the id of the element this will be attached to
// @HTMLString  : <string> a string of HTML to be appended
// @index       : <number> the ith child element that this element is placed in front of
function insertBefore(id, HTMLString, index=0) {
    const parentElem = document.querySelector('#' + id);
    
    if(parentElem) {
        const divElem = document.createElement("DIV");
    	divElem.innerHTML = HTMLString;
    	parentElem.insertBefore(divElem, parentElem.children[index]);
    } else {
        throw new Error("Insert before: no element was found with id of " + id);
    }
}

// @desc  : hide a modal given its id
// @event : <event>
// @id    : <string>
function hideModal(event, id) {
    event?.preventDefault();
    document
    	.querySelector("#" + id)
    	.style
    	.display = 'none';
}

// @desc    : set a modal to visible given its id
// @event   : <event>
// @id      : <string>
function showModal(event, id) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    elem.style.display = 'initial';
}
    
// @desc    : display an error modal with a message
// @event   : <event>
// @id      : <string>
// @message : <string> message to be displayed on the modal 
function showErrorModal(event, id, message) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    const content = elem.querySelector("#prompt-message-wrapper");
    content.innerText = message;
    elem.style.display='initial';
}
    
// @desc  : because VF is weird, need a special function for this error modal
// @event : <event>
// @id    : <string>
function hideErrorModal(event, id) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    const content = elem.querySelector("#prompt-message-wrapper");
    content.innerText = '';
    elem.style.display='none';
}
    
// @desc       : retrieve the parameters, save a new quest
// @event      : <event>
// @actionFunc : <func> the action function to save a quest
function submitNewQuest(event, actionFunc) {
    event?.preventDefault();
    const data = Object.fromEntries(new FormData(event.target).entries());
    
    // set the checkbox variables
    ['Requires Party', 'Required Profession: Adventurer', 'Required Profession: Craftsman']
    .forEach(field => data[field] = (data[field] !== undefined));
    data['Reward'] = Number(data['Reward']);
	
    actionFunc(
        data['Quest Name'],
        data['Quest Details'],
        data['Location'],
        data['Requires Party'],
        data['Danger Level'],
        data['Required Profession: Adventurer'],
        data['Required Profession: Craftsman'],
        data['Reward'],
        data['Email']
    );
}

// @desc : if the submit new quest succeeds, you'll be redirected. If it fails, you'll see an error modal
function onCompleteSaveQuest() {
    showErrorModal(null, 'dynamic-error-modal', 'Something went wrong. Double-check your submission and try again.');
    hideModal(null, 'new-quest-modal');
}

// @desc: passes the assignee email value to the action function to assign a quest
// @event: <event>
// @actionFunc: <func>
function handleNewAssignment(event, actionFunc) {
    event?.preventDefault();
    const data = Object.fromEntries(new FormData(event.target).entries());
    
    actionFunc(data['Assignee Email']);
}

// @desc: oncomplete handler for assigning guild members to quests
//      : triggers a modal when the assignment fails
function onCompleteHandleNewAssignment() {
	showErrorModal(null, 'dynamic-error-modal', 'Unable to approve user for this quest, it may have already been accepted.');
}
    
// @desc : onclick event handler, clicks first child of event
// @event: <event>
function clickFirstChild(event) {
    event.target.children[0].click();
}