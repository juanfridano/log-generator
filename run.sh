project_name="log-exporter-436111"
key_file="tf-service-key.json"
plan_filename="plan.tfplan"

function export_creds() {
    export GOOGLE_APPLICATION_CREDENTIALS=$key_file 
}

function authenticate() {    
    if [ ! -f "$key_file" ]; then
        echo "Error: The file $key_file does not exist. Authentication failed."
        exit 1
    else
        export_creds
        gcloud auth activate-service-account --key-file=$key_file
        gcloud config set project $project_name
        gcloud services enable artifactregistry.googleapis.com
        gcloud services enable run.googleapis.com
    fi
}

function plan_and_apply() {
    export_creds && \
    terraform plan -var-file=variables.tfvars -out=$plan_filename
    terraform apply -var-file=variables.tfvars -auto-approve
}

function push_image() {
    gcloud auth configure-docker europe-west3-docker.pkg.dev
    docker build -t europe-west3-docker.pkg.dev/$project_name/log-generator-repo/log-generator:latest .
    docker push europe-west3-docker.pkg.dev/$project_name/log-generator-repo/log-generator:latest
}

function destroy() {
    export_creds && \
    terraform destroy -var-file=variables.tfvars
}


action=$1

# Perform action based on the parameter
case "$action" in
    init)
        echo "Initializing terraform..."
        terraform init
        ;;
    auth)
        echo "Performing authentication..."
        authenticate
        ;;
    infra)
        echo "Planning and applying configuration..."
        plan_and_apply
        ;;
    deploy)
        echo "Deploying changes in python script"
        push_image
        ;;
    destroy)
        echo "Destroying infrastructure..."
        destroy
        ;;
    *)
        echo "Error: Invalid option."
        ;;
esac