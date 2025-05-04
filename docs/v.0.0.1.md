# Project Documentation - CORS Testing Release

## Project Overview
This documentation covers the initial release of our web application project, which consists of a Spring Boot backend and a React+Vite frontend. The primary focus of this release is to deliberately test CORS (Cross-Origin Resource Sharing) behavior by implementing controlled CORS failures.

## System Architecture

### Backend (Spring Boot)
- **Language**: Java
- **Framework**: Spring Boot
- **API Design**: RESTful API
- **Base URL**: `/api`

### Frontend
- **Framework**: React
- **Build Tool**: Vite
- **Connection**: Makes API calls to the Spring Boot backend

## CORS Configuration Details

### Purpose of This Release
The primary goal of this release is to deliberately trigger CORS failures for testing and educational purposes. This approach allows us to:
1. Understand how CORS restrictions work in practice
2. Observe browser behavior when CORS policies are violated
3. Develop a clear understanding of security implications

### Current Implementation
The backend has a restricted CORS policy that only allows requests from `http://localhost:5173`, which is the default Vite development server port. The configuration explicitly:

- Limits allowed origins to only `http://localhost:5173`
- Restricts HTTP methods to GET, POST, PUT, DELETE, and OPTIONS
- Maps these restrictions to the `/api/items` endpoint

```java
registry.addMapping("/api/items")     // Path pattern for items API
        .allowedOrigins("http://localhost:5173")  // Only allows this specific origin
        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
```

### API Endpoints

The backend implements the following REST endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/api/items` | Retrieves all items |
| POST   | `/api/items` | Creates a new item |
| PUT    | `/api/items/{id}` | Updates an item by ID |
| DELETE | `/api/items/{id}` | Deletes an item by ID |

## Expected CORS Issues

### Scenarios That Will Fail
**Note**: In addition to the CORS-specific failures listed below, there may be route mapping inconsistencies that cause certain operations to fail.
1. **Different Origin**: Any request from an origin other than `http://localhost:5173` will be rejected
2. **Production Deployment**: When deploying to production environments with different URLs
3. **Mobile Applications**: If attempting to access the API from a mobile application 
4. **Third-party Integrations**: External services trying to access the API

### Error Symptoms
- Browser console will show errors like: `Access to fetch at 'http://your-api-url/api/items' from origin 'http://different-origin' has been blocked by CORS policy`
- API requests will fail without server-side execution
- Frontend functionality dependent on these API calls will not work
- PUT and DELETE operations may fail due to route mapping inconsistencies between the controller and CORS configuration
- Path variable-based endpoints (`/api/items/{id}`) might not be properly covered by the current CORS configuration that only specifies `/api/items`

![CORS Error Example](/docs/corsError-v.0.0.1.png)
*Example of a CORS error in the browser console*

## Resolution (For Future Releases)

After testing and observing the CORS failures, future releases should:

1. Update the CORS configuration to include all necessary production domains
2. Consider implementing more flexible CORS policies if required
3. Potentially use environment variables to dynamically set allowed origins based on deployment environment

Example future configuration:
```java
// Future implementation will use environment variables or configuration properties
String[] allowedOrigins = {"http://localhost:5173", "https://your-production-domain.com"};
registry.addMapping("/api/**")
        .allowedOrigins(allowedOrigins)
        .allowedMethods("*");
```

## Development Instructions

### Running the Backend
1. Ensure Java 11+ and Maven are installed
2. Navigate to the backend directory
3. Run `mvn spring-boot:run`
4. The server will start on port 8080 (by default)

### Running the Frontend
1. Ensure Node.js is installed
2. Navigate to the frontend directory
3. Run `npm install`
4. Run `npm run dev`
5. Access the application at `http://localhost:5173`

### Testing CORS Failures
1. Try accessing the API from a different port or domain
2. Observe the CORS errors in the browser console
3. Test PUT and DELETE operations specifically to verify their behavior with the current configuration
4. Document the behavior for educational purposes

## Next Steps
1. Complete the tests of CORS failure scenarios
2. Fix route mapping inconsistencies between controller endpoints and CORS configuration
3. Implement proper CORS configuration for development and production
4. Consider using `allowedMappings("/api/**")` to cover all API endpoints including those with path variables
5. Enhance API functionality beyond basic CRUD operations
6. Develop comprehensive frontend features

---

**Note**: This documentation describes a deliberate implementation choice to cause CORS failures for testing and educational purposes. This is not a production-ready configuration.
