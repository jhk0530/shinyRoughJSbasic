#' @import htmlwidgets

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

#' @export
shinyRoughJSbasicOutput = function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'shinyRoughJSbasic', width, height, package = 'shinyRoughJSbasic')
}

#' @export
renderRough = function(expr, env = parent.frame(), quoted = FALSE){
  if(!quoted){ expr = substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, shinyRoughJSOutput, env, quoted = TRUE)
}

#' @export
RoughRect = function(x, y, w, h, opts = NULL){
  if(is.null(opts)){
    opts = RoughOptions()
  }
  list(type = 'rectangle', x = x, y = y, w = w, h = h, options = opts)
}

#' @export
RoughCircle = function(x, y, diameter, opts = NULL){
  if(is.null(opts)){opts = RoughOptions()}
  list(type = 'circle', x = x, y = y, diameter = diameter, options = opts)
}

#' @export
RoughOptions = function(roughness = 1, bowing = 1, stroke = '#000000', strokeWidth= 1,
                        fill = '#000000', fillStyle ='hachure', fillWeight = NULL, hachureAngle = -41,
                        hachureGap = NULL, curveStepCount = 9, simplification = 0, dashOffset = NULL,
                        dashGap = 4, zigzagOffset = NULL){
  if(is.null(fillWeight)){fillWeight = strokeWidth/2}
  if(is.null(hachureGap)){hachureGap = strokeWidth*4}
  if(is.null(dashOffset)){dashOffset = hachureGap}
  if(is.null(dashGap)){dashGap = hachureGap}
  if(is.null(zigzagOffset)){zigzagOffset = hachureGap}

  list(roughness = roughness, bowing = bowing, stroke = stroke, strokeWidth = strokeWidth,
       fill = fill, fillStyle = fillStyle, fillWeight = fillWeight, hachureAngle = hachureAngle,
       hachureGap = hachureGap, curveStepCount = curveStepCount, simplification = simplification, dashOffset = dashOffset,
       dashGap = dashGap, zigzagOffset = zigzagOffset)
}
