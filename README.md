# shinyRoughJSbasic
tutorial package for build shinyRoughJS with htmlwidgets as shinyRoughJSbasic

i learned with dean attali's this [awesome tutorial](https://deanattali.com/blog/htmlwidgets-tips/)

# step 0. think what to build, and decide package name

as my goal is use rough.js in shiny, we'll make some rectangles that given as example
<img src = 'https://user-images.githubusercontent.com/6457691/70847241-88b19d00-1ea5-11ea-8d0a-52d9d6c65b2f.png' width = 500></img>

and i prefer shiny package name as <p>shiny~~JS, shiny + ~~ + JavaScript</p> since my first shiny package shinyCyJS
<br>
so i'll use shinyRoughJS(+basic for tutorial)
<br>


# step 1. make R project and publish repository
<img src = 'https://user-images.githubusercontent.com/6457691/70766992-f45f1180-1da2-11ea-995c-a4ff467283cd.png' width = 300></img>
<br>
<img src ='https://user-images.githubusercontent.com/6457691/70767065-2ec8ae80-1da3-11ea-857e-a1ee51a57e42.png' width = 300></img>
<br>
<img src ='https://user-images.githubusercontent.com/6457691/70767112-5455b800-1da3-11ea-8e7e-cd4c34054dad.png' width = 300></img>
<br>
<img src = 'https://user-images.githubusercontent.com/6457691/70767188-9252dc00-1da3-11ea-8203-3cf3f50e9561.png' width = 300></img>
<br>

# step 2. make directory and files.

R/shinyRoughJSbasic.R
<br>
inst/
<br>
inst/htmlwidgets
<br>
inst/htmlwidgets/shinyRoughJSbasic.js
<br>
inst/htmlwidgets/shinyRoughJSbasic.yaml
<br>
inst/htmlwidgets/lib

# step 3. put base javascript library (rough.js)

[rough.js](https://github.com/pshihn/rough) <br>
inst/htmlwidgets/lib/rough-3.1.0 

# step 4. write yaml file. 

this yaml file will take format of
<br>
```
dependencies:
  - name: 
    version: 
    src: (base javascript file's location)
    script: (base javascript file)
    stylesheet: (for dependent css file)
```
also need empty new line at end of file and make comment with #
<br>
i used this content as shinyRoughJSbasic
``` yaml
dependencies:
  - name: rough
    version: 3.1.0
    src: htmlwidgets/lib/rough-3.1.0 # directory
    script: rough-3.1.0.js # script
    
```
[For multiple](https://github.com/unistbig/shinyCyJS/blob/master/inst/htmlwidgets/shinyCyJS.yaml)

# step 5. write js file.

this javascript consists with
```
HTMLWidgets.widget({
  name : ,
  type : 'output',
  
  factory : function(el,width,height){
    return {
      renderValue : function(input){
        
      }
    }
  }
})
```

notice that, each base javascript needs different initiation.
<br>
i used this for shinyRoughJSbasic
<br>
``` javascript

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

```

# step 6. write R file

R file needs <b>import</b> htmlwidgets
<br>
R file needs 3 function at least with <b>export</b>
<br>
1) widget function
this will take input and options 
<br>
and make htmlwidgets with base javascript functions
<br>

for example, shinyRoughJSbasic will require <b>element, with type, size, location</b>
``` r
#' @export
shinyRoughJSbasic = function(items = list(),options = list(),width = NULL, height = NULL, elementId = NULL){
  input = list( items = items, options = options )  
  htmlwidgets::createWidget(
    name = 'shinyRoughJSbasic',
    input,
    width = width,
    height = height,
    package = 'shinyRoughJSbasic',
    elementId = elementId
  )
}

```
and remain two paired function will send/recieve r object to shiny application.
<br>
for more information, see this official [cheatsheet](https://shiny.rstudio.com/articles/cheatsheet.html)

2) render function 
``` r
#' @export
renderRough = function(expr, env = parent.frame(), quoted = FALSE){
  if(!quoted){ expr = substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, shinyRoughJSbasicOutput, env, quoted = TRUE)
}
```
3) output function

``` r
#' @export
shinyRoughJSbasicOutput = function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'shinyRoughJSbasic', width, height, package = 'shinyRoughJSbasic')
}
```
  
# step 7. build package with ctrl+shift+B and check run

to pass r object to shiny, it should be capsuled in <b>list</b>
<br>
here are codes i used to check shinyRoughJSbasic in viewer or web browser
<br>

```r
// RoughRect is function to build rectangle object with (xpos, ypos, width, height)
// which also included in R file

shinyRoughJSbasic(
  list(
  RoughRect(15,15,80,80, RoughOptions(roughness = 0.5, fill='red')),
  RoughRect(120,15,80,80, RoughOptions(roughness = 2.8, fill='blue')),
  RoughRect(220,15,80,80, RoughOptions(bowing = 6, stroke = 'green', strokeWidth = 3, fill = 'white'))
  )
)

```

<img src ='https://user-images.githubusercontent.com/6457691/70847404-57d26780-1ea7-11ea-8236-d3f9b086a5ed.png' width = 500></img>

also this code is example code with render - output paired function
```r
library(shiny)
library(shinyRoughJSbasic)
library(shinyjs)
ui <- fluidPage(
  shinyRoughJSbasicOutput(outputId = 'cv', height = '500px')
)

server <- function(input, output, session) {
  output$cv = renderRough(
    shinyRoughJSbasic(
      items = list(
        # x,y,w,h
        RoughRect(1,1,100,100, RoughOptions(fill='#FFFFFF')),
        RoughRect(101,1,100,100,RoughOptions(fill='#74b9ff')),
        RoughRect(201,1,100,100, RoughOptions(fill='#FFFFFF')),
        RoughRect(301,1,100,100, RoughOptions(fill='#FFFFFF')),

        RoughRect(1,101,100,100, RoughOptions(fill='#FFFFFF')),
        RoughRect(101,101,100,100,RoughOptions(fill='#74b9ff')),
        RoughRect(201,101,100,100, RoughOptions(fill = '#00b894')),
        RoughRect(301,101,100,100, RoughOptions(fill='#FFFFFF')),

        RoughRect(1,201,100,100, RoughOptions(fill='#FFFFFF')),
        RoughRect(101,201,100,100,RoughOptions(fill='#74b9ff')),
        RoughRect(201,201,100,100, RoughOptions(fill = '#00b894')),
        RoughRect(301,201,100,100, RoughOptions(fill ='#fbc531')),

        RoughRect(1,301,100,100,RoughOptions(fill='#fd79a8')),
        RoughRect(101,301,100,100,RoughOptions(fill='#74b9ff')),
        RoughRect(201,301,100,100, RoughOptions(fill = '#00b894')),
        RoughRect(301,301,100,100, RoughOptions(fill ='#fbc531'))

        )
    )
  )
}

shinyApp(ui, server)
```
<img src='https://user-images.githubusercontent.com/6457691/70847220-340e2200-1ea5-11ea-88aa-4281da1b1f2c.png' width = 300></img>

# step8. now you have build your own shiny application with Rough.js

