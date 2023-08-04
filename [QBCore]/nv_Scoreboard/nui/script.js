var last_data = $('#players-bton');
var type_filter = 'players';

function ExitScoreboard() {
    $.post('https://nv_Scoreboard/exit', JSON.stringify({}));
    return
}

function ShowData(type, esto) {
    if (type === 'players') {
        type_filter = type;
        $(last_data).css('border', 'none')
        $(last_data).css('color', 'var(--button-not-selected)')
        $(esto).css('border', '2px solid var(--white)')
        $(esto).css('color', 'var(--white)')
        $('#players-table').show();
        $('#business-table').hide();
        $('#events-table').hide();
        $('#robberies-table').hide();
        $('#configuration-table').hide();
        $('#buscador').fadeIn(200);
        document.getElementById('buscador-input').placeholder = 'Search Player';
    } else if (type === 'business') {
        type_filter = type;
        $(last_data).css('border', 'none')
        $(last_data).css('color', 'var(--button-not-selected)')
        $(esto).css('border', '2px solid var(--white)')
        $(esto).css('color', 'var(--white)')
        $('#players-table').hide();
        $('#business-table').show();
        $('#events-table').hide();
        $('#robberies-table').hide();
        $('#configuration-table').hide();
        $('#buscador').fadeIn(200);
        document.getElementById('buscador-input').placeholder = 'Search Business';
    } else if (type === 'events') {
        type_filter = type;
        $(last_data).css('border', 'none')
        $(last_data).css('color', 'var(--button-not-selected)')
        $(esto).css('border', '2px solid var(--white)')
        $(esto).css('color', 'var(--white)')
        $('#players-table').hide();
        $('#business-table').hide();
        $('#robberies-table').hide();
        $('#events-table').show();
        $('#configuration-table').hide();
        $('#buscador').fadeOut(200);
    } else if (type === 'configuration') {
        type_filter = type;
        $(last_data).css('border', 'none')
        $(last_data).css('color', 'var(--button-not-selected)')
        $(esto).css('border', '2px solid var(--white)')
        $(esto).css('color', 'var(--white)')
        $('#players-table').hide();
        $('#business-table').hide();
        $('#events-table').hide();
        $('#robberies-table').hide();
        $('#configuration-table').show();
        $('#buscador').fadeOut(200);
    } else if (type === 'robberies') {
        type_filter = type;
        $(last_data).css('border', 'none')
        $(last_data).css('color', 'var(--button-not-selected)')
        $(esto).css('border', '2px solid var(--white)')
        $(esto).css('color', 'var(--white)')
        $('#players-table').hide();
        $('#business-table').hide();
        $('#events-table').hide();
        $('#configuration-table').hide();
        $('#robberies-table').show();
        $('#buscador').fadeIn(200);
        document.getElementById('buscador-input').placeholder = 'Search Robbery';
    }
    last_data = esto;
}

function truncate(str, n){
    return (str.length > n) ? str.slice(0, n-1) + '&hellip;' : str;
};

document.onkeyup = function (data) {
    if (data.which == 27) {
        $.post('https://nv_Scoreboard/exit', JSON.stringify({}));
        return
    }
};

function ChangeStatus(valor, id) {
    $.post('https://nv_Scoreboard/ChangeStatus', JSON.stringify({
        status: valor,
        identifier: id
    }));
    return
}

var object = null;
var limit_players = 32;

window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.playerNumber != null) {
        if(item.limit != null) {
            limit_players = item.limit;
            $('#playerNumber').html(item.playerNumber+'/'+limit_players);
        } else {
            $('#playerNumber').html(item.playerNumber+'/'+limit_players);
        }
    }
    if (item.type === "players") {
        if(item.admin) {
            $('#configuration-job-1').fadeIn(200);
        }
        limit_players = item.limit;
        const array = JSON.parse(item.data);
        for (const k in array) {
            if (Object.hasOwnProperty.call(array, k)) {
                const element = array[k];
                const name = truncate(element.name, 14);
            $('#players-table').append(`
            <div class="player-content" id='`+element.id+`'>
                <div class="id-container">
                    <span>`+element.id+`</span>
                </div>
                <div class="name-container">
                    <span class="name-value">`+name+`</span>
                </div>
                <div class="img-container">
                    <img src="./user-icon.png" class="player-icon">
                </div>
            </div>
        `)}
        }
    } else if (item.type === "players-join") {
        const array = JSON.parse(item.data);
        const name = truncate(array.name, 14);
        $('#players-table').append(`
            <div class="player-content" id='`+array.id+`'>
                <div class="id-container">
                    <span>`+array.id+`</span>
                </div>
                <div class="name-container">
                    <span class="name-value">`+name+`</span>
                </div>
                <div class="img-container">
                    <img src="./user-icon.png" class="player-icon">
                </div>
            </div>
        `)
    } else if (item.type === "players-left") {
        $('#'+item.data).remove();
        $('#playerNumber').html(item.playerNumber+'/128')
    } else if (item.type === "display") {
        if (item.status) {
            $('#main-container').slideDown(500);
            $('#tables-container').fadeIn(800);
        } else {
            $('#main-container').slideUp(500);
            $('#tables-container').fadeOut(800);
        }
    } else if (item.type === "business-firstJoin") {
        const array = JSON.parse(item.data);
        for (const k in array) {
            if (Object.hasOwnProperty.call(array, k)) {
                const element = array[k];
                if(element.Count <= 0) {
                    $('#business-table').append(`
                    <div class="business-container">
                        <div class="business-logo-container">
                            <img class="business-logo" src="./media/`+k+`.png">
                        </div>
                        <div class="business-content">
                            <div class="business-content-text">
                                <h3 class="business-name-class">`+k+`</h3>
                                <h4>`+element.Description+`</h4>
                            </div>
                            <div class="business-banner">
                                <div class="busines-banner-info">
                                    <div class="business-outline" id="`+k+`-banner">
                                
                                    </div>
                                </div>
                                <div class="business-status">
                                    <h1 id="`+k+`-count">`+element.Count+`</h1>
                                    <div id="`+k+`-color" class="business-status-color" style="background-color: red;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                `)
                } else {
                    $('#business-table').append(`
                    <div class="business-container">
                        <div class="business-logo-container">
                            <img class="business-logo" src="./media/`+k+`.png">
                        </div>
                        <div class="business-content">
                            <div class="business-content-text">
                                <h3 class="business-name-class">`+k+`</h3>
                                <h4>`+element.Description+`</h4>
                            </div>
                            <div class="business-banner">
                                <div class="busines-banner-info">
                                    <div class="business-outline" id="`+k+`-banner">
                                        
                                    </div>
                                </div>
                                <div class="business-status">
                                    <h1 id="`+k+`-count">`+element.Count+`</h1>
                                    <div id="`+k+`-color" class="business-status-color" style="background-color: #42ab49;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                `)
                }
    
                for (const table in element.CurrentStatus) {
                    if (Object.hasOwnProperty.call(element.CurrentStatus, table)) {
                        const element2 = element.CurrentStatus[table];
                        $("#"+k+"-banner").append(`
                            <div id="`+k+`-banner-`+table+`" class="business-info"><h1>`+element2+`</h1></div>
                        `);
                    }
                }
            }
        }
        if(item.Actual != 'none') {
            const element = array[item.Actual];
            $('#configuration-job-2').fadeIn();
            
            for (const table in element.Status) {
                if (Object.hasOwnProperty.call(element.Status, table)) {
                    const table_container = element.Status[table];
                    $('#configuration-job-status-selector').append(`
                        <select onchange="ChangeStatus(this.value, '`+table+`');" name="" id="configuration-`+table+`">
                                
                        </select>
                    `)
                    for (const table2 in table_container) {
                        if (Object.hasOwnProperty.call(table_container, table2)) {
                            const option = table_container[table2]
                            $('#configuration-'+table).append(`
                                <option value="`+option+`">`+option+`</option>
                            `)
                        }
                    }
                }
            }
        }
    } else if (item.type === "business-playerJoin") {
        $("#"+item.business+"-count").html(item.playerCount);
        if(item.playerCount <= 0) {
            $("#"+item.business+"-color").css('background-color', 'red');
        } else {
            $("#"+item.business+"-color").css('background-color', '#42ab49');
        }
    } else if (item.type === "event-upload") {
        $("#events-table").append(`
            <img id="events-`+item.id+`" src="`+item.img+`">
        `);
    } else if (item.type === "event-remove") {
        $("#events-"+item.id).remove();
    } else if (item.type === "getChangedJobStatus") {
        $('#'+item.business+'-banner-'+item.id+' h1').html(item.current_status);
    } else if (item.type === "no-job") {
        $('#configuration-job-2').fadeOut();
    } else if (item.type === "loadRobberies") {
        for (const table in item.data) {
            if (Object.hasOwnProperty.call(item.data, table)) {
                const table_container = item.data[table];
                if (table_container.Available) {
                    $('#robberies-table').append(`
                    <div class="robberies-container">
                        <div class="robberies-logo-container">
                            <img class="robberies-logo" src="./media/${table}.png">
                        </div>
                        <div class="robberies-content">
                            <div class="robberies-content-text">
                                <h3 class="robberies-name-class">${table}</h3>
                                <h4>${table_container.Description}</h4>
                            </div>
                            <div class="robberies-banner">
                                <div class="busines-banner-info">
                                    <div class="robberies-outline" id="${table}-banner">
                                    </div>
                                </div>
                                <div class="robberies-status">
                                    <div id="${table}-color" class="robberies-status-color" style="background-color: #42ab49;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                `)
                } else {
                    $('#robberies-table').append(`
                    <div class="robberies-container">
                        <div class="robberies-logo-container">
                            <img class="robberies-logo" src="./media/${table}.png">
                        </div>
                        <div class="robberies-content">
                            <div class="robberies-content-text">
                                <h3 class="robberies-name-class">${table}</h3>
                                <h4>${table_container.Description}</h4>
                            </div>
                            <div class="robberies-banner">
                                <div class="busines-banner-info">
                                    <div class="robberies-outline" id="${table}-banner">
                                    </div>
                                </div>
                                <div class="robberies-status">
                                    <div id="${table}-color" class="robberies-status-color" style="background-color: red;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                `)
                }
            }
        }
    } else if (item.type === "updateRobberies") {
        if (item.color) {
            $('#'+item.name+'-color').css('background-color', '#42ab49')
        } else {
            $('#'+item.name+'-color').css('background-color', 'red')
        }
    } else if(item.type === 'getColor') {
        object = JSON.parse(item.current_colors);
        r.style.setProperty('--background', object['1-color']);

        r.style.setProperty('--button-not-selected', object['2-color']);

        r.style.setProperty('--banner-background-color', object['3-color']);
        r.style.setProperty('--player-name-background', object['3-color']);
        r.style.setProperty('--button-background', object['3-color']);

        r.style.setProperty('--banner-letter-color', object['4-color']);
        r.style.setProperty('--banner-player-count-color', object['4-color']);
        r.style.setProperty('--player-name-color', object['4-color']);
        r.style.setProperty('--id-color', object['4-color']);
        r.style.setProperty('--search-placeholder', object['4-color']);
        r.style.setProperty('--icon-search-color', object['4-color']);

        r.style.setProperty('--white', object['5-color']);
    } else if (item.type === "getStatus") {
        $('#configuration-job-2').fadeIn();
        $('#configuration-job-status-selector').html('');
        for (const table in item.Status) {
            if (Object.hasOwnProperty.call(item.Status, table)) {
                const table_container = item.Status[table];
                $('#configuration-job-status-selector').append(`
                    <select onchange="ChangeStatus(this.value, '`+table+`');" name="" id="configuration-`+table+`">
                            
                    </select>
                `)
                for (const table2 in table_container) {
                    if (Object.hasOwnProperty.call(table_container, table2)) {
                        const option = table_container[table2]
                        $('#configuration-'+table).append(`
                            <option value="`+option+`">`+option+`</option>
                        `)
                    }
                }
            }
        }
    }
})

function UploadImage() {
    $.post("https://nv_Scoreboard/UploadImage", JSON.stringify({
        name: $('#left-input').val(),
        url: $('#right-input').val()
    }))
}

function RemoveImage() {
    $.post("https://nv_Scoreboard/RemoveImage", JSON.stringify({
        name: $('#left-input').val(),
    }))
}

var input = document.getElementById("buscador-input");
input.addEventListener("input", function() {
    if(type_filter == 'players') {
        var all = $(".name-value").map(function() {
            return this;
        }).get();
    
        var all2 = $(".player-content").map(function() {
            return this;
        }).get();
    
        var filter = this.value.toUpperCase();
        var divs = all2;
        for (var i = 0; i < divs.length; i++) {
            var a = all[i];
    
            if (a) {
                if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    $(divs[i]).fadeIn(200);
                    $('.id-container').fadeIn(200);
                } else {
                    $(divs[i]).fadeOut(200);
                }
            }
        }
    } else if (type_filter == 'business') {
        var all = $(".business-name-class").map(function() {
            return this;
        }).get();
    
        var all2 = $(".business-container").map(function() {
            return this;
        }).get();
    
        var filter = this.value.toUpperCase();
        var divs = all2;
        for (var i = 0; i < divs.length; i++) {
            var a = all[i];
    
            if (a) {
                if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    $(divs[i]).fadeIn(200);
                    $('.id-container').fadeIn(200);
                } else {
                    $(divs[i]).fadeOut(200);
                }
            }
        }
    } else if (type_filter == 'robberies') {
        var all = $(".robberies-name-class").map(function() {
            return this;
        }).get();
    
        var all2 = $(".robberies-container").map(function() {
            return this;
        }).get();
    
        var filter = this.value.toUpperCase();
        var divs = all2;
        for (var i = 0; i < divs.length; i++) {
            var a = all[i];
    
            if (a) {
                if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    $(divs[i]).fadeIn(200);
                    $('.id-container').fadeIn(200);
                } else {
                    $(divs[i]).fadeOut(200);
                }
            }
        }
    }
});

var r = document.querySelector(':root');

var rs = getComputedStyle(r);

document.getElementById('background-color-rgb').addEventListener("input", function() {
    r.style.setProperty('--background', this.value+'de');
}, false);

document.getElementById('background-letters-color-rgb').addEventListener("input", function() {
    r.style.setProperty('--button-not-selected', this.value);
}, false);

document.getElementById('banner-color-rgb').addEventListener("input", function() {
    r.style.setProperty('--banner-background-color', this.value);
    r.style.setProperty('--player-name-background', this.value);
    r.style.setProperty('--button-background', this.value);
}, false);

document.getElementById('general-letters-color-rgb').addEventListener("input", function() {
    r.style.setProperty('--banner-letter-color', this.value);
    r.style.setProperty('--banner-player-count-color', this.value);
    r.style.setProperty('--player-name-color', this.value);
    r.style.setProperty('--id-color', this.value);
    r.style.setProperty('--search-placeholder', this.value);
    r.style.setProperty('--icon-search-color', this.value);
}, false);

document.getElementById('hover-color-rgb').addEventListener("input", function() {
    r.style.setProperty('--white', this.value);
}, false);

function DefaultColor() {
    r.style.setProperty('--background', '#242526de');
    r.style.setProperty('--button-not-selected', '#949ba6');
    r.style.setProperty('--banner-background-color', '#131212');
    r.style.setProperty('--player-name-background', '#525252');
    r.style.setProperty('--button-background', '#404040');
    r.style.setProperty('--banner-letter-color', '#e2e2e2');
    r.style.setProperty('--banner-player-count-color', '#cacaca');
    r.style.setProperty('--player-name-color', '#e4e4e4');
    r.style.setProperty('--id-color', '#d1d5db');
    r.style.setProperty('--search-placeholder', '#9096a0');
    r.style.setProperty('--icon-search-color', '#979797');
    r.style.setProperty('--white', 'white');

    $.post("https://nv_Scoreboard/DefaultColor", JSON.stringify({}))
}

function ResetColor() {
    if(object != null) {
        r.style.setProperty('--background', object['1-color']);

        r.style.setProperty('--button-not-selected', object['2-color']);

        r.style.setProperty('--banner-background-color', object['3-color']);
        r.style.setProperty('--player-name-background', object['3-color']);
        r.style.setProperty('--button-background', object['3-color']);

        r.style.setProperty('--banner-letter-color', object['4-color']);
        r.style.setProperty('--banner-player-count-color', object['4-color']);
        r.style.setProperty('--player-name-color', object['4-color']);
        r.style.setProperty('--id-color', object['4-color']);
        r.style.setProperty('--search-placeholder', object['4-color']);
        r.style.setProperty('--icon-search-color', object['4-color']);

        r.style.setProperty('--white', object['5-color']);
    }
}

function SaveColor() {
    var table = [];
    table['0'] = document.getElementById('background-color-rgb').value+'de';
    table['1'] = document.getElementById('background-letters-color-rgb').value;
    table['2'] = document.getElementById('banner-color-rgb').value;
    table['3'] = document.getElementById('general-letters-color-rgb').value;
    table['4'] = document.getElementById('hover-color-rgb').value;
    $.post("https://nv_Scoreboard/SaveColor", JSON.stringify({
        colors: JSON.stringify(table)
    }))
}

$.post("https://nv_Scoreboard/NuiReady", JSON.stringify({}))

// Credits to Geloteee#2901
