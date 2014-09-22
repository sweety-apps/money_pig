window.onload = function () {
	selectStep(step);
};

function selectStep(index) {
	if ( stepNum == 3 ) {
		var step1 = document.getElementById("step1");
		var step2 = document.getElementById("step2");
		var step3 = document.getElementById("step3");
		
		step1.className = "step hide";
		step2.className = "step hide";
		step3.className = "step hide";
		
		if ( index == 1 ) {
			step1.className = "step";
		} else if ( index == 2 ) {
			step2.className = "step";
		} else if ( index == 3 ) {
			step3.className = "step";
		}
	} else {
		var step1 = document.getElementById("step1");
		var step2 = document.getElementById("step2");
		
		step1.className = "step hide";
		step2.className = "step hide";
		
		if ( index == 1 ) {
			step1.className = "step";
		} else if ( index == 2 ) {
			step2.className = "step";
		}
	}
};