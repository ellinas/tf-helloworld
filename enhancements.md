1. Paramaterise any lingering hard coded vars
2. Custom/bespoke docker image and image repository (ECR or other)
3. Better fault tolerance/availability, e.g. more replicas and multi AZ
4. Lock down permissions of AWS user (principle of least privilege)
5. Create certificate and enable HTTPS listener/redirect
6. Encrypt SNS topic
7. Use EKS instead of ECS
8. Use a more robust CI/CD tool (gitlab, argo, circle or other)
9. Use a more robust monitoring/observability tool (Grafana/Prometheus, datadog or other)
10. Convert setup into a module to generalise deployments/allow for easier setup