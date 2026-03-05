var RESOURCE_NAME = window.RESOURCE_NAME || (typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'val-vehicleshop');
window.RESOURCE_NAME = RESOURCE_NAME;

if (typeof choosepayment === 'undefined') choosepayment = null;
if (typeof choosemodelcar === 'undefined') choosemodelcar = null;
if (typeof color_1 === 'undefined') color_1 = null;
if (typeof color_2 === 'undefined') color_2 = null;

function Information(carname,model,pricecar,kg,classcar) {
    $("#box-information").remove();
    
    var popup = document.createElement('div')
    popup.className = 'box-information'
    popup.id = 'box-information'
    document.body.appendChild(popup)
    // var moneys = money
    // var banks = bank
    $('.box-information').html(`
        <div class="head">
            <div class="head2">
                <div class="icon">
                    <img src="/html/img/iconhead.png">
                </div>
                <div class="boxtext">
                    <div class="text1">Car Dealership</div>
                    <div class="text2">Select a category to browse cars.</div>
                </div>
            </div>
            <div class="lineright"></div>
            <div class="lineleft"></div>
        </div>

        <div class="vehicle-info">
            <div class="boxtext">
                <div class="boxtext2">
                    <div class="text1">Class</div>
                    <div class="text2" id="typecar">${classcar}</div>
                </div>
                <div class="text" id="namecar">${carname} </div>
            </div>
            <div class="line"></div>
            <div class="detail">Lorem ipsum dolor sit amet consectetur. Quam eu eget aliquam neque sapien adipiscing ipsum habitant scelerisque</div>
            <div class="linetop"></div>
            <div class="linebottom"></div>
            <div class="box-price-color">
                <div class="price">
                    <div class="text1">SELL PEICE</div>
                    <div class="text2" id="pricecar">$ ${pricecar.toLocaleString()}</div>
                </div>
                <div class="color">
                    <div class="list-color1">
                        
                    </div>
                    <div class="list-color2">
                      
                    </div>
                </div>
            </div>
            <div class="money-bank-me">
                <div class="cash">
                    <div class="text1">CASH</div>
                    <div class="text2" id="money">${money}</div>
                </div>
                <div class="line"></div>
                <div class="bank">
                    <div class="text1">BANK</div>
                    <div class="text2" id="bank">${bank}</div>
                </div>
            </div>
        </div>

        <div class="box-btn">
            <div class="lineleft"></div>
            <div class="lineright"></div>
            <div class="view-testdrive">
                <div class="box" onclick="viewvehicle()">
                    <div class="text">View Vehicle</div>
                </div>
                <div class="box" onclick="TestDrive()">
                    <div class="text">Test Drive</div>
                </div>
            </div>
            <div class="btn-buycar" onclick="CLICKBUY('${pricecar.toLocaleString()}')">
                <div class="text">Buy Vehicle</div>
            </div>
        </div>
    `)
    $.each(colorlist[0] , function(index, item) {
        $(".list-color1").append(`
            <div class="color1" id="color1${index}" onclick="ChooseColorCar_1('${index}')" style="background: ${item.background};"></div>
        `)
    });
    $.each(colorlist[1] , function(index, item) {
        $(".list-color2").append(`
            <div class="color2" id="color2${index}" onclick="ChooseColorCar_2('${index}')" style="background: ${item.background};"></div>
        `)
    });
   
}

function viewvehicle() {
    $.post('https://' + RESOURCE_NAME + '/openfocus');
}

function TestDrive() {
    if (choosemodelcar) {
        $.post('https://' + RESOURCE_NAME + '/testcar', JSON.stringify({
            carname: choosemodelcar,
        }));
    }
}

function CLICKBUY(pricecar) {
    if (document.getElementById('popup-buycar')) {
        return
    }
    var popup = document.createElement('div')
    popup.className = 'popup-buycar'
    popup.id = 'popup-buycar'
    // $("#popup-buycar").remove();
    document.body.appendChild(popup)
    $('.popup-buycar').html(`
        <div class="popup-buycar">
            <div class="inner">
                <div class="information">
                    <div class="head">
                        <div class="icon">
                            <img src="/html/img/iconbuy.png">
                        </div>
                        <div class="boxtext">
                            <div class="text1">Buy Vehicle</div>
                            <div class="text2">Choose your payment method:Cash or Banking.</div>
                        </div>
                    </div>
                    <div class="btn-payment">
                        <div class="btn" onclick="Choose_Payment('money')">
                            <div class="text" id="paymentmoney">Cash Money</div>
                        </div>
                        <div class="btn" onclick="Choose_Payment('bank')">
                            <div class="text" id="paymentbank">Banking + Vat 6 %</div>
                        </div>
                    </div>
                    <div class="pricesum">
                        <div class="line1"></div>
                        <div class="line2"></div>
                        <div class="text">$ ${pricecar}</div>
                    </div>
                    <div class="lineend"></div>
                    <div class="btn-cancel-con">
                        <div class="btn" onclick="Cancel_Buy_Vehicle()">
                            <div class="text">Cancel</div>
                        </div>
                        <div class="btn2" onclick="BUYCAR()">
                            <div class="text">Buy Vehicle</div>
                        </div>
                    </div>
                </div>
                <div class="linetop"></div>
            </div>
        </div>
    `)
}


function Cancel_Buy_Vehicle() {
    $("#popup-buycar").remove();
}

function Choose_Payment(payment) {
    choosepayment = payment
    UPDATE_BTN_PAYMENT('payment'+payment)
}

function ChooseColorCar_1(color) {
    UPDATE_BTN_COLOR_1('color1'+color)
    color_1 = color
    $.post('https://' + RESOURCE_NAME + '/choosecolor1', JSON.stringify({
        color: color,
    }));
}
function ChooseColorCar_2(color) {
    UPDATE_BTN_COLOR_2('color2'+color)
    color_2 = color
    $.post('https://' + RESOURCE_NAME + '/choosecolor2', JSON.stringify({
        color: color,
    }));
}

function UPDATE_BTN_PAYMENT(idclass) {
    var buttons = document.querySelectorAll(".btn-payment .btn")
    buttons.forEach(btn => {
        btn.querySelectorAll('.text').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass}`).classList.add('active')
    });

}

function UPDATE_BTN_COLOR_1(idclass) {
    var buttons = document.querySelectorAll(".list-color1")
    buttons.forEach(btn => {
        btn.querySelectorAll('.color1').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass}`).classList.add('active')
    });
}
function UPDATE_BTN_COLOR_2(idclass) {
    var buttons = document.querySelectorAll(".list-color2")
    buttons.forEach(btn => {
        btn.querySelectorAll('.color2').forEach(el => {
            el.classList.remove('active')
        });
        document.querySelector(`#${idclass}`).classList.add('active')
    });

}