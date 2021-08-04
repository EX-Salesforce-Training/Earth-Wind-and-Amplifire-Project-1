// @desc: gather up all the levels on the page and sum them together
function generateTotalLevel() {
	let totalLevel = Array.from(document.querySelectorAll('#level-value'))?.map(node => Number(node.innerText)).reduce((value, acc) => acc + value, 0);
	if(totalLevel === undefined) totalLevel = 0;
    return totalLevel;
}

// @desc: onchange handler to reset the total level in the title     
function tableChangeHandler() {
    setTimeout(() => {
    	document.querySelector('#level-table').querySelector('H3').innerText = 'Level: ' + String(generateTotalLevel());
    }, 300);
}
    
tableChangeHandler();