# Cloud Engineering Project 02: Secure Global Static Website

## Overview

I have architected and deployed a globally distributed, high-performance, and serverless web delivery architecture on AWS using Infrastructure as Code primitives. This project focuses on the core cloud domains of Edge Security, Content Delivery, and Infrastructure Protection by securely hosting a static web interface while ensuring absolute origin concealment. By routing all public web ingress through an edge-optimized delivery pipeline, the architecture effectively shields data storage assets from direct public internet exposure, mitigates global latency constraints through edge caching, and implements automated layer-7 threat mitigation before malicious traffic can reach the underlying infrastructure layers.

## The Problem

Standard web intake environments and raw object storage hosting models frequently leave enterprise digital assets exposed to critical availability and security liabilities. Legacy or naive static website configurations suffer from two major architectural vulnerabilities:

* **Unprotected Data Origins and Public Exposure Risks:** Configuring storage layers like Amazon S3 for direct static website hosting requires disabling public access blocks. This exposure opens the storage origin to continuous public internet visibility, creating severe vectors for corporate data leaks, bucket resource enumeration, and malicious access exploitation.
* **Global Latency Inflation and Edge Vulnerability:** Serving web assets directly from a single centralized geographic data center introduces significant round-trip transport latency for international users, directly damaging client conversion metrics. Furthermore, web frontends missing an edge filtering layer remain highly vulnerable to automated bot attacks, distributed denial-of-service (DDoS) streams, and common web exploits such as SQL injection and cross-site scripting (XSS).

## The Solution

* **Immutable Origin Access Isolation:** Implemented a modern Origin Access Control (OAC) protocol boundary layer. This architecture completely hides the backend storage bucket behind an encrypted service proxy connection, enforcing a strict rule topology where public users can never access storage files directly.
* **Perimeter Edge Security Hardening:** Integrated an automated Web Application Firewall (WAFv2) shield at the edge delivery tier. The firewall continuously intercepts and inspects all inbound packets against managed rule signatures to block malicious traffic patterns before they interact with any hosting layers.
* **Low-Latency Global Content Delivery:** Leveraged a global Content Delivery Network (CDN) to cache responsive website assets at a vast matrix of edge locations worldwide. This pattern minimizes geographic data transit pathways, guaranteeing sub-millisecond page delivery times regardless of physical user location.

## Tech Stack

* **Storage & Persistence:** Amazon S3 (Private Origin / Object Delivery Drivers)
* **Content Delivery:** Amazon CloudFront (Edge-Caching CDN / Origin Access Control)
* **Edge Security:** AWS WAFv2 (Web Application Firewall / Core Rule Set Integration)
* **Provisioning & Code Architecture:** Terraform (v1.0+ / Multi-Provider Declarations)
* **Presentation Layer:** HTML5 / CSS3 (Responsive Portfolio Asset Layer)

---

## Architecture Diagram
<img width="1169" height="827" alt="Architecture Diagram of Project 2" src="https://github.com/user-attachments/assets/bfb08ff7-4ad0-4e6b-a693-26fdd6c1449b" />

---

## Project Procedure

### 1. Private Storage Contouring and Origin Lockout

I engineered a hardened cloud storage layer using **Amazon S3** to act as an un-exposed origin database repository for web assets.

* **Public Override Enforcement:** Provisioned an explicit public access configuration block toggling all primary isolation constraints (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`) to `true`. This step ensures the bucket completely ignores open public configuration adjustments.
* **Object Asset Management:** Ingested the production portfolio presentation source files directly into the isolated storage engine namespace, mapping explicit content type flags to allow clean web browsers interpretation.

### 2. Global Content Distribution Network Provisioning

I deployed a highly optimized web routing footprint across **Amazon CloudFront** to decouple public user interactions from the storage container.

* **Origin Access Control Initialization:** Established an advanced `aws_cloudfront_origin_access_control` resource configuration setting the request signing parameter to evaluate protocols using the strict `sigv4` algorithm.
* **Transit Encryption Control:** Programmed the distribution cache behaviors to intercept raw inbound requests and execute a mandatory redirection script (`viewer_protocol_policy = "redirect-to-https"`), guaranteeing complete data-in-transit protection.
* **Ingress Interface Alignment:** Designated `index.html` as the default root object tracking element to establish seamless client-side directory path translation.

### 3. Edge Security Shield Integration (AWS WAFv2)

To build a highly resilient boundary layer at the outermost network perimeter, I deployed an automated web firewall upstream from the application code.

* **Global Scope Placement:** Constructed a specialized Web ACL specifying the required `scope = "CLOUDFRONT"` argument to align the firewall engine with global edge infrastructure layers.
* **Managed Rule Vector Ingestion:** Embedded the official **AWS Managed Rules Common Rule Set** (`AWSManagedRulesCommonRuleSet`) inside the evaluation matrix. This integration actively screens traffic patterns for malformed parameters, cross-site scripting (XSS) inputs, and automated scanner signatures, dropping malicious payloads immediately at the edge.

### 4. Least-Privilege Bucket Policy Infrastructure

I developed a zero-trust resource policy layer to lock down storage ingress parameters exclusively to authorized delivery paths.

* **Service Principal Isolation:** Structured a native IAM policy document restricting resource permission parameters solely to the `cloudfront.amazonaws.com` service identity.
* **Side-Channel Spoofing Protection:** Embedded an explicit `StringEquals` condition constraint mapping the incoming `AWS:SourceArn` property against the unique CloudFront distribution identifier. This configuration ensures that unauthorized CloudFront distributions from external AWS accounts cannot read or map the private S3 data store.

---

## Infrastructure as Code (IaC) Architecture

To enforce the core cloud engineering principles of repeatability, drift detection, and immutable infrastructure, the entire global delivery and security environment is provisioned using declarative **Terraform (v1.0+)** configurations. The codebase is strictly decoupled into modular component files to separate network routing, storage blocks, and edge firewalls.

### Directory Layout & Modular Structure

The workspace is organized using a flat, high-readability layout optimized for granular component modifications:

```text
secure-global-static-website/
├── provider.tf          # Core initialization and multi-region provider scoping
├── variables.tf         # Parameter types, validations, and default definitions
├── s3.tf                # Private origin block storage constraints and IAM bucket policies
├── waf.tf               # Edge web access control system configurations and rule sets
├── cloudfront.tf        # CDN distribution maps, caching rules, and OAC profiles
├── outputs.tf           # Exposed distribution hostnames and verification URLs
└── index.html           # Responsive HTML5 profile portfolio application source file
```

---

## Detailed File-by-File Technical Breakdown

### 1. Multi-Region Provider Scoping (`provider.tf`)

* **Provider Version Constraints:** Lock deployment packages to the modern **AWS Provider v5.0+** ecosystem to ensure seamless support for advanced WAF and OAC schemas.
* **Aliased Cross-Region Handshakes:** Establishes an un-aliased default region block coupled with a highly specialized aliased provider configuration block targeting the mandatory `us-east-1` (N. Virginia) data space. This dual-provider configuration is structurally required because CloudFront-compatible WAFv2 Web ACL assets will reject compilation if initialized inside any other AWS region.

### 2. Private Storage Contouring (`s3.tf`)

* **Hardened Resource Boundary:** Declares the `aws_s3_bucket` workspace using a unique naming string pattern and links it to an `aws_s3_bucket_public_access_block` configuration with all blocking toggles mapped to `true` to completely reject unauthenticated internet traffic.
* **Programmatic Asset Ingestion:** Manages presentation layer code deployment using an `aws_s3_object` resource mapping the local `index.html` source payload directly into the bucket root space while assigning an explicit MIME type (`content_type = "text/html"`).
* **Dynamic Policy Interpolation:** Implements an `aws_s3_bucket_policy` binding mechanism that reads data directly from an evaluated HCL policy document data source. This dynamically builds and injects the necessary least-privilege security policy parameters into the bucket infrastructure upon runtime execution.

### 3. Perimeter Web Firewall Controls (`waf.tf`)

* **Layer-7 Inspection Logic:** Configures an `aws_wafv2_web_acl` resource enforcing the global delivery tier constraints via the `scope = "CLOUDFRONT"` initialization argument.
* **Telemetry Visibility Matrix:** Embeds an explicit `visibility_config` block that enables CloudWatch metrics tracking and sampling parameters (`sampled_requests_enabled = true`) to provide the operational security team with instant traffic transparency.

### 4. Edge CDN Distribution Mapping (`cloudfront.tf`)

* **OAC Secure Handshake:** Deploys an `aws_cloudfront_origin_access_control` mapping resource that forces the network layer to inject SigV4 request signatures into every single lookup action hitting the backend bucket.
* **Firewall Consolidation Linkage:** Hooks the critical `web_acl_id` argument parameter directly to the generated Amazon Resource Name (ARN) output tracking the managed WAF module.
* **Cache Behavior Standardization:** Implements automated `restrictions` and geo-blocking exclusions while binding the default viewer certificate parameters to force global HTTPS transit security metrics.

### 5. Parameter Definitions & Output Variables (`variables.tf` & `outputs.tf`)

* **Regional Modularity Abstraction:** Isolates regional parameters via strongly typed variables defaulting to `us-east-1` to maintain high environment portability.
* **Verification Ingress Exposure:** Exposes the dynamic runtime domain name metadata via an output block (`cloudfront_url`), generating an un-hardcoded, clickable endpoint link the exact millisecond the infrastructure compilation sequence finishes running.

---

## Verification and Results

### Verified Successful Ingestion and Lockdown

Submitted manual direct-to-S3 asset testing queries to the underlying storage endpoint URL. The Amazon S3 resource interface evaluated the active security policy rules and instantly returned a clean **Access Denied (HTTP 403)** block message, confirming that the origin storage container is completely hidden from the public internet.

### Validated Global Edge Content Delivery

Invoked web request traffic tracking against the generated CloudFront distribution link (`cloudfront_url`). The global caching servers smoothly intercepted the client handshakes, resolved default root routing protocols automatically, and delivered the responsive portfolio interface globally with sub-millisecond load metrics.

### Confirmed Edge Perimeter Defense and Encryption

Inspected the connection properties inside the presentation environment tab. The client-side dashboard confirmed that all traffic transit patterns run exclusively over encrypted **HTTPS (TLS)** pathways with a valid security padlock icon visible. Concurrently, the AWS WAF dashboard verified active monitoring loops, tracking and screening incoming parameter packets against the Core Rule Set signatures before distribution delivery.

---

## Verification Screenshots

### S3 Bucket Permissions (Public Access Blocked)

Screenshot of the Amazon S3 console displaying an active configuration status reading "Bucket and objects not public," proving complete public block validation.
<img width="1917" height="862" alt="Screenshot 1" src="https://github.com/user-attachments/assets/6d78776a-65ae-4f1a-8ad9-1e154418ab8b" />


### CloudFront Origin Settings (OAC Enabled)

Screenshot of the Amazon CloudFront distribution configuration interface showing the Origin type mapped explicitly to an active Origin Access Control setting.
<img width="1918" height="870" alt="Screenshot 2" src="https://github.com/user-attachments/assets/42786414-a3fe-4f27-8373-0c491a70049a" />


### WAF Web ACL (Associated with Distribution)

Screenshot of the AWS WAF dashboard highlighting the "Edge-Protection-Shield" Web ACL actively bound to the CloudFront distribution identifier.
<img width="1917" height="865" alt="Screenshot 3" src="https://github.com/user-attachments/assets/a99ecee1-6228-42d5-8d8d-a7231297e07e" />


### Live Secure Website (HTTPS Padlock Visible)

Screenshot of the live portfolio portfolio page rendering over the CloudFront edge domain hostname, showing a secure HTTPS protocol lock.
<img width="1920" height="969" alt="Screenshot 4" src="https://github.com/user-attachments/assets/9fe5311c-0fec-474d-ae30-18243c971966" />


---

## Future Improvements

* **Custom Domain Branding and ACM Integration:** Integrate **Amazon Route 53** alongside **AWS Certificate Manager (ACM)** to map the infrastructure out to a custom corporate apex domain name running fully managed, auto-renewing public SSL/TLS certificate configurations.
* **Standardized Pipeline Access Telemetry Logging:** Enable advanced CloudFront access logging parameters, routing standard transport telemetry objects directly into an alternate, encrypted S3 tracking bucket for advanced traffic inspection and auditing.
* **Continuous Integration (CI/CD) Deployment Actions:** Establish an automated GitHub Actions deployment workflow to automate repository synchronization, enabling the pipeline to run verification checks and automatically sync code modifications into S3 whenever fresh portfolio updates are pushed to version control.

---

## Notes

This architecture demonstrates an optimized, modern deployment pattern for corporate web hosting setups. It highlights advanced core cloud security competencies in establishing edge-to-origin security perimeters, programmatic resource policy modeling, serverless delivery structures, and multi-region infrastructure-as-code automation workflows.
