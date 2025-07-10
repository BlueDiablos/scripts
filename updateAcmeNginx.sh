#!/bin/bash

function check_file_fullchain {
    if ! test -f ~/scripts/fullchain.pem; then
        echo "Full chain did not copy. Exiting"
        exit 1
    fi
}

function check_file_privkey {
    if ! test -f ~/scripts/privkey.pem; then
        echo "Private key did not copy. Exiting"
        exit 1
    fi
}

function clean_up {

    rm -r fullchain.pem
    rm -r privkey.pem

    if test -f ~/scripts/fullchain.pem; then
        echo "full chain did not cleanup properly, please remove."
    fi

    if test -f ~/scripts/privkey.pem; then
        echo "private key did not cleanup properly, please remove."
    fi
}

echo "Transferring fullchain from pfsense to local"
scp pfsense:/conf/acme/houseblackledge.net.fullchain ~/scripts/fullchain.pem

check_file_fullchain

echo "Fullchain copied. Transferring private key from pfsense to local"
scp pfsense:/conf/acme/houseblackledge.net.key ~/scripts/privkey.pem

check_file_privkey

echo "moving files to nginx"

scp fullchain.pem nginx:/data/custom_ssl/npm-14/fullchain-test.pem
scp privkey.pem nginx:/data/custom_ssl/npm-14/privkey-test.pem

echo "cleaning up..."
clean_up

