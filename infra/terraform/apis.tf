locals {

  api_names = {
    api1  = "identityserver"
    api2  = "suscripcion-cotizacion"
    api3  = "emision"
    api4  = "cartera"
    api5  = "integraciones"
    api6  = "facturacion"
    api7  = "adm-polizas"
    api8  = "siniestros"
    api9  = "reservas"
    api10 = "parametros"
    api11 = "reportes"
  }
  apis = {
    api1 = {
      name        = local.api_names.api1
      description = "API Gateway for ${local.api_names.api1}"
      routes = {
        resource1 = {
          path = "/auth"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/login"
              methods = {
                POST = {}
              }
            }
            resource2 = {
              path = "null"
              methods = { GET = {}}
            }
          }
        }
      }
    }
    api2 = {
      name        = local.api_names.api2
      description = "API Gateway for ${local.api_names.api2}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    },
    api3 = {
      name        = local.api_names.api3
      description = "API Gateway for ${local.api_names.api3}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api4 = {
      name        = local.api_names.api4
      description = "API Gateway for ${local.api_names.api4}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api5 = {
      name        = local.api_names.api5
      description = "API Gateway for ${local.api_names.api5}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api6 = {
      name        = local.api_names.api6
      description = "API Gateway for ${local.api_names.api6}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api7 = {
      name        = local.api_names.api7
      description = "API Gateway for ${local.api_names.api7}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api8 = {
      name        = local.api_names.api8
      description = "API Gateway for ${local.api_names.api8}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api9 = {
      name        = local.api_names.api9
      description = "API Gateway for ${local.api_names.api9}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api10 = {
      name        = local.api_names.api10
      description = "API Gateway for ${local.api_names.api10}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
    api11 = {
      name        = local.api_names.api11
      description = "API Gateway for ${local.api_names.api11}"
      routes = {
        resource1 = {
          path = "/actuator"
          methods = {
            GET = {}
          }
          path2 = {
            resource1 = {
              path = "/health"
              methods = {
                GET = {}
              }
            }
          }
        }
      }
    }
  }
}