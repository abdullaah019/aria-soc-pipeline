# Security and Publication Boundaries

This public repository explains ARIA at an architectural level. Operational source, customer data, secrets, and sensitive controls stay outside this repository.

## Safe public material

- Sanitized architecture diagrams
- Component responsibilities
- General alert lifecycle
- Evidence and provenance concepts
- High-level security controls
- Non-sensitive screenshots
- Implementation status without internal thresholds

## Material kept private

- API keys, tokens, passwords, certificates, and JWT secrets
- Environment files and production configuration
- Customer names, tenant identifiers, emails, hostnames, IP addresses, and telemetry
- Exact auto-resolution thresholds and veto logic
- Detection, suppression, and allowlist internals
- Private prompts and decision policies
- Connector authentication details
- Production network addresses, database identifiers, and service paths
- Known vulnerabilities and active incident details

## Repository controls

The project should enforce:

- No real `.env` files
- Secret scanning before every push
- Protected default branches
- Pull-request review for documentation and code changes
- Sanitized examples using fictional identifiers
- Clear labels for implemented, partially implemented, planned, and production-verified capabilities

## Status language

Use these labels consistently:

| Label | Meaning |
|---|---|
| Implemented | Code exists in the relevant source repository. |
| Partially implemented | Some components exist, but the end-to-end path is incomplete. |
| Planned | Design exists without a complete implementation. |
| Production verified | Runtime health, release identity, and expected behavior were verified after deployment. |

A passing local test does not equal production verification. A diagram does not prove deployment.
