/* JS */


/* Navigation */

$(document).ready(function(){

  $(window).resize(function()
  {
    if($(window).width() >= 765){
      $(".sidebar #nav").slideDown(350);
    }
    else{
      $(".sidebar #nav").slideUp(350); 
    }
  });
  
   $(".has_sub > a").click(function(e){
    e.preventDefault();
    var menu_li = $(this).parent("li");
    var menu_ul = $(this).next("ul");

    if(menu_li.hasClass("open")){
      menu_ul.slideUp(350);
      menu_li.removeClass("open")
    }
    else{
      $("#nav > li > ul").slideUp(350);
      $("#nav > li").removeClass("open");
      menu_ul.slideDown(350);
      menu_li.addClass("open");
    }
  });

/* Old Code 

  $("#nav > li > a").on('click',function(e){
      if($(this).parent().hasClass("has_sub")) {
       
      e.preventDefault();

      if(!$(this).hasClass("subdrop")) {
      // hide any open menus and remove all other classes
      $("#nav li ul").slideUp(350);
      $("#nav li a").removeClass("subdrop");
      
      // open our new menu and add the open class
      $(this).next("ul").slideDown(350);
      $(this).addClass("subdrop");
      }
      
      else if($(this).hasClass("subdrop")) {
      $(this).removeClass("subdrop");
      $(this).next("ul").slideUp(350);
      } 
      }   
      
  }); */
});

$(document).ready(function(){
  $(".sidebar-dropdown a").on('click',function(e){
      e.preventDefault();

      if(!$(this).hasClass("open")) {
        // hide any open menus and remove all other classes
        $(".sidebar #nav").slideUp(350);
        $(".sidebar-dropdown a").removeClass("open");
        
        // open our new menu and add the open class
        $(".sidebar #nav").slideDown(350);
        $(this).addClass("open");
      }
      
      else if($(this).hasClass("open")) {
        $(this).removeClass("open");
        $(".sidebar #nav").slideUp(350);
      }
  });

});

/* Widget close */

$('.wclose').click(function(e){
  e.preventDefault();
  var $wbox = $(this).parent().parent().parent();
  $wbox.hide(100);
});

/* Widget minimize */

$('.wminimize').click(function(e){
  e.preventDefault();
  var $wcontent = $(this).parent().parent().next('.widget-content');
  if($wcontent.is(':visible')) 
  {
    $(this).children('i').removeClass('fa fa-chevron-up');
    $(this).children('i').addClass('fa fa-chevron-down');
  }
  else 
  {
    $(this).children('i').removeClass('fa fa-chevron-down');
    $(this).children('i').addClass('fa fa-chevron-up');
  }            
  $wcontent.toggle(500);
});

/* Progressbar animation */

setTimeout(function(){

  $('.progress-animated .progress-bar').each(function() {
    var me = $(this);
    var perc = me.attr("data-percentage");

    //TODO: left and right text handling

    var current_perc = 0;

    var progress = setInterval(function() {
      if (current_perc>=perc) {
        clearInterval(progress);
      } else {
        current_perc +=1;
        me.css('width', (current_perc)+'%');
      }

      if (current_perc > 90){
        me.siblings("span").remove()
      }
      if (current_perc != 100){
       me.text((current_perc)+'%');
      } else {
       me.text('Parabéns!!!');
      }


    }, 10);

  });

},100);

/* Slider */

// $(function() {
//   // Horizontal slider
//   $( "#master1, #master2" ).slider({
//     value: 60,
//     orientation: "horizontal",
//     range: "min",
//     animate: true
//   });

//   $( "#master4, #master3" ).slider({
//     value: 80,
//     orientation: "horizontal",
//     range: "min",
//     animate: true
//   });        

//   $("#master5, #master6").slider({
//     range: true,
//     min: 0,
//     max: 400,
//     values: [ 75, 200 ],
//     slide: function( event, ui ) {
//       $( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
//     }
//   });


//   // Vertical slider 
//   $( "#eq > span" ).each(function() {
//     // read initial values from markup and remove that
//     var value = parseInt( $( this ).text(), 10 );
//     $( this ).empty().slider({
//       value: value,
//       range: "min",
//       animate: true,
//       orientation: "vertical"
//     });
//   });
// });



/* Support */

$(document).ready(function(){
  $("#slist a").click(function(e){
     e.preventDefault();
     $(this).next('p').toggle(200);
  });
});

/* Scroll to Top */


$(".totop").hide();

$(function(){
  $(window).scroll(function(){
    if ($(this).scrollTop()>300)
    {
    $('.totop').fadeIn();
    } 
    else
    {
    $('.totop').fadeOut();
    }
  });

  $('.totop a').click(function (e) {
    e.preventDefault();
    $('body,html').animate({scrollTop: 0}, 500);
  });

});


// /* Date picker */

// $(function() {
//     $('#datetimepicker1').datetimepicker({
//       pickTime: false
//     });
// });

// $(function() {
//     $('#datetimepicker2').datetimepicker({
//       pickDate: false
//     });
// });

// /* On Off pllugin */  
  
// $(document).ready(function() {
//   $('.toggleBtn').onoff();
// });


/* CL Editor */

// $(".cleditor").cleditor({
//     width: "auto",
//     height: "auto"
// });

/* Modal fix */

$('.modal').appendTo($('body'));

// /* Pretty Photo for Gallery*/

// jQuery("a[class^='prettyPhoto']").prettyPhoto({
// overlay_gallery: false, social_tools: false
// });

/* Slim Scroll */

/* Slim scroll for chat widget */

// $('.scroll-chat').slimscroll({
//   height: '350px',
//   color: 'rgba(0,0,0,0.3)',
//   size: '5px'
// });

// /* Data tables */

// $(document).ready(function() {
//   $('#data-table').dataTable({
//      "sPaginationType": "full_numbers"
//   });
// });