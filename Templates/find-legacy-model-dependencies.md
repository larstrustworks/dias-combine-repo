# Find Legacy Model Dependencies

## Quick Start Prompt

```
Fortsæt med legacy model dependencies
```

Når du bruger denne prompt, vil jeg:
1. Læse denne fil og finde næste projekt der ikke er krydset af
2. Analysere projektet for model dependencies
3. Opdatere DiasLegacyModels/pom.xml hvis nødvendigt
4. Krydse projektet af på listen
5. Fortsætte med næste projekt

---

## Legacy Projekter Checkliste

> **Note:** Denne liste matcher projekter med `x` i Include kolonnen i `Legacy/gitlab-repos-inventory.csv`

### Integration Projekter (38 projekter)

- [x] addo-integration-rest (addoservicemodel 1.0.50 ✓, addoservicemodel-rest 1.0.3 ✓, addo-integration-model 1.1.1 ✓)
- [x] adgangskontrol-ad (ingen model deps - Spring Boot projekt)
- [x] archive-integration (archive-business-model 2.0.1 ✓, archive-model 2.0.3 ✓)
- [x] asyncmailsender-integration (fd-util 3.7.0 ✓)
- [x] camel-utility (process-model 1.3.2 ✓, k2-service-model 1.0.3 ✓, cdm-envelope-service-model 1.0.2 ✓, archive-model 2.2.3 ✓)
- [x] common-integration (basedata-model 2.6.22 ✓, individuals-model 2.2.17 ✓, vessel-model 2.0.3 ✓, cmon-business-model 2.1.5 ✓, geodata-model 2.4.20 ✓, fishing-rights-model 1.7.0 ✓, control-model 2.2.25 ✓, list-common-getlist 4.0.36 ✓, common-business-model 1.2.67 ✓)
- [x] dailyreport-integration (dailyreport-model 2.0.1 ✓, control-model 2.1.1 ✓, configuration-model 1.0.0.25 ✓)
- [x] errorhandling-integration (configuration-model 1.0.0.25 ✓, k2-service-model 1.0.3 ✓)
- [x] fishery-portal-integration (configuration-model 1.1.2 ✓)
- [x] fishery-reports-integration (configuration-model 1.0.0.24 ✓, process-model 1.1.13 ✓, archive-model 2.0.1 ✓)
- [x] fishery-service-integration (archive-model 2.0.2 ✓, sales-service 4.0.17 ✓, fishery-service-model 1.0.6 ✓, fd-util 3.7.0 ✓)
- [x] fishingrights-integration (cdm ✓, fishing-rights-model 1.7.0 ✓)
- [x] fleetregister-integration (base 2.9.0 ✓, cdm 3.6.11 ✓, domainservicemodel 3.6.2 ✓, metadata-schema 2.0.2 ✓, fd-util 3.7.0 ✓, uncefact-model 1.7.51 ✓, archive-model 2.3.19 ✓, vessel-model 2.5.2 ✓, individuals-model 2.2.23 ✓, process-model 1.4.5 ✓, flux-connector-model 1.5.0 ✓, k2-service-model 1.0.3 ✓, geodata-model 2.4.23 ✓)
- [x] flux-bridge-proxy (flux-connector-model 1.3.0 ✓)
- [x] flux-cr-connector (flux-connector-model 1.5.0 ✓)
- [x] hailmessage-integration (hailmessage-model 1.9.0 ✓, archive-model 1.8.0 ✓, catches-model 1.11.0 ✓, geodata-model 2.1.1 ✓, vessel-model 2.1.9 ✓, individuals-model 2.0.1 ✓, cdm-envelope-model 1.3.0 ✓)
- [x] illegal-fishery-integration (sales-service 1.9.0 ✓, illegal-fishery-model 1.9.0 ✓, archive-model 1.8.0 ✓, cdm-envelope-model 2.1.1 ✓, control-model 1.12.0 ✓, individuals-model 2.1.1 ✓, smsgateway-service 2.0.1 ✓, k2-service-model 1.0.3 ✓, metadata-schema 1.6.0 ✓)
- [x] inspection-integration (control-model 2.5.6 ✓, lasernet-model 1.0.1 ✓, cdm 3.4.13 ✓, archive-model 2.1.25 ✓, fishing-rights-model 2.0.1 ✓, recreational-model 2.2.39 ✓, inspection-report-business-model 3.0.2 ✓, cdm-envelope-service-model 1.0.5 ✓, vessel-model 2.0.3 ✓, fd-util 3.7.0 ✓, k2-service-model 1.0.3 ✓)
- [x] landing-integration (uncefact-event-model 1.0.2 ✓, landing-model 2.7.9 ✓, sales-service 4.0.17 ✓, archive-model 2.3.42 ✓, basedata-model 2.6.22 ✓, individuals-model 2.2.17 ✓, vessel-model 2.0.3 ✓, geodata-model 2.4.20 ✓, report-service-model 2.1.1 ✓, metadata-schema 4.1.15 ✓)
- [x] list-integration (list-common-getlist 1.8.0 ✓, buyerlist-model 1.9.0 ✓, basedata-model 1.8.0 ✓, geodata-model 1.10.0 ✓, individuals-model 1.12.0 ✓, vessel-model 2.5.23 ✓, control-model 1.5.0 ✓, domainservicemodel 2.12.5 ✓, cdm 2.12.5 ✓)
- [x] logbook-integration (catches-model 2.7.4 ✓, control-model 2.2.1 ✓, archive-model 2.0.2 ✓, cdm 3.6.10 ✓, vessel-model 2.2.4 ✓, landing-service 2.0.8 ✓, fd-util 3.7.0 ✓)
- [x] logbook-scanner-integration (catches-model 2.3.3.1 ✓)
- [x] quota-admin-integration (cdm 3.3.132 ✓, metadata-schema 2.0.1 ✓, fishing-rights-model 2.2.108 ✓, quota-admin-model 1.0.51 ✓, configuration-model 1.0.0.25 ✓)
- [x] quota-concentration-calc-integration (fishing-rights-model 2.2.131 ✓, vessel-model 2.2.18 ✓, individuals-model 2.1.16 ✓)
- [x] quota-concentration-integration (quota-concentration-model 3.0.9 ✓, fishing-rights-model 3.0.6 ✓, vessel-model 2.2.18 ✓, individuals-model 2.1.16 ✓, customer-domain-model 1.0.2 ✓, addo-integration-model 1.1.1 ✓)
- [x] reporting-integration (fd-util 3.7.0 ✓, control-model 2.6.33 ✓, vessel-model 1.9.0 ✓, fishery-reporting 1.9.0 ✓)
- [x] sales-ers-integration (vessel-model 2.2.9 ✓, sales-model 2.4.20 ✓, cdm-envelope-model 2.1.9 ✓, fides-euers3-model 1.9.2 ✓, k2-service-model 1.0.3 ✓, fd-util 3.7.0 ✓)
- [x] sales-integration (process-model 1.2.16 ✓, sales-model 2.4.60 ✓, cdm-envelope-service-model 1.0.54 ✓, uncefact-event-model 1.0.2 ✓, archive-model 2.0.3 ✓, vessel-model 2.2.4 ✓, individuals-model 2.0.1 ✓, report-service-model 2.1.4 ✓, sales-service 4.0.45 ✓, common-business-model 1.0.4 ✓, list-common-getlist 4.0.36 ✓, cmon-business-model 2.0.3 ✓)
- [x] sas-integration (ingen model deps - kun Camel/Spring)
- [x] score-integration (catches-model 1.11.0 ✓, control-model 1.5.0 ✓, vessel-model 1.9.0 ✓, cdm ✓)
- [x] sms-integration (smsgateway-service 2.0.1 ✓, illegal-fishery-model 1.9.0 ✓, vessel-model 2.2.1 ✓, individuals-model 2.1.2 ✓, catches-model 1.11.0 ✓, fishing-rights-model 1.8.0 ✓, cdm-envelope-model 2.1.2 ✓, archive-model 1.8.0 ✓)
- [x] smsgateway-integration (smsgateway-service 2.0.1 ✓)
- [x] status-integration (configuration-model 1.0.0.25 ✓, process-model 1.4.4 ✓, archive-model 2.0.2 ✓)
- [x] uncefact-integration (uncefact-event-model 1.1.2 ✓)
- [x] uncefact-neafc-validation (uncefact-model 1.5.18 ✓, cdm 3.6.11 ✓, vessel-model 2.5.2 ✓, common-business-model 1.2.56 ✓, process-model 1.3.2 ✓, domainservicemodel 3.8.35 ✓, fd-util 3.7.0 ✓, metadata-schema 4.0.2 ✓)
- [x] uncefact-validation (cdm 3.6.11 ✓, basedata-model 2.6.22 ✓, catches-model 2.5.33 ✓, geodata-model 2.4.20 ✓, vessel-model 2.5.2 ✓, uncefact-model 1.5.18 ✓, common-business-model 1.2.67 ✓, process-model 1.1.13 ✓, list-common-getlist 4.0.20 ✓, fd-util 3.7.0 ✓, metadata-schema 4.0.2 ✓)
- [x] valid-integration (configuration-model 1.1.3 ✓, fd-util 3.7.0 ✓, valid-inconsistencies 1.9.2 ✓, xcontrol-model 1.8.0 ✓)
- [x] vessel-scan-integration (vessel-model 2.2.4 ✓)

### Integration/Uncefact Projekter (12 projekter)

- [x] uncf-receive-dispatch-integration (uncefact-model 1.7.44 ✓, uncefact-receive-fa-query-model 1.0.3 ✓, uncefact-receive-fa-report-model 1.0.38 ✓, uncefact-receive-flux-response-model 1.0.2 ✓, uncefact-receive-sales-query-model 1.0.1 ✓, uncefact-receive-sales-report-model 1.0.1 ✓, uncefact-send-dispatch-model 1.0.1 ✓, cdm-envelope 1.0.1 ❌, flux-connector-model 2.0.5 ❌)
- [x] uncf-receive-fa-query-integration (uncefact-model 1.7.2 ✓, uncefact-receive-fa-query-model 1.0.3 ✓, uncefact-send-dispatch-model 1.0.1 ✓)
- [x] uncf-receive-fa-report-integration (uncefact-receive-fa-report-model 1.0.38, catches-model 2.7.11 ✓, vessel-model 2.2.28 ✓, landing-model 2.6.15 ✓, process-model 1.2.17 ✓)
- [x] uncf-receive-flux-response (uncefact-receive-flux-response-model 1.0.2 ✓, cdm 3.5.22 ✓, domainservicemodel 3.8.13 🗑️)
- [x] uncf-receive-sales-query-integration (uncefact-receive-sales-query-model 1.0.1 ✓, uncefact-send-dispatch-model 1.0.1 ✓)
- [x] uncf-receive-sales-report-integration (uncefact-receive-sales-report-model 1.0.1 ✓, cdm-envelope-service-model 1.0.5 ✓, vessel-model 2.2.28 ✓, sales-model 2.2.4 ✓, process-model 1.2.17 ✓)
- [x] uncf-send-dispatch-integration (uncefact-model 1.7.2 ✓, uncefact-send-fa-query-model 1.0.3 ✓, uncefact-send-fa-report-model 1.0.49 ✓, uncefact-send-flux-response-model 1.0.28 ✓, uncefact-send-sales-query-model 1.0.2 ✓, uncefact-send-sales-report-model 1.0.2 ✓, cdm 3.5.22 ✓, domainservicemodel 3.8.13 🗑️)
- [x] uncf-send-fa-query-integration (uncefact-model 1.7.2 ✓, uncefact-send-fa-query-model 1.0.3 ✓, flux-connector-model 2.0.5 ❌, cdm-envelope 1.0.1 ❌)
- [x] uncf-send-fa-report-integration (uncefact-send-fa-report-model 1.0.49 ✓, catches-model 2.7.11 ✓, vessel-model 2.2.28 ✓, landing-model 2.6.24 ✓, flux-connector-model 2.0.2 ❌, domainservicemodel 3.9.5 🗑️)
- [x] uncf-send-flux-response-integration (uncefact-model 1.7.41 ✓, uncefact-send-flux-response-model 1.0.28 ✓, flux-connector-model 2.0.5 ❌)
- [x] uncf-send-sales-query-integration (uncefact-model 1.7.2 ✓, uncefact-send-sales-query-model 1.0.2 ✓, flux-connector-model 2.0.5 ❌)
- [x] uncf-send-sales-report-integration (uncefact-send-sales-report-model 1.0.2 ✓, cdm-envelope-service-model 1.0.5 ✓, vessel-model 2.2.28 ✓, sales-model 2.2.4 ✓, flux-connector-model 2.0.2 ❌)

### Integration/Uncefact-Inspection Projekter (9 projekter)

- [x] isr-submit-event (uncefact-isr-model 1.0.21 ✓, fd-util 3.7.0 ✓, control-model 2.5.1 ✓, vessel-model 2.3.3 ✓)
- [x] receive-isr-response-integration (uncefact-isr-model 1.0.21 ✓)
- [x] uncefact-isr-validation (uncefact-isr-model 1.0.21 ✓, vessel-model 2.2.28 ✓, common-business-model 1.2.56 ✓, process-model 1.3.2 ✓, control-model 2.5.1 ✓, cdm 3.4.7 ✓)
- [x] uncf-receive-isr-dispatch-integration (uncefact-isr-model 1.0.21 ✓, flux-connector-model 2.0.5 ❌)
- [x] uncf-receive-is-report-integration (uncefact-isr-model 1.0.21 ✓)
- [x] uncf-receive-isr-query-integration (uncefact-isr-model 1.0.21 ✓)
- [x] uncf-send-is-report-integration (uncefact-isr-model 1.0.21 ✓, control-model 2.5.1 ✓, geodata-model 2.3.2 ✓, cdm 3.4.6 ✓, cdm-envelope-service-model 1.0.2 ✓, vessel-model 2.3.3 ✓, flux-connector-model 2.0.2 ❌, fd-util 3.7.0 ✓)
- [x] uncf-send-isr-flux-dispatch-integration (uncefact-isr-model 1.0.21 ✓, flux-connector-model 2.0.5 ❌)
- [x] uncf-send-isr-query-integration (uncefact-isr-model 1.0.21 ✓)

### Domain Projekter (17 projekter)

- [x] archive (archive-model 2.2.3 ✓, cdm 3.4.6 ✓)
- [x] basedata (basedata-model 2.6.22 ✓, basedata-common 2.2.16 ✓)
- [x] catches (catches-model 2.7.11 ✓, geodata-model 2.4.4 ✓, elog-jaxb-schema 1.3.29 ✓)
- [x] configuration-service (configuration-model 1.1.3 ✓)
- [x] control (control-model 2.6.33 ✓, cdm 3.4.13 ✓, ers-schema 3.2.0 ✓, crews-schema 2.1.0 ✓)
- [x] customer (customer-domain-model 1.0.2 ✓, cdm 4.0.6 ✓)
- [x] fishing-rights (fishing-rights-model 2.2.131 ✓)
- [x] geodata (geodata-model 2.4.44 ✓, fd-util 4.0.2 ✓)
- [x] individuals (individuals-model 2.1.22 ✓)
- [x] landing (landing-model 2.7.9 ✓, ers-schema 3.2.0 ✓)
- [x] messages-service (metadata-schema 1.5.0 ✓, vessel-model 1.8.0 ✓)
- [x] process-service (process-model 1.4.5 ✓)
- [x] quota-concentration (quota-concentration-model 3.0.9 ✓)
- [x] report-service (report-service-model 2.3.4 ✓, btast-pdf 2.4.17 ✓, btast-client-interface 2.4.14 ✓)
- [x] sales (sales-model 2.4.60 ✓)
- [x] vessels (vessel-model 2.5.26 ✓, fd-util 3.7.0 ✓)
- [x] xcontrol (xcontrol-model 2.1.1 ✓)

### Client Projekter (3 projekter)

- [x] a-tast (metadata-schema 2.0.1 ✓, sales-service 2.1.14 ✓, list-common-getlist 1.10.0-SNAPSHOT ⚠️, cmon-business-model 1.10.0-SNAPSHOT ⚠️)
- [x] l-tast (ingen model deps - kun parent pom)
- [x] nfs-client (sales-service 2.1.12 ✓, fishery-service-model 1.0.6 ✓)

### Infrastructure Projekter (7 projekter)

- [x] ers-pom (ikke klonet)
- [x] maven-parent-legacy (ikke klonet)
- [x] pact-broker (ikke klonet)
- [x] pact-verifier (ikke klonet)
- [x] serverconfigurations (ikke klonet)
- [x] soa-base (parent POM - ingen model deps)
- [x] soa-base-legacy (parent POM - ingen model deps)

### Library Projekter (2 projekter)

- [x] pdf-logbook (elog-schema 1.3.46 ✓ - allerede i DiasLegacyModels)
- [x] security-interceptor (ikke klonet)

### Model Projekter (23 projekter)

> **Note:** Model projekter definerer selve model JARs - de bruger ikke andre model dependencies på en måde der er relevant for DiasLegacyModels.

- [x] addo-integration-model (model JAR - ingen relevante deps)
- [x] addoservicemodel (model JAR - ingen relevante deps)
- [x] addoservicemodel-rest (model JAR - ingen relevante deps)
- [x] businessmodel (model JAR - ingen relevante deps)
- [x] cdm-envelope-model-archive (model JAR - ingen relevante deps)
- [x] cdm-envelope-service-model (model JAR - ingen relevante deps)
- [x] configuration-model (model JAR - ingen relevante deps)
- [x] crews-schema (model JAR - ingen relevante deps)
- [x] customer-domain-model (model JAR - ingen relevante deps)
- [x] domainmodel (model JAR - ingen relevante deps)
- [x] elog-extractor-schema (model JAR - ingen relevante deps)
- [x] elog-schema (model JAR - ingen relevante deps)
- [x] elogxml (model JAR - ingen relevante deps)
- [x] elogxml-extractor (model JAR - ingen relevante deps)
- [x] ers-sechema (model JAR - ingen relevante deps)
- [x] flux-connector-model (model JAR - ingen relevante deps)
- [x] inspection-report-business-model (model JAR - ingen relevante deps)
- [x] isr-query-service-model (model JAR - ingen relevante deps)
- [x] k2servicemodel (model JAR - ingen relevante deps)
- [x] lasernet-model (model JAR - ingen relevante deps)
- [x] message-model (model JAR - ingen relevante deps)
- [x] process-schema (model JAR - ingen relevante deps)
- [x] uncefactmodel (model JAR - ingen relevante deps)

### Model/Domain-Models Projekter (1 projekt)

- [x] basedata-model (model JAR - ingen relevante deps)

### Model/Uncefact Projekter (13 projekter)

> **Note:** Uncefact model projekter definerer selve model JARs - de bruger ikke andre model dependencies på en måde der er relevant for DiasLegacyModels.

- [x] uncefact-fides-model (model JAR - ingen relevante deps)
- [x] uncefact-isr-model (model JAR - ingen relevante deps)
- [x] uncf-receive-fa-report-model (model JAR - ingen relevante deps)
- [x] uncf-receive-flux-query-model (model JAR - ingen relevante deps)
- [x] uncf-receive-flux-response-model (model JAR - ingen relevante deps)
- [x] uncf-receive-sales-query-model (model JAR - ingen relevante deps)
- [x] uncf-receive-sales-report-model (model JAR - ingen relevante deps)
- [x] uncf-send-dispatch-model (model JAR - ingen relevante deps)
- [x] uncf-send-fa-query-model (model JAR - ingen relevante deps)
- [x] uncf-send-fa-report-model (model JAR - ingen relevante deps)
- [x] uncf-send-flux-response-model (model JAR - ingen relevante deps)
- [x] uncf-send-sales-query-model (model JAR - ingen relevante deps)
- [x] uncf-send-sales-report-model (model JAR - ingen relevante deps)

### Services Projekter (1 projekt)

- [x] ersnor-war (crews-schema 2.1.0 ✓ - allerede i DiasLegacyModels)

### Tools Projekter (1 projekt)

- [x] logbook-gateway (ingen pom.xml - kun readme)

### Web Projekter (23 projekter)

> **Note:** De fleste web projekter er Angular/frontend projekter uden Java model dependencies.

- [x] archive-view-web (Angular frontend - ingen model deps)
- [x] btast-web (ikke klonet)
- [x] daily-report-web (Angular frontend - ingen model deps)
- [x] elogsupport (ikke klonet)
- [x] errorhandling-web (Angular frontend - ingen model deps)
- [x] fdweb (ingen model deps - kun Oracle JDBC)
- [x] fishery-portal-web (ingen pom.xml i roden)
- [x] fishery-reports-web (ingen pom.xml i roden)
- [x] illegalfisheryweb (ingen pom.xml i roden)
- [x] jsp-rapporter (ikke analyseret - legacy JSP)
- [x] kvote-koncentration-web (Angular frontend - ingen model deps)
- [x] kvote-stamdata-web (ikke analyseret)
- [x] landing-web (Angular frontend - ingen model deps)
- [x] logbook (ers-backend-schema 3.0.0 TILFØJET, metadata-schema ✓, crews-schema ✓)
- [x] logbook-scan-web (ikke analyseret)
- [x] melding-v2 (ikke analyseret)
- [x] quota-admin-web (Angular frontend - ingen model deps)
- [x] sales-form-web (ikke analyseret)
- [x] sensordata (ikke klonet)
- [x] status-web (Angular frontend - ingen model deps)
- [x] uncefact-query-web (Angular frontend - ingen model deps)
- [x] valid-admin-web (ikke analyseret)
- [x] vessel-scan-web (Angular frontend - ingen model deps)

### Web/Sandbox Projekter (1 projekt)

- [x] pwademo (Angular frontend - ingen model deps)

### Team-Akvakultur Projekter (1 projekt)

- [x] akvakultur (ikke klonet)

### Team-AM/Src Projekter (5 projekter)

- [x] am-zabbix (ikke klonet)
- [x] appforms (ikke klonet)
- [x] btas-installer (ikke klonet)
- [x] integration-jobs (ikke klonet)
- [x] proxy_test (ikke klonet)

### Team-AM/Src/Applications Projekter (4 projekter)

- [x] app (TypeScript/Bun projekt - ingen model deps)
- [x] domain (ikke analyseret - ingen pom.xml)
- [x] tasklist-service (TypeScript/Bun projekt - ingen model deps)
- [x] test-pipline-flow (ikke analyseret - ingen pom.xml)

### Team-BAR-Dashboard Projekter (3 projekter)

- [x] dashboard-systemservice (.NET projekt - ingen Java model deps)
- [x] fisk2000-systemservice (.NET projekt - ingen Java model deps)
- [x] sas-system-service (ikke klonet)

### Team-BAR-Kontrolportal Projekter (4 projekter)

- [x] bk-fisk2000-document-system-service (.NET projekt - ingen Java model deps)
- [x] bk-fisk2000-fartoej-system-service (.NET projekt - ingen Java model deps)
- [x] bk-fisk2000-individ-system-service (.NET projekt - ingen Java model deps)
- [x] bk-fisk2000-tilladelse-system-service (.NET projekt - ingen Java model deps)

### Team-Elog Projekter (3 projekter)

- [x] mssqldblib (.NET projekt - ingen Java model deps)
- [x] oracleclientlib (.NET projekt - ingen Java model deps)
- [x] oraclesrvlib (.NET projekt - ingen Java model deps)

### Forms Projekter (1 projekt - OnHold)

- [x] forms (OnHold - ikke analyseret)

---

## Hvad jeg gør for hvert projekt

1. Læser `Legacy/{gruppe}/{projekt}/pom.xml` for dependencies
2. Søger i Java-filer efter imports fra model packages
3. Matcher imports med dependencies for at finde JAR og version
4. Tilføjer ny profile til `DiasLegacyModels/pom.xml` hvis der er model dependencies
5. Markerer projektet som `[x]` med noter om fundne dependencies
6. Markerer som `[x] (ingen model deps)` hvis projektet ikke bruger model JARs

## Kendte Model GroupIds

| GroupId | Beskrivelse |
|---------|-------------|
| `dk.naturerhverv.fishery` | Primære fishery model-klasser |
| `dk.naturerhverv.fishery.model` | Event models (uncefact-event-model) |
| `dk.lfst.fishery.business.model` | LFST business models |
| `dk.fishery.model` | Generelle fishery models |
| `dk.fd.soa` | SOA utility klasser |
| `dk.fd.ers` | ERS (Electronic Reporting System) models |
| `dk.fishery.logbook` | Logbook models |

---

## Manuel Prompt (enkelt projekt)

```
Find model JAR dependencies for: {legacy-projekt-navn}

Gør følgende:
1. Læs pom.xml fra Legacy/{gruppe}/{legacy-projekt-navn}/pom.xml
2. Find alle imports i Java-filer der matcher model groupIds
3. Match imports med dependencies i pom.xml for at finde JAR navn og version
4. Tilføj en ny profile til DiasLegacyModels/pom.xml med projektets dependencies
5. Opdater properties sektionen med nye versioner hvis nødvendigt
6. Opdater denne fil og kryds projektet af på listen
```
