
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

// @desc: hide a modal given its id
// @id  : <string>
function hideModal(event, id) {
    event?.preventDefault();
    document
    	.querySelector("#" + id)
    	.style
    	.display = 'none';
}

// @desc: set a modal to visible given its id
// @id  : <string>
function showModal(event, id, message) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    elem.style.display = 'initial';
}
    
// @desc: because VF is weird, need a special function for this error modal
function showErrorModal(event, id, message) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    const content = elem.querySelector("#prompt-message-wrapper");
    content.innerText = message;
    elem.style.display='initial';
}
    
// @desc: because VF is weird, need a special function for this error modal
function hideErrorModal(event, id) {
    event?.preventDefault();
    const elem = document.querySelector("#" + id);
    const content = elem.querySelector("#prompt-message-wrapper");
    content.innerText = '';
    elem.style.display='none';
}
    
// @desc       : retrieve the parameters, save a new quest
// @event      : <event>
// @echo       : <func> a function to pass parameters to the action function
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
    
    // success should lead to a redirect, if not, then this modal will pop up
    setTimeout(() => {
    	showErrorModal(null, 'dynamic-error-modal', 'Something went wrong. Double-check your submission and try again.');
    	hideModal(null, 'new-quest-modal');
	}, 5000)
}

// @desc: passes the assignee email value to the action function to assign a quest
// @event: <event>
// @actionFunc: <func>
function handleNewAssignment(event, actionFunc) {
    event?.preventDefault();
    const data = Object.fromEntries(new FormData(event.target).entries());
    
    actionFunc(data['Assignee Email']);
    
    
    // success should lead to a redirect, if not, then this modal will pop up
    setTimeout(() => {
    	showErrorModal(null, 'dynamic-error-modal', 'Unable to approve ' + data['Assignee Email'] + ' for this quest, it may have already been accepted.');
	}, 5000)
}