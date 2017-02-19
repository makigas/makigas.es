# Server to deploy to.
server deploy_param(:server), user: deploy_param(:user), roles: %w{app db web}

# Deployment branch
set :branch, deploy_param(:branch)