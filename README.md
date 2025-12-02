# Kubernetes Observability Project – FastAPI, Prometheus, Grafana, Loki, Alertmanager, HPA & GitHub Actions

## 1. Project Overview
This project implements a complete production-grade **Kubernetes Observability Platform** for a FastAPI application.  
It demonstrates essential **DevOps** and **Site Reliability Engineering (SRE)** practices such as containerisation, metrics instrumentation, logging pipelines, alerting workflows, autoscaling, GitHub Actions CI/CD, and multi-environment Kubernetes deployments.

The goal is to simulate a real-world production monitoring environment that highlights readiness for DevOps, Cloud Engineering, and SRE roles.

---

## 2. Architecture Summary
The architecture consists of three Kubernetes namespaces:

- **app** : development and testing  
- **prod** : production-like environment  
- **observability** : monitoring stack including Prometheus, Grafana, Loki, Alertmanager

### Core Flow
- User → FastAPI → Kubernetes cluster  
- Prometheus scrapes metrics from FastAPI  
- Grafana visualises metrics and logs  
- Loki stores JSON-structured FastAPI logs  
- Alertmanager delivers alert notifications  
- GitHub Actions performs CI/CD into `prod`  

```mermaid
flowchart LR
    User --> Ingress
    Ingress --> FastAPI

    subgraph Kubernetes Cluster
        subgraph app Namespace
            FastAPI
        end

        subgraph prod Namespace
            FastAPIProd
        end

        subgraph observability Namespace
            Prometheus --> Grafana
            Loki --> Grafana
            Prometheus --> Alertmanager
        end
    end

    FastAPI -->|Scrape Metrics| Prometheus
    FastAPI -->|JSON Logs| Loki

    GitHubActions --> GHCR --> HelmDeploy --> FastAPIProd
```

---

## 3. Features
- FastAPI deployed via Helm  
- Prometheus scraping using pod annotations  
- JSON structured logging integrated with Loki  
- Grafana dashboards for latency, usage, traffic, restarts  
- Alertmanager + email notifications  
- CPU-based HPA autoscaling  
- GitHub Actions CI/CD deployment  
- Multi-environment Kubernetes namespaces  

---

## 4. Tech Stack
- **FastAPI**
- **Docker**
- **Kubernetes (K8s)**
- **Helm**
- **Prometheus**
- **Grafana**
- **Loki**
- **Alertmanager**
- **GitHub Actions**
- **GitHub Container Registry (GHCR)**
- **Horizontal Pod Autoscaler (HPA)**

---

## 5. Kubernetes Deployment Structure

### Namespaces
- `app`
- `prod`
- `observability`

### Services
- FastAPI Service (port 80)
- Prometheus, Grafana, Loki internal services

### Helm Values
- Replica counts  
- Resource limits  
- HPA settings  
- Environment-specific image tags  

---

## 6. Observability Stack

### Metrics – Prometheus
- Scrapes `/metrics` endpoint  
- Tracks resource usage (CPU, memory)  
- Custom metrics:
  - `http_requests_total`
  - `http_request_duration_seconds`

### Logging – Loki
- JSON logs emitted by FastAPI  
- Viewed in Grafana Explore  
- Filtered using:
  ```
  {app="fastapi"}
  ```

### Dashboards – Grafana
- Request breakdown  
- Latency (avg, p90, p99)  
- Pod restarts  
- Traffic & health  
- Resource usage  

### Alerting – Alertmanager
HighPodRestartRate alert:

```
expr: increase(kube_pod_container_status_restarts_total[5m]) > 0
for: 1m
severity: warning
```

Alerts transition correctly between inactive → pending → firing → resolved.

---

## 7. Autoscaling (HPA)
HPA configured based on CPU.

Scaling tested using:

```
/burn
```

Scaling validated using:

```
kubectl get hpa -n app
kubectl get pods -n app
```

---

## 8. CI/CD Pipeline (GitHub Actions)
Pipeline performs:

1. Build FastAPI Docker image  
2. Push image to GHCR  
3. Authenticate to Kubernetes  
4. Deploy with Helm  

---

## 9. Local Development
Run locally:

```
uvicorn app.main:app --reload
```

Build container:

```
docker build -t fastapi-observability:local .
```

---

## 10. Deployment Instructions

Install:

```
helm install fastapi ./helm/fastapi -n app
```

Upgrade:

```
helm upgrade fastapi ./helm/fastapi -n app
```

Uninstall:

```
helm uninstall fastapi -n app
```

---

## 11. Folder Structure
```
.
├── app/
├── helm/
│   └── fastapi/
│       ├── templates/
│       ├── values.yaml
│       ├── values-prod.yaml
├── .github/workflows/
│   └── deploy.yaml
├── Dockerfile
└── README.md
```

---

## 12. Screenshots & Demo Evidence

### 📌 Grafana – Loki Logs (JSON Structured Logs)
<img width="1904" height="901" alt="image" src="https://github.com/user-attachments/assets/d63bbdc5-633b-4fdc-8ff6-9c3cce9268f9" />



### 📌 Grafana – Request Breakdown
<img width="1916" height="1019" alt="image" src="https://github.com/user-attachments/assets/ce302eaa-785e-4949-9e59-4ee34c524c4e" />




### 📌 Grafana – Resource Usage (CPU & Memory)
<img width="1916" height="1018" alt="image" src="https://github.com/user-attachments/assets/8a7928d8-95fb-44e9-9122-85316310a0d4" />


### 📌 Grafana – Latency p90/p99
<img width="1909" height="829" alt="image" src="https://github.com/user-attachments/assets/18193cde-002b-4387-8d8b-f1e68de00972" />


### 📌 Grafana – Pod Restarts & Traffic
<img width="1910" height="1028" alt="image" src="https://github.com/user-attachments/assets/efd46229-4d09-4921-ab68-f6ed71b449ae" />


### 📌 Alertmanager Email – Firing
<img width="1917" height="985" alt="image" src="https://github.com/user-attachments/assets/9942a29c-7335-40ca-9ed2-630485284d68" />


### 📌 Alertmanager Email – Resolved
<img width="1908" height="944" alt="image" src="https://github.com/user-attachments/assets/1b8ee32e-25e8-4413-b73c-577fa1bfc209" />


### 📌 HPA Scaling During Load Test
  <img width="940" height="388" alt="image" src="https://github.com/user-attachments/assets/ffec0429-1984-4084-8da3-3d301ca73791" />
  <img width="940" height="388" alt="image" src="https://github.com/user-attachments/assets/afe12a29-389f-4653-9b5e-eca2a500605e" />
  <img width="940" height="359" alt="image" src="https://github.com/user-attachments/assets/09ed35ef-835f-4cc6-a5e4-dc842b54ed25" />




### 📌 Load Generation Script Used
<img width="1120" height="202" alt="image" src="https://github.com/user-attachments/assets/24273216-7a4b-43a2-b29c-51de8398774c" />


### 📌 Production Namespace Deployment
<img width="1097" height="230" alt="image" src="https://github.com/user-attachments/assets/e0624d06-703e-40a8-9d0a-7bc3297efe0c" />


### 📌 GitHub Actions – CI/CD Pipeline Run
<img width="1904" height="879" alt="image" src="https://github.com/user-attachments/assets/cb0ae256-5c61-4c77-8853-e53a6d55c121" />

---

## 13. Results & What I Acheived
This project simulates real-world DevOps and SRE capabilities:

- Built full observability into a microservice  
- Deployed and managed Kubernetes workloads  
- Configured alerting rules and monitoring health  
- Automated releases via CI/CD  
- Used HPA to maintain availability under load  
- Implemented structured logging with Loki  
- Managed dev/prod environments with Helm  

---

## 14. Future Improvements
- Distributed tracing (Tempo or Jaeger)  
- Error budgets and SLOs  
- Canary/Blue-Green deployments  
- Ingress improvements  
- More detailed dashboards  

---

## 15. Contact
- **LinkedIn:** https://www.linkedin.com/in/oluwaseyi-abiola  
- **GitHub:** https://github.com/Larriephill  
