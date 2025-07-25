# 🏥 Hospital Billing Management System

![System Architecture Diagram](system_architecture.png)
*Figure 1: High-level system architecture*

## 📋 Overview

A comprehensive solution for managing patient billing, treatment records, and financial reporting in healthcare facilities.

## ✨ Key Features

| Feature | Description | Visual |
|---------|-------------|--------|
| Patient Registration | Capture demographic and insurance details | ![Patient Registration](patient_reg.png) |
| Treatment Tracking | Record medications, procedures, and services | ![Treatment Screen](treatment_ui.png) |
| Automated Billing | Generate invoices with tax calculations | ![Invoice Sample](invoice_sample.png) |
| Reporting Dashboard | Financial and operational analytics | ![Dashboard](analytics_dash.png) |

## 🛠️ Technical Components

```mermaid
graph TD
    A[HTML Form] --> B[Python Backend]
    B --> C[(SQL Database)]
    C --> D[Reporting Engine]
    D --> E[Excel/PDF Outputs]
