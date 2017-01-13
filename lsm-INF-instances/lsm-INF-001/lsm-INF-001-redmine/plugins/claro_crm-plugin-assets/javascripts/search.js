/**
 * Created by david on 17/07/15.
 */

function setValor() {
    var parametros = document.getElementById('strSearch').value
    var parametros =parametros.split(",");
    var theURL = window.location.href + "/country/" + parametros[2];
    $.ajax({method: "GET", url: theURL, dataType: "script"})
    document.getElementById('strSearch').value = ""
}
$( document ).ready(function() {
    var el = document.getElementById("SearchBtn");
    el.addEventListener("click", setValor, false);
});
