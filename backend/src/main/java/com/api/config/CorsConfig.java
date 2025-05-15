package com.api.config; // Asegúrate de que el paquete coincida

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
        @Value("${cors.allowed-origins}")
        private String[] allowedOrigins;

        @Value("${cors.allowed-methods}")
        private String[] allowedMethods;

        @Value("${cors.mapping}")
        private String mapping;
    @Override
    public void addCorsMappings(CorsRegistry apiRegistry) {
        apiRegistry.addMapping(mapping) // Cambia según necesites
                .allowedOrigins(allowedOrigins) // Cambia según necesites
                .allowedMethods(allowedMethods)
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}