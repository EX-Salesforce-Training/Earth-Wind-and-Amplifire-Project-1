
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

// @desc : validate the parameters of the form data prior to submitting a new quest
// @note : I hate to do it this way, but Apex makes it so the actionFunction component requires
//       : a reRender component, meaning  I can't use hasError and errorMessage because the page
//       : won't rerender as a whole. It's really awful.
// @data : <object> the form data passed in 
function validateParams(data) {
    if(data['Required Profession: Adventurer'] === false && data['Required Profession: Craftsman'] === false) {
    	return false;
	}
    
    if(data['Quest Name'] === '') {
    	return false;
	}
    
    if(data['Location'] === '') {
    	return false;
	}
    
    if(data['Quest Details'].length < 10) {
    	return false;
	}
    
    const validDangerLevels = ['Certain Death', 'Hard', 'Medium', 'Easy', 'Beginner'];
    if(!validDangerLevels.includes(data['Danger Level'])) {
    	return false;
	}
    
    if(data['Reward'] === NaN || data['Reward'] < 0) {
    	return false;
	}
    
    return true;
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

    if(!validateParams(data)) {
    	showErrorModal(null, 'dynamic-error-modal', 'Unable to create quest, check your entered values.');
    	hideModal(null, 'new-quest-modal');
    	return;
	}
	
    actionFunc(
        data['Quest Name'],
        data['Quest Details'],
        data['Location'],
        data['Requires Party'],
        data['Danger Level'],
        data['Required Profession: Adventurer'],
        data['Required Profession: Craftsman'],
        data['Reward']
    );
    hideModal(null, 'new-quest-modal');
}