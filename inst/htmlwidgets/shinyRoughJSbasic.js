HTMLWidgets.widget({
  name : 'shinyRoughJSbasic',
  type : 'output',

  factory : function(el, width, height) {
	var container = document.getElementById(el.id);
	
	
	// Initialisation
	var cv = document.createElement("canvas");
	cv.id = 'minicv'; // mini canvas
	container.appendChild(cv)
	cv.setAttribute('width',container.clientWidth)
	cv.setAttribute('height',container.clientHeight)

    var rc = rough.canvas(document.getElementById('minicv'));
    return {
      renderValue: function(input) {
        var Items = input.items;
        for( var i = 0; i<Items.length; i++){
          var thisItem = Items[i];
          if(thisItem.type=='rectangle'){
            rc.rectangle(thisItem.x, thisItem.y, thisItem.w, thisItem.h, thisItem.options)
          }
        }
      }
    }
  }
});