# 🏗️ Infrastructure Journey: From Zero to Production

Here's a comprehensive summary of our Terraform infrastructure journey, showing exactly what you'd need to build from scratch:

## 📋 **High-Level Architecture Decisions**

### **Core Infrastructure Components**
1. **Azure Container Registry** - Private Docker image storage
2. **Azure Key Vault** - Secure secret management  
3. **Azure Container Apps Environment** - Serverless container platform
4. **Managed Identities** - Credential-free authentication
5. **Custom Docker Build Module** - Automated CI/CD integration

### **Key Design Principles**
- **Modular Architecture** - Reusable Terraform modules
- **Security-First** - Zero hardcoded secrets, managed identities
- **Digest-Based Deployments** - Proper revision triggering
- **Infrastructure as Code** - Everything reproducible via Terraform

---

## 🛠️ **Step-by-Step Build Process**

### **Phase 1: Project Foundation**
```
infra/
├── main.tf              # Main orchestration
├── variables.tf         # Input parameters  
├── outputs.tf          # Export values
├── terraform.tfvars    # Configuration (git-ignored)
└── modules/            # Reusable components
```

**Key Decisions:**
- Modular design for reusability
- Clear separation of concerns
- Git-ignored sensitive configuration

### **Phase 2: Core Azure Resources**

#### **1. Container Registry Module** (`modules/container_registry/`)
```terraform
# Key Features Built:
- Private Azure Container Registry
- Admin authentication (initially)
- Role-based access for managed identities
- Optional private endpoint support
- Proper tagging and naming conventions
```

#### **2. Key Vault Module** (`modules/key_vault/`)
```terraform  
# Key Features Built:
- Azure Key Vault with soft delete protection
- Dynamic secret creation from variables
- Access policies for current user
- Access policies for managed identities
- Alphanumeric naming (Key Vault constraints)
```

#### **3. Managed Identity Module** (`modules/managed_identity/`)
```terraform
# Key Features Built:
- Separate identities for backend/frontend
- ACR pull role assignments
- Principal ID outputs for Key Vault access
- Proper dependency management
```

#### **4. Container Apps Environment** (`modules/container_apps_environment/`)
```terraform
# Key Features Built:
- Log Analytics workspace
- Container Apps environment
- Proper networking configuration
- Monitoring and observability setup
```

### **Phase 3: Application Deployment**

#### **5. Container App Module** (`modules/container_app/`)
```terraform
# Key Features Built:
- Flexible container configuration
- Environment variables support
- Key Vault secret integration
- Ingress configuration with proper FQDN handling
- Managed identity assignment
- Health probe configuration
```

**Critical Fix:** Changed from `latest_revision_fqdn` to `ingress[0].fqdn` for root URL routing

#### **6. Docker Build & Push Module** (`modules/docker_build_push/`)
```terraform
# Key Features Built:
- Automated Docker builds via Terraform
- Platform-specific builds (linux/amd64 for Azure)
- Build argument support (for frontend API URLs)
- Source change detection via file hashing
- IMAGE DIGEST CAPTURE - Critical for revision triggering
- ACR login automation
```

**Major Evolution:** 
- Started with tag-based deployments (latest)
- **Breakthrough:** Implemented digest-based deployments to trigger Container App revisions

### **Phase 4: Integration & Orchestration**

#### **Main Infrastructure Orchestration** (`main.tf`)
```terraform
# Build Order & Dependencies:
1. Resource Group
2. Container Registry + Managed Identity (parallel)
3. Key Vault (depends on managed identity for access)
4. Container Apps Environment
5. Backend Docker Build → Backend Container App
6. Frontend Docker Build (with backend URL) → Frontend Container App
```

**Key Dependency Chain:**
```
Container Registry → Managed Identity → Key Vault
                ↓
        Docker Build Modules
                ↓
        Container Apps (with proper FQDN references)
```

---

## 🔥 **Critical Challenges & Solutions**

### **1. Container Revision Triggering**
**Problem:** Using `latest` tags didn't trigger new Container App revisions
**Solution:** Implemented digest-based image references with automatic capture

### **2. Cross-App URL References** 
**Problem:** Frontend hardcoded to specific backend revision URLs
**Solution:** Used root FQDN (`ingress[0].fqdn`) for automatic routing

### **3. Key Vault Naming Constraints**
**Problem:** Azure Key Vault names must be alphanumeric only
**Solution:** Used `replace()` function to sanitize project names

### **4. Platform Architecture Mismatch**
**Problem:** ARM64 Mac builds incompatible with Azure (x86-64)
**Solution:** Added `--platform linux/amd64` to all Docker builds

### **5. Secret Management**
**Problem:** How to securely pass secrets without hardcoding
**Solution:** Terraform variables → Key Vault → Container Apps via managed identity

### **6. Build-Time vs Runtime Configuration**
**Problem:** Frontend needs backend URL at build time, not runtime
**Solution:** Pass backend FQDN as Docker build argument (`VITE_API_URL`)

---

## 🎯 **Final Architecture Characteristics**

### **Security Model**
- ✅ Zero hardcoded credentials
- ✅ Managed identity authentication  
- ✅ Key Vault secret integration
- ✅ Private container registry
- ✅ Git-ignored sensitive files

### **Deployment Model**
- ✅ Digest-based automatic updates
- ✅ Zero-downtime rolling deployments
- ✅ Proper dependency orchestration
- ✅ Infrastructure as Code reproducibility

### **Operational Model**
- ✅ Terraform state management
- ✅ Modular component reusability  
- ✅ Clear output values for integration
- ✅ Comprehensive variable configuration

---

## 💡 **Key Terraform Patterns Demonstrated**

1. **Module Composition** - Building complex infrastructure from simple modules
2. **Dependency Management** - Proper `depends_on` and resource references
3. **Dynamic Blocks** - Flexible configuration (secrets, environment variables)
4. **Data Sources** - External script integration for digest capture
5. **Output Chaining** - Passing values between modules
6. **Local Values** - Complex computations and string manipulation
7. **For Each** - Dynamic resource creation (secrets, access policies)

This journey shows the complete evolution from basic containerization to production-ready, automatically-updating infrastructure with enterprise security patterns! 🚀