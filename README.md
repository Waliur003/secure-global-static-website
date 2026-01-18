# Cloud Engineering Project 02: Secure Global Static Website

## Overview
I have deployed a globally distributed, high-performance web architecture using a serverless stack on AWS. This project focuses on Infrastructure Protection and Content Delivery by ensuring that a static website is securely hosted and protected against common web threats at the edge.

## The Problem
Publicly accessible S3 buckets are a common security risk, often leading to data exposure. Furthermore, hosting a website directly from a single region can result in high latency for global users and leaves the site vulnerable to bot attacks and web exploits.

## The Solution
### Origin Protection
I have implemented Origin Access Control (OAC) to ensure the S3 bucket remains private and only accessible via CloudFront.

### Edge Security
I have integrated AWS WAF to inspect traffic and block malicious requests like SQL injection and cross-site scripting (XSS) before they reach the origin.

### Global Performance
I have utilized Amazon CloudFront to cache content at edge locations worldwide, ensuring low-latency delivery for users regardless of their location.

## Tech Stack
- Storage: Amazon S3 (Private Origin)
- Security: AWS WAF (Web Application Firewall)
- Delivery: Amazon CloudFront (CDN)
- DNS & SSL: Amazon Route 53 & AWS Certificate Manager (ACM)

## Project Procedure
I have designed and implemented a "Security-First" web architecture. Below is the step-by-step procedure I have followed:

### 1) Private S3 Hosting & OAC
- I have configured an Amazon S3 bucket with "Block all public access" enabled.
- I have established an Origin Access Control (OAC) setting in CloudFront.
- I have updated the S3 Bucket Policy to allow read access only to the specific CloudFront distribution service principal.

### 2) Global Content Delivery (CloudFront)
- I have deployed a CloudFront Distribution to act as a CDN for the static assets.
- I have enforced HTTPS-only communication to ensure all data is encrypted in transit.
- I have configured the Default Root Object to index.html for seamless user navigation.

### 3) Edge Security Implementation (WAF)
- I have associated an AWS WAF Web ACL with the CloudFront distribution.
- I have enabled AWS Managed Rule Groups, including the "Core Rule Set" and "IP Reputation" list, to mitigate common cyber threats.

### 4) Deployment & Verification
- I have uploaded a professional, responsive index.html portfolio page to the S3 bucket.
- I have verified that direct S3 access returns an "Access Denied" (403) error, confirming origin protection.
- I have successfully confirmed that the website is accessible via the CloudFront Domain Name over a secure HTTPS connection.

## Architecture Diagram

## Screenshots
- S3 Bucket Permissions (Public Access Blocked)
- CloudFront Origin Settings (OAC Enabled)
- WAF Web ACL (Associated with Distribution)
- Live Secure Website (HTTPS Padlock Visible)

## Notes / Future Improvements
- Implement Infrastructure as Code (IaC) using Terraform to automate the deployment of the entire stack.
- Integrate Amazon Route 53 with a custom domain and ACM for professional branding.
- Enable CloudFront Standard Logging to an S3 bucket for advanced traffic analysis.
