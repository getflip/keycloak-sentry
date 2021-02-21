# keycloak-sentry

This module is inspired by [sentry-jboss-module](https://github.com/fallard84/sentry-jboss-module).

This module helps you to send keycloak and jboss events to a sentry server.

# Open TODOs

Contributions are very welcome. Just open a pull request.

- Use a java build tool like gradle or maven to download and fulfill the transitive devendencies of the module
- Implement a custom event listerner spi suitable for keycloak which provides fine grained events generation
  (https://dev.to/adwaitthattey/building-an-event-listener-spi-plugin-for-keycloak-2044)
  - the default implementation distinguishes ony successful and error events (i.e. a password error is not the thing you always want to have as a sentry event)
  - fingerprint/obfuscate userdetails to hide the detail information for [non-GPDR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) compliant setups
    (we prefer to have our own on-prem instance :-)) 
  - enhance context information of the events
- Create packages

# Usage

Starting with sentry-release 4.1.0 it is possible to install a [jul-based log handler](https://docs.sentry.io/platforms/java/guides/jul/) in jboss/keycloak after the sentry project droped the resource for some time.

## How to deploy the module

If you run [keycloak with docker](https://github.com/keycloak/keycloak-containers), you can execute this installation procedure right before starting the server process itself.
(i.e. by placing the installation procedure as a shell script in /opt/jboss/startup-scripts/sentry.sh).


  1. Define a sentry project and gather the sentry dsn
  2. Stop your keycloak instance
  3. Identify your keycloak installation dir
  4. Run the installation target with the path
     ```
     git clone https://github.com/scoopex/keycloak-sentry
     cd keycloak-sentry
     # "module" target supports you for pepackaging the module in you docker container
     make module
     make install KEYCLOAK_BASE_INSTALL_DIR=/opt/jboss/keycloak
     ```
  5. Set the following environment variables for your docker image or append them to them "/opt/jboss/keycloak/bin/standalone.conf" file
     ```
     SENTRY_ENVIRONMENT=production
     SENTRY_DSN=https://aefaefafffaaaaaaaaaaaaaaaaaaaaaa@o1.ingest.sentry.mydomain.de/4
     export SENTRY_ENVIRONMENT SENTRY_DSN
     ```
  6. Start your keycloak instance

# How to undeploy the module

  1. Stop your keycloak instance
  2. Identify your keycloak installation dir
  3. Run the installation target with the path
     ```
     git clone https://github.com/scoopex/keycloak-sentry
     cd keycloak-sentry
     make deinstall KEYCLOAK_BASE_INSTALL_DIR=/opt/jboss/keycloak
     ```
  4. Start your keycloak instance



  
