currentDir = $(shell pwd)
targetDir = ${currentDir}/target
moduleDir = ${targetDir}/module
cliDir = ${targetDir}/cli

baseRepo = https://repo.maven.apache.org/maven2/
sentryRelease = 4.1.0
gsonReleaseForSentry = 2.8.5

module: ${moduleDir}
.PHONY: module

clean:
	rm -rf ${targetDir}
.PHONY: clean

check_env:
ifndef KEYCLOAK_BASE_INSTALL_DIR
	@echo "YOU HAVE TO DEFINE VARIABLE 'KEYCLOAK_BASE_INSTALL_DIR' TO PERFORM A INSTALLATION"
	@echo ""
	@echo "$$ make install KEYCLOAK_BASE_INSTALL_DIR=/path/to/keycloak/"
	@exit 1
endif

install: check_env ${moduleDir} ${cliDir}
	mkdir -m 755 -p ${KEYCLOAK_BASE_INSTALL_DIR}/modules/io/sentry/main
	cp -av ${moduleDir}/* ${KEYCLOAK_BASE_INSTALL_DIR}/modules/io/sentry/main
	${KEYCLOAK_BASE_INSTALL_DIR}/bin/jboss-cli.sh --echo-command --file=${cliDir}/sentry-setup.cli

deinstall: check_env ${cliDir}
	${KEYCLOAK_BASE_INSTALL_DIR}/bin/jboss-cli.sh --echo-command --file=${cliDir}/sentry-deinstall.cli

${moduleDir}:
	mkdir -p ${moduleDir}
	curl -s --output ${moduleDir}/sentry-jul-${sentryRelease}.jar \
		${baseRepo}/io/sentry/sentry-jul/${sentryRelease}/sentry-jul-${sentryRelease}.jar
	curl -s --output ${moduleDir}/sentry-${sentryRelease}.jar \
		${baseRepo}/io/sentry/sentry/${sentryRelease}/sentry-${sentryRelease}.jar
	curl -s --output ${moduleDir}/gson-${gsonReleaseForSentry}.jar \
		${baseRepo}/com/google/code/gson/gson/${gsonReleaseForSentry}/gson-${gsonReleaseForSentry}.jar
	# this will never change because this is a standard
	curl -s --output ${moduleDir}/jboss-jsse-api_8.0_spec-1.0.0.Final.jar \
		${baseRepo}/org/jboss/spec/javax/net/ssl/jboss-jsse-api_8.0_spec/1.0.0.Final/jboss-jsse-api_8.0_spec-1.0.0.Final.jar	
	cp src/main/resources/module.xml ${moduleDir}/
	sed -i s,@SENTRY_RELEASE@,${sentryRelease},g ${moduleDir}/*.xml
	sed -i s,@GSON_RELEASE@,${gsonReleaseForSentry},g ${moduleDir}/*.xml
	chmod 644 ${moduleDir}/*.jar ${moduleDir}/*.xml
	chmod 755 ${moduleDir}

${cliDir}:
	mkdir -p ${cliDir}
	cp src/main/resources/*.cli ${cliDir}
