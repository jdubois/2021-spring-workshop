#!/usr/bin/env bash
mvn -DskipTests=true -f ../pom.xml  clean package spring-boot:build-image