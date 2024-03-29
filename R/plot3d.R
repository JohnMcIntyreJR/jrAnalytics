#' This is a function for assisting with 3d plots for the  analytics course
#'
#' @param model A model object as returned by the caret::train function
#' @param xvar The variable to be plotted as the x axis
#' @param yvar The variable to be plotted as the y axis
#' @param zvar The response variable being predicted
#' @param phi Angle defining the viewing direction.  phi give the colatitude direction. Default 30.
#' @param theta Angles defining the viewing direction. theta gives the azimuthal direction. Default 30.
#' @param points A logical argument if TRUE the resultant plot will also
#' show the observed points around the fitted surface with red points
#' highlighting those for which the model under estimates and blue points
#' for those points which are below the surface.
#' Note this can get messy when there are large numbers of points.
#' @param ... Other parameters to be passed to the persp function
#' @return NULL
#' @importFrom graphics persp par points points segments
#' @importFrom grDevices trans3d
#' @importFrom stats formula fitted predict
#' @export
#' @examples
#' data(advertising)
#' m = caret::train(Sales~TV + Radio, data = advertising, method = "lm")
#' plot3d(m,advertising$TV, advertising$Radio, advertising$Sales, points = TRUE)
plot3d = function(model, xvar, yvar, zvar,
                  phi = 30, theta = 30, points = FALSE, ...){
  op = par(mar = c(1, 1, 1, 1) ); on.exit(par(op))
  x = seq(min(xvar), max(xvar), length.out = 50)
  y = seq(min(yvar), max(yvar), length.out = 50)

  z = outer(x, y, function(i, j){
    df = data.frame(i, j)
    names(df) = all.vars(formula(model))[2:3]
    predict(model, df)
  })

  names = all.vars(formula(model))
  p = persp(x, y, z, xlab = names[2], ylab = names[3], zlab = names[1],
            phi = phi, theta = theta, ...)
  if (points){
    zvar.fit = fitted(model)
    i.pos = 1 + (zvar.fit > zvar)
    obs = trans3d(xvar, yvar, zvar, p)
    pred = trans3d(xvar, yvar, zvar.fit, p)
    points(obs, col = c("red", "blue")[i.pos], pch = 16)
    segments(obs$x, obs$y, pred$x, pred$y)
  }
}
