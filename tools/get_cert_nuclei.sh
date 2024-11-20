DOMAIN=$1

get_cert_nuclei(){
    echo $1 | nuclei -t ~/nuclei-templates/ssl/ssl-dns-names.yaml -silent -j | jq -r '.["extracted-results"][]' | sort -u
}

get_cert_nuclei $DOMAIN