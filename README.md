# Docker Image - Seafile Pro

Special for external database Servers

Base: https://github.com/Gronis/docker-seafile  
Adjusted with help of: https://github.com/eplightning/seafile-kubernetes  

## Troubles

When you have troubles with updates / setup, then set the environment variable "MODE" to value "maintenance".  
This allows to enter the container and run startup commands yourself, without to have problems because of restarting container.

## License

This docker image is **not** related to Seafile Ltd. in any way.  
It is a private contribution to use Seafile Pro with an external database server.  
When you use it, you agree to the Seafile Pro license and provide a license file.  
Information: https://www.seafile.com/en/product/private_server/
