const RESOURCE_NAME = (typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'val-vehicleshop');

choosemodelcar = null
choosepayment = null

money = '0'
bank = '0'
colorlist = {}

color_1 = null
color_2 = null
var timetestcarme = null
window.addEventListener('message',function(event){
    var data = event.data;
    if (data.openshop) {
        $('.box-category-carname').fadeIn();
        // document.getElementById('money').textContent = data.money.toLocaleString()
        // document.getElementById('bank').textContent = data.bank.toLocaleString()
        money = data.money.toLocaleString()
        bank = data.bank.toLocaleString()
        colorlist = data.colorlist
        $('.list-category').empty();
        $(".list-category").append(`
            <div class="category" data-category="all" onclick="ChooseCategory('all')">
                <div class="inner" id="innerall">
                    <div class="lineleft" id="lineleftall"></div>
                    <div class="boxtext">
                        <div class="text" id="textall">ALL</div>
                    </div>
                </div>
            </div>
        `);
        $.each(data.vehicleCategorys, function(index, item) {
            $(".list-category").append(`
                <div class="category" data-category="${item.index}" onclick="ChooseCategory('${item.index}')">
                    <div class="inner" id="inner${item.index}">
                        <div class="lineleft" id="lineleft${item.index}"></div>
                        <div class="boxtext">
                            <div class="text" id="text${item.index}">${item.label}</div>
                        </div>
                    </div>
                </div>
            `);
        });
        $('.list-carname').empty();
        $(".list-carname").append(`
            <div class="btn-scroll-left" onclick="Scroll_Right()">
                <img src="/html/img/left.png">
            </div>
            <div class="boxscroll-listcarname"></div>
        `);
        var vehiclesdata = data.vehiclesdata
        var firstcar = false
        $.each(vehiclesdata , function(index, item) {
            $.each(vehiclesdata[index] , function(indexx, itemm) {
                if (itemm.typecar === data.shop) { 
                    $(".boxscroll-listcarname").append(`
                        <div class="carname" data-categorycar="${itemm.category}" onclick="Choosecar('${itemm.name}','${itemm.model}',${itemm.price},${itemm.kg},'${itemm.class}')">
                            <div class="inner" id="inner${itemm.model}">
                                <div class="boxtext">
                                    <div class="text1">${itemm.class}</div>
                                    <div class="text2">${itemm.name} </div>
                                </div>
                                <div class="line1"></div>
                                <div class="line2" id="line2${itemm.model}"></div>
                                <div class="textprice" id="textprice${itemm.model}">$ ${itemm.price.toLocaleString()}</div>
                            </div>
                        </div>
                    `);
                    if (!firstcar) { 
                        firstcar = true 
                        Choosecar(itemm.name,itemm.model,itemm.price,itemm.kg,itemm.class)
                    }
                }
            });
        });
        $(".list-carname").append(`
            <div class="btn-scroll-left" onclick="Scroll_Left()">
                <img src="/html/img/right.png">
            </div>
        `);
        ChooseCategory('all')
    }


    if (data.closeui) {
     
        color_1 = null
        color_2 = null
        choosepayment = null
        choosemodelcar = null
        $('.box-category-carname').fadeOut();
        $("#popup-buycar").remove();
        $("#box-information").remove();
       
    
    }


    if (data.testcar) {
        $('.box-testdrive').show();
  
        var totalTime = +event.data.time; 
        var timeleft = totalTime;
        document.getElementById('carnametest').textContent = data.carname
        timetestcarme = setInterval(function() {
            var minutes = Math.floor(timeleft / 60);
            var seconds = timeleft % 60;
            document.getElementById("timetestdrive").textContent = 
                minutes.toString().padStart(2, '0') + ":" + 
                seconds.toString().padStart(2, '0');

                // var progressPercent = ((totalTime - timeleft) / totalTime) * 100;
                // document.getElementById("process-time").style.width = progressPercent + "%";
             
            if (timeleft == 0) {
                $('.box-testdrive').hide();
                clearInterval(timetestcarme);
                $.post('https://' + RESOURCE_NAME + '/timeouttest');
            }
            timeleft--;
        }, 1000);
    }

    if (data.closetime) {
        if (timetestcarme != null) {
            $('.box-testdrive').hide();
            clearInterval(timetestcarme);
        }
    }

});


function Scroll_Left() {
    var itemWidth = $('.carname').outerWidth(true)
    $('.boxscroll-listcarname').animate({scrollLeft:"+="+itemWidth},400)
}

function Scroll_Right() {
    var itemWidth = $('.carname').outerWidth(true)
    $('.boxscroll-listcarname').animate({scrollLeft:"-="+itemWidth},400)
}



document.addEventListener('DOMContentLoaded',function() {
    $('.box-category-carname').hide();
    $('.box-testdrive').hide();
    // $('.box-information').hide();
});

$(document).keyup(function(e) {
    if (e.key === 'Escape') {
        color_1 = null
        color_2 = null
        choosepayment = null
        choosemodelcar = null
        $('.box-category-carname').fadeOut();
        $("#popup-buycar").remove();
        $("#box-information").remove();
        $.post('https://' + RESOURCE_NAME + '/quit');
    }
})


function Choosecar(carname,model,pricecar,kg,classcar) {
    if (document.getElementById('popup-buycar')) {
        return
    }
  
    choosemodelcar = model
    $.post('https://' + RESOURCE_NAME + '/choosecar', JSON.stringify({
        model: model,
    }));
    UPDATE_BTN_CARNAME('inner'+model,'line2'+model,'textprice'+model)
    Information(carname,model,pricecar,kg,classcar)
    
}



function ChooseCategory(category) {
    if (document.getElementById('popup-buycar')) {
        return
    }
    if (category === 'all') {
        $('[data-categorycar]').show()
    } else {
        $('[data-categorycar]').hide()
        $(`[data-categorycar="${category}"]`).show() 
    }
    UPDATE_BTN_CATEGORY('inner'+category,'text'+category,'lineleft'+category)
}



function BUYCAR() {
    if (choosepayment == null) {
        return
    }
    if (choosemodelcar == null) {
        return
    }
    if (choosepayment === 'money') {
        $.post('https://' + RESOURCE_NAME + '/buycar', JSON.stringify({
            color1: color_1,
            color2: color_2,
            carname: choosemodelcar,
            payment: 'money'
        }));
        choosepayment = null
        $('.box-category-carname').fadeOut();
        $("#popup-buycar").remove();
        $("#box-information").remove();
    } else {
        $.post('https://' + RESOURCE_NAME + '/buycar', JSON.stringify({
            color1: color_1,
            color2: color_2,
            carname: choosemodelcar,
            payment: 'bank'
        }));
        choosepayment = null
        $('.box-category-carname').fadeOut();
        $("#popup-buycar").remove();
        $("#box-information").remove();
    }
}

function UPDATE_BTN_CATEGORY(idclass,idclass2,idclass3) {
    var buttons = document.querySelectorAll(".category")
    buttons.forEach(btn => {
        btn.querySelectorAll('.inner').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass}`).classList.add('active')
    });

    var buttons = document.querySelectorAll(".category .inner .boxtext")
    buttons.forEach(btn => {
        btn.querySelectorAll('.text').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass2}`).classList.add('active')
    });

    var buttons = document.querySelectorAll(".category .inner")
    buttons.forEach(btn => {
        btn.querySelectorAll('.lineleft').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass3}`).classList.add('active')
    });
}

function UPDATE_BTN_CARNAME(idclass,idclass2,idclass3) {
    var buttons = document.querySelectorAll(".carname")
    buttons.forEach(btn => {
        btn.querySelectorAll('.inner').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass}`).classList.add('active')
    });

    var buttons = document.querySelectorAll(".carname .inner")
    buttons.forEach(btn => {
        btn.querySelectorAll('.line2').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass2}`).classList.add('active')
    });

    var buttons = document.querySelectorAll(".carname .inner")
    buttons.forEach(btn => {
        btn.querySelectorAll('.textprice').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass3}`).classList.add('active')
    });

}