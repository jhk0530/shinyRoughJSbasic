HTMLWidgets.widget({
  name : 'shinyRoughJS',
  type : 'output',

  factory : function(el, width, height) {

    // Initialisation
    var cv = document.createElement("canvas");
    cv.setAttribute('width', $("#cv").width());
    cv.setAttribute('height',$("#cv").height());
    cv.id = 'minicv'; // mini canvas
    document.getElementById('cv').appendChild(cv); // add mini canvas to div cv
    
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