#!/bin/bash

keytool -genkey -alias projector.work \
       		-keyalg RSA \
		-keypass secret \
		-storepass  secret \
	       	-keystore $HOME/keystore.jks
