var firstClick = true;

function clickCheck(){
	if (firstClick) {
	        firstClick = false; 
                placeCover();
                timerGU = setTimeout("waitMessage()", 1000);
                return true;
        }
        return false;
}
