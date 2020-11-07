function updateClock() {
    var now = new Date();
    hours = now.getHours();
    minutes = now.getMinutes();
    if (hours > 12) {
        hours -= 12;
    } else if (hours === 0) {
        hours = 12;
    }
    if (minutes < 10) {
        time = hours + ':' + "0" + minutes;
    } else {
        time = hours + ':' + minutes;
    }
    if (hours < 10) {
        // time = "0" + time;
        time = "" + time;
    }
    document.getElementById('time').innerHTML = time;
    setTimeout(updateClock, 1000);
}

updateClock();
