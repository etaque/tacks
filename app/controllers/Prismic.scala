package controllers

trait Prismic {
  def apiBuilder = io.prismic.Api.get(tools.Conf.prismicApi)
}
