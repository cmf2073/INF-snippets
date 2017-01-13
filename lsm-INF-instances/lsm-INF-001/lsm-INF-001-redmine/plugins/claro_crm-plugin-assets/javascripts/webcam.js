/**
 * Created by David on 15/07/15.
 */
var video;
var dataURL;
var elStream;

function setup() {
	navigator.myGetMedia = (navigator.getUserMedia ||
							navigator.webkitGetUserMedia ||
							navigator.mozGetUserMedia ||
							navigator.msGetUserMedia);
	navigator.myGetMedia({ video: true }, connect, error);
}

function connect(stream) {
	elStream = stream;
	video = document.getElementById("video");
	video.src = window.URL ? window.URL.createObjectURL(stream) : stream;
	video.play();
}

function disconnect() {
	video.pause();
	elStream.stop();
	document.getElementById("PhotoButton").disabled = true;
	document.getElementById("PhotoButton").value = "Subiendo.. por favor espere";
	document.getElementById("save").style.display= "none";
}

function error(e) {
	console.log(e);
	document.getElementById("PhotoButton").disabled = true;
	document.getElementById("PhotoButton").value = "Otorgue permisos a la camara.";
	document.getElementById("save").style.display= "none";
}

function captureImage() {
	var canvas = document.createElement('canvas');
	canvas.id = 'hiddenCanvas';
	//add canvas to the body element
	document.body.appendChild(canvas);
	//add canvas to #canvasHolder
	document.getElementById('canvasHolder').appendChild(canvas);
	var ctx = canvas.getContext('2d');
	canvas.width = video.videoWidth ;
	canvas.height = video.videoHeight ;
	ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
	//save canvas image as data url
	dataURL = canvas.toDataURL();
	//set preview image src to dataURL
	document.getElementById('preview').src = dataURL;
	// place the image value in the text box
	document.getElementById('imageToForm').value = dataURL;
	document.getElementById("save").disabled = false;
}

//Bind a click to a button to capture an image from the video stream
var el = document.getElementById("PhotoButton");
el.addEventListener("click", captureImage, false);

var saveBtn = document.getElementById("save");
saveBtn.addEventListener("click", function() {
	disconnect();
}, false);

$(document).ready(function(){
	setup();
	document.getElementById("save").disabled = true;
});
