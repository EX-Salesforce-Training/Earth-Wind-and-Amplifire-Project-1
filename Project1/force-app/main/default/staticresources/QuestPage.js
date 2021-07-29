
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
    event.preventDefault();
    document
    	.querySelector("#" + id)
    	.style
    	.display = 'none';
}

// @desc: set a modal to visible given its id
// @id  : <string>
function showModal(event, id) {
    event.preventDefault();
    document.querySelector("#" + id)
        .style
        .display = 'initial';
}


// @desc       : retrieve the parameters, save a new quest
// @event      : <event>
// @echo       : <func> a function to pass parameters to the action function
// @actionFunc : <func> the action function to save a quest
function submitNewQuest(event, echo, actionFunc) {
    event.preventDefault();
    console.log(event);
    const data = Object.fromEntries(new FormData(event.target).entries());
    
    // set the checkbox variables
    ['Requires Party', 'Required Profession: Adventurer', 'Required Profession: Craftsman']
    .forEach(field => data[field] = (data[field] !== undefined));
    // @todo: send this to an action function
    console.log(data);
}