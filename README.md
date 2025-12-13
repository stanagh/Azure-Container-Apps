
# Azure Container Apps + Front Door 
This project demonstrates a production-style deployment of a containerized Node.js application on Microsoft Azure, using Infrastructure as Code (Terraform), CI/CD pipelines, Azure Container Apps and Azure Front Door with WAF for secure global access.

The application is publicly accessible via HTTPS and supports Microsoft Entra ID (Azure AD) authentication.

## 🧱 Architecture Overview
The solution follows a layered architecture:
- CI/CD: GitHub Actions builds and pushes container images
- Infrastructure: Terraform provisions all Azure resources
- Runtime: Azure Container Apps runs the application
- Edge & Security: Azure Front Door + WAF + managed TLS
- Identity & Secrets: Managed Identity + Azure Key Vault
- Observability: Application Insights + Log Analytics
- State Management: Terraform remote backend in Azure Storage

## Architecture Diagram
![Image](https://github.com/user-attachments/assets/fcb6fbbe-3326-4a32-b86a-c5be39f57703)

## Running the Project locally 🚦
1. Clone the repository to your local machine
1. **Install dependencies**:
   ```bash
   npm install
   npm start
   ```
2. Then browse the application: 
   ```bash
   http://localhost:3000/
   ```
 4. The source application makes use of environmental variables, however none of are mandatory. These can be set directly locally by creating a .env file on the following directory - nodejs-demoapp/src/.env. 
   If you are running a Azure Container Apps or Azure App service these variables can also be set on the application settings. Please find more information on the official source repo -  https://github.com/benc-uk/nodejs-demoapp
   
## Repository structure
   ```bash
 .github/workflows/   # GitHub Actions workflows
 nodejs-demoapp/      # Node.js application source
    └─ src/
    ├─ Dockerfile
    └─ docker-compose.yml 
    └─ .dockerignore 
 /terraform           # Terraform modules & root configs for Azure resources
    ├─ modules/
    └─ main.tf, variables.tf, outputs.tf
    README.md
.gitignore  
   ```
 
 ## Features 🛠️
### Application 
- Express is used as a lightweight web framework to handle routing, middleware, and server-side rendering.
- MSAL is used to integrate Microsoft Entra ID authentication using OAuth 2.0 / OpenID Connect.
> Authentication flows are handled securely with redirect-based login and token acquisition.
- MongoDB is used as the application data store for the Todo feature.
> The application connects using configuration supplied at runtime, keeping the container image environment-agnostic.

### Docker
- A non-root user is defined in the Dockerfile to follow the principle of least privilege and reduce the risk of elevated permissions at runtime.
- Multi-stage build was used to optimise the image size by separating build dependencies from the final lightweight runtime image.

### Networking & Security
- Azure Front Door is used as the global entry point for the application.
- HTTPS is enforced using Microsoft-managed TLS certificates.
- A Web Application Firewall (WAF) is enabled to protect against common web attacks.
- Azure DNS manages the custom domain and routes traffic to Front Door.

### Observability
- Application Insights is used for request tracing, dependency tracking, and exception monitoring.
- Logs and metrics are centralised in a Log Analytics Workspace for troubleshooting and analysis.
- This provides visibility into application health and runtime behaviour without modifying application code.
  
 ### Security Highlights 🔐
- No secrets stored in code or pipelines
- Managed Identity used for secure access to Key Vault
- HTTPS enforced at the edge (Azure Front Door)
- WAF enabled to protect against common web attack
- Least-privilege access across resources

## Key Learnings 🧠 
- End-to-end Azure Container Apps deployment
- Real-world Front Door + WAF configuration
- Secure identity-based secret management
- Debugging reverse proxy and authentication flows
- Designing cloud architectures with operational maturity

## 📌 Future Improvements 

- Multi-environment setup (dev / staging / prod)
- Blue/green or canary deployments
- Autoscaling tuning

## Video 🍿
https://github.com/user-attachments/assets/242cffe1-adcb-4e3a-9579-e7a0cfb39fe5

🌍 Live Application

Accessible via:
> https://stanagh.website

> https://app.stanagh.website


   
