package com.api.config; // Asegúrate de que el paquete coincida

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry apiRegistry) {
        apiRegistry.addMapping("/api/items/**") // Cambia según necesites
                .allowedOrigins("http://localhost:5173","http://pepito.local") // Cambia según necesites
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
    }
}