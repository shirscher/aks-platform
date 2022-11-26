
GITLAB_SP_NAME=SP-CD-GL-AksPlatform-P

# Create service principal for GitLab
az ad sp create-for-rbac --name $GITLAB_SP_NAME --role Owner --scopes /

# Store credentials in GitLab variales