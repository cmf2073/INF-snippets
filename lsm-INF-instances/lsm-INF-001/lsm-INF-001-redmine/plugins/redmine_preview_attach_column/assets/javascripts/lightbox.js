// -----------------------------------------------------------------------------------
//
//  Lightbox v2.05
//  by Lokesh Dhakar - http://www.lokeshdhakar.com
//  Last Modification: 3/18/11
//
//  For more information, visit:
//  http://lokeshdhakar.com/projects/lightbox2/
//
//  Licensed under the Creative Commons Attribution 2.5 License - http://creativecommons.org/licenses/by/2.5/
//    - Free for use in both personal and commercial projects
//    - Attribution requires leaving author name, author link, and the license info intact.
//
//  Thanks: Scott Upton(uptonic.com), Peter-Paul Koch(quirksmode.com), and Thomas Fuchs(mir.aculo.us) for ideas, libs, and snippets.
//      Artemy Tregubenko (arty.name) for cleanup and help in updating to latest ver of proto-aculous.
//
// -----------------------------------------------------------------------------------
/*

    Table of Contents
    -----------------
    Configuration

    Lightbox Class Declaration
    - initialize()
    - updateImageList()
    - start()
    - changeImage()
    - resizeImageContainer()
    - showImage()
    - updateDetails()
    - updateNav()
    - enableKeyboardNav()
    - disableKeyboardNav()
    - keyboardAction()
    - preloadNeighborImages()
    - end()
    
    Function Calls
    - document.observe()
   
*/
// -----------------------------------------------------------------------------------

//
//  Configurationl
//
LightboxOptions = Object.extend({
    fileLoadingImage:        'images/loading.gif',     
    fileBottomNavCloseImage: 'images/closelabel.gif',

    overlayOpacity: 0.8,   // controls transparency of shadow overlay

    animate: true,         // toggles resizing animations
    resizeSpeed: 7,        // controls the speed of the image resizing animations (1=slowest and 10=fastest)

    borderSize: 10,         //if you adjust the padding in the CSS, you will need to update this variable

  // When grouping images this is used to write: Image # of #.
  // Change it for non-english localization
  labelImage: "Image",
  labelOf: "of",

  titleAttribute: "title",
  scaleAttribute: "imgscale",

  scaleToViewport: true,

  fullScreenBorderX: 80,
  fullScreenBorderY: 180,
  minContainerWidth: 250,
  minContainerHeight: 250

}, window.LightboxOptions || {});

// -----------------------------------------------------------------------------------

var Lightbox = Class.create();

Lightbox.prototype = {
    imageArray: [],
    activeImage: undefined,
    
    // initialize()
    // Constructor runs on completion of the DOM loading. Calls updateImageList and then
    // the function inserts html at the bottom of the page which is used to display the shadow 
    // overlay and the image container.
    //
    initialize: function() {    
        
        this.updateImageList();
        
        this.keyboardAction = this.keyboardAction.bindAsEventListener(this);

        if (LightboxOptions.resizeSpeed > 10) LightboxOptions.resizeSpeed = 10;
        if (LightboxOptions.resizeSpeed < 1)  LightboxOptions.resizeSpeed = 1;

        this.resizeDuration = LightboxOptions.animate ? ((11 - LightboxOptions.resizeSpeed) * 0.15) : 0;
        this.overlayDuration = LightboxOptions.animate ? 0.2 : 0;  // shadow fade in/out duration

        // When Lightbox starts it will resize itself from 250 by 250 to the current image dimension.
        // If animations are turned off, it will be hidden as to prevent a flicker of a
        // white 250 by 250 box.
        var size = (LightboxOptions.animate ? 250 : 1) + 'px';
        

        // Code inserts html at the bottom of the page that looks similar to this:
        //
        //  <div id="overlay"></div>
        //  <div id="lightbox">
        //      <div id="outerImageContainer">
        //          <div id="imageContainer">
        //              <img id="lightboxImage">
        //              <div style="" id="hoverNav">
        //                  <a href="#" id="prevLink"></a>
        //                  <a href="#" id="nextLink"></a>
        //              </div>
        //              <div id="loading">
        //                  <a href="#" id="loadingLink">
        //                      <img src="images/loading.gif">
        //                  </a>
        //              </div>
        //          </div>
        //      </div>
        //      <div id="imageDataContainer">
        //          <div id="imageData">
        //              <div id="imageDetails">
        //                  <span id="caption"></span>
        //                  <span id="numberDisplay"></span>
        //              </div>
        //              <div id="bottomNav">
        //                  <a href="#" id="bottomNavClose">
        //                      <img src="images/close.gif">
        //                  </a>
        //              </div>
        //          </div>
        //      </div>
        //  </div>


        var objBody = $$('body')[0];

        objBody.appendChild(Builder.node('div',{id:'overlay'}));

        objBody.appendChild(Builder.node('div',{id:'lightbox'}, [
            Builder.node('div',{id:'outerImageContainer'}, 
                Builder.node('div',{id:'imageContainer'}, [
                    Builder.node('img',{id:'lightboxImage'}), 
                    Builder.node('div',{id:'hoverNav'}, [
                        Builder.node('a',{id:'prevLink', href: '#' }),
                        Builder.node('a',{id:'nextLink', href: '#' })
                    ]),
                    Builder.node('div',{id:'loading'}, 
                        Builder.node('a',{id:'loadingLink', href: '#' }, 
                            Builder.node('img', {src: LightboxOptions.fileLoadingImage})
                        )
                    )
                ])
            ),
            Builder.node('div', {id:'imageDataContainer'},
                Builder.node('div',{id:'imageData'}, [
                    Builder.node('div',{id:'imageDetails'}, [
                        Builder.node('span',{id:'caption'}),
                        Builder.node('span',{id:'numberDisplay'})
                    ]),
                    Builder.node('div',{id:'bottomNav'},
                        Builder.node('a',{id:'bottomNavClose', href: '#' },
                            Builder.node('img', { src: LightboxOptions.fileBottomNavCloseImage })
                        )
                    )
                ])
            )
        ]));


        $('overlay').hide().observe('click', (function() { this.end(); }).bind(this));
        $('lightbox').hide().observe('click', (function(event) { if (event.element().id == 'lightbox') this.end(); }).bind(this));
        $('outerImageContainer').setStyle({ width: size, height: size });
        $('prevLink').observe('click', (function(event) { event.stop(); if(this.activeImage!=0) { this.changeImage(this.activeImage - 1);} else {this.changeImage(this.imageArray.length - 1);} }).bindAsEventListener(this));
        $('nextLink').observe('click', (function(event) { event.stop(); if(this.activeImage == this.imageArray.length-1) {this.changeImage(0);} else { this.changeImage(this.activeImage + 1);} }).bindAsEventListener(this));
        $('loadingLink').observe('click', (function(event) { event.stop(); this.end(); }).bind(this));
        $('bottomNavClose').observe('click', (function(event) { event.stop(); this.end(); }).bind(this));

        var th = this;
        (function(){
            var ids = 
                'overlay lightbox outerImageContainer imageContainer lightboxImage hoverNav prevLink nextLink loading loadingLink ' + 
                'imageDataContainer imageData imageDetails caption numberDisplay bottomNav bottomNavClose';   
            $w(ids).each(function(id){ th[id] = $(id); });
        }).defer();
    },

    //
    // updateImageList()
    // Loops through anchor tags looking for 'lightbox' references and applies onclick
    // events to appropriate links. You can rerun after dynamically adding images w/ajax.
    //
    updateImageList: function() {   
        this.updateImageList = Prototype.emptyFunction;

        document.observe('click', (function(event){
            var target = event.findElement('a[rel^=lightbox]') || event.findElement('area[rel^=lightbox]');
            if (target) {
                event.stop();
                this.start(target);
            }
        }).bind(this));
    },

    //
    //  start()
    //  Display overlay and lightbox. If image is part of a set, add siblings to imageArray.
    //
    start: function(imageLink) {    

        $$('select', 'object', 'embed').each(function(node){ node.style.visibility = 'hidden' });

        // stretch overlay to fill page and fade in
        var arrayPageSize = this.getPageSize();
        $('overlay').setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' });

        new Effect.Appear(this.overlay, { duration: this.overlayDuration, from: 0.0, to: LightboxOptions.overlayOpacity });

        this.imageArray = [];
        var imageNum = 0;

        if ((imageLink.getAttribute("rel") == 'lightbox')){
            // if image is NOT part of a set, add single image to imageArray
            this.imageArray.push([imageLink.href, imageLink.getAttribute(LightboxOptions.titleAttribute), imageLink.getAttribute(LightboxOptions.scaleAttribute)]);
        } else {
            // if image is part of a set..
            this.imageArray = 
                $$(imageLink.tagName + '[href][rel="' + imageLink.rel + '"]').
                collect(function(anchor){ return [anchor.href, anchor.getAttribute(LightboxOptions.titleAttribute), anchor.getAttribute(LightboxOptions.scaleAttribute)]; }).
                uniq();

            while (this.imageArray[imageNum][0] != imageLink.href) { imageNum++; }
        }

        // calculate top and left offset for the lightbox 
        var arrayPageScroll = document.viewport.getScrollOffsets();
        var lightboxTop = arrayPageScroll[1] + (document.viewport.getHeight() / 10);
        var lightboxLeft = arrayPageScroll[0];
        this.lightbox.setStyle({ top: lightboxTop + 'px', left: lightboxLeft + 'px' }).show();
        
        this.changeImage(imageNum);
    },

    //
    //  changeImage()
    //  Hide most elements and preload image in preparation for resizing image container.
    //
    changeImage: function(imageNum) {   
        
        this.activeImage = imageNum; // update global var

        // hide elements during transition
        if (LightboxOptions.animate) this.loading.show();
        this.lightboxImage.hide();
        this.hoverNav.hide();
        this.prevLink.hide();
        this.nextLink.hide();
        // HACK: Opera9 does not currently support scriptaculous opacity and appear fx
        this.imageDataContainer.setStyle({opacity: .0001});
        this.numberDisplay.hide();      
        
        var imgPreloader = new Image();
        var cSizes;
        var viewport_scale;

        // once image is preloaded, resize image container
        imgPreloader.onload = (function(){
            this.lightboxImage.src = this.imageArray[this.activeImage][0];
            /*Bug Fixed by Andy Scott*/
            this.lightboxImage.width = imgPreloader.width;
            this.lightboxImage.height = imgPreloader.height;
            /*End of Bug Fix*/
            viewport_scale=this.imageArray[this.activeImage][2];
            if(viewport_scale == null) {
              viewport_scale=LightboxOptions.scaleToViewport;
            } else {
              viewport_scale = viewport_scale != '0';
            }
            cSizes=this.getImageSize(imgPreloader.width,imgPreloader.height,viewport_scale);
            if(cSizes[2] != -1) {
                this.lightboxImage.style.width=cSizes[2]+'px';
                this.lightboxImage.style.height="";
            } else {
                if(cSizes[3] != -1) {
                    this.lightboxImage.style.width="";
                    this.lightboxImage.style.height=cSizes[3]+'px';
                } else {
                    this.lightboxImage.style.width="";
                    this.lightboxImage.style.height="";
                }
            }
            //this.lightboxImage.style.verticalAlign="middle";
            //this.resizeImageContainer(imgPreloader.width, imgPreloader.height);
            this.resizeImageContainer(cSizes[0], cSizes[1]);
        }).bind(this);
        imgPreloader.src = this.imageArray[this.activeImage][0];
    },

    //
    //  resizeImageContainer()
    //
    resizeImageContainer: function(imgWidth, imgHeight) {

        // get current width and height
        var widthCurrent  = this.outerImageContainer.getWidth();
        var heightCurrent = this.outerImageContainer.getHeight();

        // get new width and height
        var widthNew  = (imgWidth  + LightboxOptions.borderSize * 2);
        var heightNew = (imgHeight + LightboxOptions.borderSize * 2);

        // scalars based on change from old to new
        var xScale = (widthNew  / widthCurrent)  * 100;
        var yScale = (heightNew / heightCurrent) * 100;

        // calculate size difference between new and old image, and resize if necessary
        var wDiff = widthCurrent - widthNew;
        var hDiff = heightCurrent - heightNew;

        if (hDiff != 0) new Effect.Scale(this.outerImageContainer, yScale, {scaleX: false, duration: this.resizeDuration, queue: 'front'}); 
        if (wDiff != 0) new Effect.Scale(this.outerImageContainer, xScale, {scaleY: false, duration: this.resizeDuration, delay: this.resizeDuration}); 

        // if new and old image are same size and no scaling transition is necessary, 
        // do a quick pause to prevent image flicker.
        var timeout = 0;
        if ((hDiff == 0) && (wDiff == 0)){
            timeout = 100;
            if (Prototype.Browser.IE) timeout = 250;   
        }

        (function(){
            this.prevLink.setStyle({ height: imgHeight + 'px' });
            this.nextLink.setStyle({ height: imgHeight + 'px' });
            this.imageDataContainer.setStyle({ width: widthNew + 'px' });
            this.imageContainer.setStyle({ width: imgWidth + 'px', height: imgHeight + 'px' });

            this.showImage();
        }).bind(this).delay(timeout / 1000);
    },
    
    //
    //  showImage()
    //  Display image and begin preloading neighbors.
    //
    showImage: function(){
        this.loading.hide();
        new Effect.Appear(this.lightboxImage, { 
            duration: this.resizeDuration, 
            queue: 'end', 
            afterFinish: (function(){ this.updateDetails(); }).bind(this) 
        });
        this.preloadNeighborImages();
    },

    //
    //  updateDetails()
    //  Display caption, image number, and bottom nav.
    //
    updateDetails: function() {
    
        this.caption.update(this.imageArray[this.activeImage][1]).show();

        // if image is part of set display 'Image x of x' 
        if (this.imageArray.length > 1){
            this.numberDisplay.update( LightboxOptions.labelImage + ' ' + (this.activeImage + 1) + ' ' + LightboxOptions.labelOf + '  ' + this.imageArray.length).show();
        }

        new Effect.Parallel(
            [ 
                new Effect.SlideDown(this.imageDataContainer, { sync: true, duration: this.resizeDuration, from: 0.0, to: 1.0 }), 
                new Effect.Appear(this.imageDataContainer, { sync: true, duration: this.resizeDuration }) 
            ], 
            { 
                duration: this.resizeDuration, 
                afterFinish: (function() {
                  // update overlay size and update nav
                  var arrayPageSize = this.getPageSize();
                  this.overlay.setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' });
                  this.updateNav();
                }).bind(this)
            } 
        );
    },

    //
    //  updateNav()
    //  Display appropriate previous and next hover navigation.
    //
    updateNav: function() {

        this.hoverNav.show();               

        // if not first image in set, display prev image button
        //if (this.activeImage > 0) this.prevLink.show();
        if (this.imageArray.length > 1) {
            this.prevLink.show();
            this.nextLink.show();
        }
        this.enableKeyboardNav();
    },

    //
    //  enableKeyboardNav()
    //
    enableKeyboardNav: function() {
        document.observe('keydown', this.keyboardAction); 
    },

    //
    //  disableKeyboardNav()
    //
    disableKeyboardNav: function() {
        document.stopObserving('keydown', this.keyboardAction); 
    },

    //
    //  keyboardAction()
    //
    keyboardAction: function(event) {
        var keycode = event.keyCode;

        var escapeKey;
        if (event.DOM_VK_ESCAPE) {  // mozilla
            escapeKey = event.DOM_VK_ESCAPE;
        } else { // ie
            escapeKey = 27;
        }

        var key = String.fromCharCode(keycode).toLowerCase();
        
        if (key.match(/x|o|c/) || (keycode == escapeKey)){ // close lightbox
            this.end();
        } else if ((key == 'p') || (keycode == 37)){ // display previous image
            this.disableKeyboardNav();
            if (this.imageArray.length != 1) {
                if (this.activeImage != 0){
                    this.changeImage(this.activeImage - 1);
                } else {
                    this.changeImage(this.imageArray.length - 1);
                }
            }
        } else if ((key == 'n') || (keycode == 39)){ // display next image
            this.disableKeyboardNav();
            if (this.imageArray.length != 1) {
                if (this.activeImage != (this.imageArray.length - 1)){
                    this.changeImage(this.activeImage + 1);
                } else {
                    this.changeImage(0);
                }
            }
        }
    },

    //
    //  preloadNeighborImages()
    //  Preload previous and next images.
    //
    preloadNeighborImages: function(){
        var preloadNextImage, preloadPrevImage;
        if (this.imageArray.length > this.activeImage + 1){
            preloadNextImage = new Image();
            preloadNextImage.src = this.imageArray[this.activeImage + 1][0];
        }
        if (this.activeImage > 0){
            preloadPrevImage = new Image();
            preloadPrevImage.src = this.imageArray[this.activeImage - 1][0];
        }
    
    },

    //
    //  end()
    //
    end: function() {
        this.disableKeyboardNav();
        this.lightbox.hide();
        new Effect.Fade(this.overlay, { duration: this.overlayDuration });
        $$('select', 'object', 'embed').each(function(node){ node.style.visibility = 'visible' });
    },

    //
    //  getPageSize()
    //
    getPageSize: function() {

      var xScroll, yScroll;
      var pageHeight,pageWidth;

      if (window.innerHeight && window.scrollMaxY) {
        xScroll = window.innerWidth + window.scrollMaxX;
        yScroll = window.innerHeight + window.scrollMaxY;
      } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
        xScroll = document.body.scrollWidth;
        yScroll = document.body.scrollHeight;
      } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
        xScroll = document.body.offsetWidth;
        yScroll = document.body.offsetHeight;
      }

          var arrayWindowSize = this.getWindowSize();

      // for small pages with total height less then height of the viewport
      if(yScroll < arrayWindowSize[1]){
        pageHeight = arrayWindowSize[1];
      } else {
        pageHeight = yScroll;
      }

      // for small pages with total width less then width of the viewport
      if(xScroll < arrayWindowSize[0]){
        pageWidth = xScroll;
      } else {
        pageWidth = arrayWindowSize[0];
      }

      return [pageWidth,pageHeight];
    },

    //
    //  getWindowSize()
    //
    getWindowSize: function() {

      var windowWidth, windowHeight;

      if (self.innerHeight) {	// all except Explorer
        if(document.documentElement.clientWidth){
          windowWidth = document.documentElement.clientWidth;
        } else {
          windowWidth = self.innerWidth;
        }
        windowHeight = self.innerHeight;
      } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
        windowWidth = document.documentElement.clientWidth;
        windowHeight = document.documentElement.clientHeight;
      } else if (document.body) { // other Explorers
        windowWidth = document.body.clientWidth;
        windowHeight = document.body.clientHeight;
      }

      return [windowWidth,windowHeight];
    },

    // returns array of 4 with corrected size of the container [dx,dy] and image [dx,dy]
    getImageSize: function(picWidth, picHeight,scale_to_viewport) {
        var containerWidth, containerHeight;
        var imgWidth=-1, imgHeight=-1;
        var windowSize = this.getWindowSize();

        if(picWidth < LightboxOptions.minContainerWidth) {
            containerWidth=LightboxOptions.minContainerWidth;
        } else {
            if(picWidth > windowSize[0]-LightboxOptions.fullScreenBorderX && scale_to_viewport) {
                containerWidth=windowSize[0]-LightboxOptions.fullScreenBorderX;
                imgWidth=containerWidth;
            } else {
                containerWidth=picWidth;
            }
        }

        if(picHeight < LightboxOptions.minContainerHeight) {
            containerHeight=LightboxOptions.minContainerHeight;
        } else {
            if(picHeight > windowSize[1]-LightboxOptions.fullScreenBorderY && scale_to_viewport) {
                containerHeight=windowSize[1]-LightboxOptions.fullScreenBorderY;
                imgHeight=containerHeight;
            } else {
                containerHeight=picHeight;
            }
        }

        if (imgWidth != -1 && imgHeight != -1) {
            if((picWidth+0.0)/imgWidth > (picHeight+0.0)/imgHeight) {
                imgHeight=-1;
            } else {
                imgWidth=-1;
            }
        }

        return [containerWidth, containerHeight, imgWidth, imgHeight];
    }
};

document.observe('dom:loaded', function () { new Lightbox(); });
