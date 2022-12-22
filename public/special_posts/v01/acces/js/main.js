//$(document).ready($("#pages").css('visibility', "visible"));

//var aps = alert("aps");
////////////////анимация блок 1 //////////////

    //alert('запустилось');
    var vAb_1text = new SplitText("#tb1", {
        type: "words,lines,chars",
        wordsClass: "SL++"
    });
    var tt_a1 = vAb_1text.lines;
    var tt_t1 = vAb_1text.chars;
    var objects = $(tt_t1).filter(':contains("а"), :contains("в"), :contains("п")');

    function an_1abzac() {

        TweenMax.staggerTo(tt_a1, 1, {
            x: 40,
            ease: Power3.easeOut
        }, 0.1);
        TweenMax.fromTo(objects, 1.5, {
            textShadow: "0 0 15px #ССС",
            color: 'none'
        }, {
            scale: 1.3,
            y: -4
        }, 0.2);
    }

    function an_1abzac_bac() {
        TweenMax.staggerTo(tt_a1, 1, {
            x: 0,
            y: 0,
            ease: Power3.easeOut
        }, 0.2);
        TweenMax.fromTo(objects, 1.5, {
            y: 0
        }, {
            scale: 1,
            y: 0
        }, 0.2);
    }

    var poz_a1 = 0;
    $("#tb1").mouseup(function () {
        if (poz_a1 === 0) {
            an_1abzac();
            poz_a1 = 1;
            $("#arrow1").css({
                'visibility': 'hidden'
            })
        } else {
            //alert("уже запустили");
        }
    });

    $(".SL74").click(function () {
        an_1abzac_bac();
        //alert("ap")
    });

    $(".SL70").click(function () {
        an_1abzac();
        //alert("dep")
    });


////////////////анимация блок 2//////////////
var poz_2 = 0;

$(".slov").click(function () {
    if (poz_2 === 0) {
        $(this).addClass("slov_big");
        poz_2 = 1;
    } else {
        $(".slov").removeClass("slov_big");
        poz_2 = 0;
    }
});

/////анимация разворота линий 3 блок////


    var txt1 = new SplitText("#tb3 p", {
        type: "words,lines"
    });

    $('#tb3').mouseup(function () {
        inApanim();
    });

    var poz = 0;

    function inApanim() {

        var tl = new TimelineLite,
            chars = txt1.lines;
        TweenLite.set('#tb3', {
            perspective: 400
        });
        var objects = $(chars).filter(':even');
        var objects2 = $(chars).filter(':odd');

        if (poz === 0) {
            tl.staggerTo(objects, 0.8, {
                rotationY: 15,
                rotationX: 15,
                transformOrigin: "40% 0px",
                ease: Back.easeOut
            }, 0.1, "+=0");
            tl.staggerTo(objects2, 0.8, {
                rotationY: -15,
                rotationX: 15,
                transformOrigin: "40% 0px",
                ease: Back.easeOut
            }, 0.1, "-=1");
            poz = 1;
        } else if (poz === 1) {
            tl.staggerTo(objects, 0.8, {
                rotationY: 0,
                rotationX: 0,
                transformOrigin: "40% 0px",
                ease: Back.easeOut
            }, 0.1, "+=0");
            tl.staggerTo(objects2, 0.8, {
                rotationY: 0,
                rotationX: 0,
                transformOrigin: "50% 0px",
                ease: Back.easeOut
            }, 0.1, "-=1");
            poz = 0;
        }
    }

/////анимация разворота линий 4 блок////

var bucva = $("#az");
var texts_4 = $("#tex4");
var btn_tochka = $("#tchk2");
TweenMax.to(bucva, .001, {
    alpha: 0,
    scale: .7
});
var tez = 0;
//TweenLite.set($("#tex4"), {visibility:"visible"});

btn_tochka.click(function () {
    var an_4bt = new TimelineLite();
    if (tez === 0) {
        an_4bt.set($("#tex4"), {
            visibility: "hidden"
        });
        an_4bt.to(bucva, 1, {
            alpha: 1,
            scale: 1
        });
        tez = 1;
    } else {
        tez = 0;
        an_4bt.set($("#tex4"), {
            visibility: "visible"
        });
        an_4bt.to(bucva, 1, {
            alpha: 0,
            scale: .7
        });
    }
})

/////анимация разворота линий 5 блок////
function apTb5_anim() {
    var arr5 = $("#tb5");
    var poz_t5 = 0;
    var tb5_text = $("#tb5 p")
    var tb5_lain = new SplitText(tb5_text, {
        type: "lines, words",
        wordsClass: "sl5_++",
        linesClass: "l5_++"
    });
    TweenLite.set(tb5_text, {
        transformPerspective: 600,
        perspective: 900,
        transformStyle: "preserve-3d",
        autoAlpha: 1
    });
    numLL = tb5_lain.lines.length;

    //some helper functions
    function randomNumber(min, max) {
        return Math.floor(Math.random() * (1 + max - min) + min);
    }

    function rangeToPercent(number, min, max) {
        return ((number - min) / (max - min));
    }

    var tl_tb5 = new TimelineMax();
    for (var i = 0; i < numLL; i++) {
        tl_tb5.to(tb5_lain.lines[i], 12, {
            rotationY: randomNumber(0, 900)
        }, Math.random() * 1.5);
    }
    tl_tb5.pause();

    arr5.click(function () {
        if (poz_t5 === 0) {
            tl_tb5.play();
            poz_t5 = 1;
        } else {
            tl_tb5.reverse();
            poz_t5 = 0;
        }
    })
}
/////анимация разворота линий 6 блок////

var tb6_el = $("#tb6 p"),
    tb6_txt = new SplitText(tb6_el, {
        type: "words"
    }),
    tb6_an = new TimelineMax(),
    numWords = tb6_txt.words.length;
var poz6 = 0;
TweenLite.set(tb6_el, {
    transformPerspective: 600,
    perspective: 300,
    transformStyle: "preserve-3d",
    autoAlpha: 1
});
tb6_an.add("explode")
//add explode effect
for (var i = 0; i < numWords; i++) {
    tb6_an.to(tb6_txt.words[i], 2, {
        z: randomNumber(100, 500),
        opacity: 0,
        rotation: randomNumber(360, 720),
        rotationX: randomNumber(-360, 360),
        rotationY: randomNumber(-360, 360)
    }, "explode+=" + Math.random() * 0.2);
}
tb6_an.stop();
$("#splash_6_h").click(function () {

    if (poz6 === 0) {
        tb6_an.play();
        poz6 = 1;

    } else if (poz6 === 1) {

        tb6_an.reverse();
        poz6 = 0;

    }
});

function randomNumber(min, max) {
    return Math.floor(Math.random() * (1 + max - min) + min);
}

function rangeToPercent(number, min, max) {
    return ((number - min) / (max - min));
}
/////анимация разворота линий 7 блок////

var an_tb7 = $("#tb7");
var an_tb7_poz = 0;
//an_tb7.click(function(){aN_tb7();})
function aN_tb7() {
    if (an_tb7_poz === 0) {
        $("#tb7").addClass('gradients');
        TweenMax.to(an_tb7, 4, {css:{color: '#fff'}});
        an_tb7_poz = 1;
    }
    else
    {
        $("#tb7").removeClass('gradients');
        TweenMax.to(an_tb7, 4, {css:{color: '#000'}});
        an_tb7_poz = 0;
    }
}


/////анимация разворота линий 8 блок////
var tb8_an = new TimelineMax
var tb8_txt = $("#tb8 p");
var tb8_sp = new SplitText(tb8_txt, {
    type: "chars",
    position: "absolute"
});

tb8_an.set(tb8_txt, {
    autoAlpha: 1
});
tb8_an.pause();
for (i = 0; i < tb8_sp.chars.length; i++) {

    tb8_an.to(tb8_sp.chars[i], 0.6, {
        y: 500 + Math.random() * 100,
        rotation: Math.random() * 360,
        scale: 1.8 + Math.random() * 10,
        ease: Bounce.easeOut
    }, 0.4 + Math.random() * 0.6);

}
var poz8 = 0;

$("#ver_arr_over").click(function () {

    if (poz8 === 0) {
        tb8_an.play();
        poz8 = 1;
    } else {
        tb8_an.reverse();
        poz8 = 0;
    }

});

tb8_txt.waypoint(function (dir) {
    tb8_an.reverse();
    poz8 = 0;
}, {
    offset: '-2%'
});

/////анимация разворота линий 9 блок////

var tb9_txt = $("#tb9 p");
var tb9_sl = new SplitText(tb9_txt, {
    type: "words",
    wordsClass: "sl9_++",
    position: "relative"
});

an_text9 = new TimelineLite(),
    numWords = tb9_sl.words.length;
an_text9.pause();
//var rt9 = Math.random()*100;
for (var i = 0; i < numWords; i++) {

    var fromX = (i % 2 == 0) ? -100 : 100;
    var rt9 = Math.random() * 360;
    an_text9.to(tb9_sl.words[i], 5.6, {
        x: fromX,
        scale: 1.3,
        rotation: rt9,
        ease: Back.easeOut
    }, i * 0.2)
}
var poz9 = 0;

tb9_txt.click(function (event) {
    if (poz9 === 0) {
        an_text9.play();
        poz9 = 1;
    } else {
        poz9 = 0;
        an_text9.reverse();
    }
});


/////анимация разворота линий 10 блок////
function tb10Ap() {
    apTb5_anim();
    var tb10_txt = $("#tb10 span p");
    var tb10_sl = new SplitText(tb10_txt, {
        type: "lines,words",
        linesClass: "la++",
        wordsClass: 'sl_++',
        position: "relative"
    });
    var tb10_an = new TimelineMax();

    tb10_an.to(".la1", .2, {
        x: 20,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la2", .2, {
        x: 30,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la3", .2, {
        x: 40,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la4", .2, {
        x: 50,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la5", .2, {
        x: 60,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la6", .2, {
        x: 70,
        ease: Bounce.easeOut
    });
    tb10_an.to(".la7", .2, {
        x: 80,
        ease: Bounce.easeOut
    });
    /*tb10_an.to(".la8",.2,{x:90, ease:Bounce.easeOut});
     tb10_an.to(".la9",.2,{x:100, ease:Bounce.easeOut});
     tb10_an.to(".la10",.2,{x:110, ease:Bounce.easeOut});
     tb10_an.to(".la11",.2,{x:120, ease:Bounce.easeOut});
     tb10_an.to(".la12",.2,{x:130, ease:Bounce.easeOut});

     tb10_an.to(".la13",.2,{x:135, ease:Bounce.easeOut});
     tb10_an.to(".la14",.2,{x:130, ease:Bounce.easeOut});
     tb10_an.to(".la15",.2,{x:120, ease:Bounce.easeOut});
     tb10_an.to(".la16",.2,{x:110, ease:Bounce.easeOut});
     tb10_an.to(".la17",.2,{x:100, ease:Bounce.easeOut});
     tb10_an.to(".la18",.2,{x:90, ease:Bounce.easeOut});
     tb10_an.to(".la19",.2,{x:80, ease:Bounce.easeOut});
     tb10_an.to(".la20",.2,{x:70, ease:Bounce.easeOut});
     tb10_an.to(".la21",.2,{x:60, ease:Bounce.easeOut});
     tb10_an.to(".la22",.2,{x:50, ease:Bounce.easeOut});
     tb10_an.to(".la23",.2,{x:40, ease:Bounce.easeOut});
     tb10_an.to(".la24",.2,{x:30, ease:Bounce.easeOut});*/
    tb10_an.pause();

    var poz10 = 0;

    $("#tb10").click(function () {

        if (poz10 === 0) {
            tb10_an.play();
            poz10 = 1;
        } else {
            tb10_an.reverse();
            poz10 = 0;
        }

    });
}
