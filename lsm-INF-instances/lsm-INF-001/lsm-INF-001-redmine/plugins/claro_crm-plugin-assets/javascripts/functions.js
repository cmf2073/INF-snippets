/* menu responsive */
//$('#menu').slicknav();
$(function(){
    $('[data-toggle="tooltip"]').tooltip();

    $('.btn-pais').on('click', function(event) {
        /* aca va el codigo para ver los datos
         del pais cuando hago click en el boton del menu */
        event.preventDefault();
        //$('#content-home').slideUp('slow');
        //$('#content-pais').slideDown('slow');
    });

    $('.btn-volver').on('click', function(event) {
        event.preventDefault();
        $('#content-home').slideDown('slow');
        $('#content-pais').slideUp('slow');
    });

    $(".btn-pais").hover(
      function() {
        var cod = $(this).attr("id");
        //console.log('cod:' + cod);
        $(".jvectormap-container path[data-code='"+cod+"']").attr('fill', '#FF7F00');

      }, function() {
        var cod = $(this).attr("id");
        //console.log('cod:' + cod);
        $(".jvectormap-container path[data-code='"+cod+"']").attr('fill', '#D6D6D6');
      }
    );

  $('#world-map').vectorMap({
    map: 'latinoamerica',
    backgroundColor: '',
    zoomOnScroll:false,
    onRegionClick:function(event, code, region){
    		/* aca va el codigo para ver los datos
    		del pais cuando hago click en el pais del mapa */
        var myURL = window.location.href + "/country/" + code.toString();
        $.ajax({method: "GET", url: myURL, dataType: "script"});
    },
    onRegionOver:function(event, code){
        //console.log(code)
        $("a#"+code).addClass('active-map');
    },
    onRegionOut:function(event, code){
        //console.log(code)
        $("a#"+code).removeClass('active-map');
    },
    series: {
        regions: [{
            values: {"c0":"1","c1":"2"},
            scale: ['#d9d4ca', '#b3d1ff'],
            normalizeFunction: 'polynomial'
        }]
    },
    regionStyle:{
        initial:{
            fill:"#D6D6D6",
            stroke:"#f6f6f6",
            "stroke-width":1,
            "stroke-opacity":1
        },
        hover:{
            fill:"#FF7F00",
            "fill-opacity":"1",
            cursor: 'pointer'
        }
    },
    regionLabelStyle: {
        initial: {
            fill: '#fff'
        },
        hover: {
            fill: 'fbfbfb'
        }
    }
  })
});












