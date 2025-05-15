locals {
  apis = {
    api1 = {
      name        = "api1"
      description = "API Gateway 1"
      methods = [
        { http_method = "GET", path = "/resource1" },
        { http_method = "POST", path = "/resource1" }
      ]
    },
    api2 = {
      name        = "api2"
      description = "API Gateway 2"
      methods = [
        { http_method = "GET", path = "/resource2" },
        { http_method = "PUT", path = "/resource2" }
      ]
    }
  }
}