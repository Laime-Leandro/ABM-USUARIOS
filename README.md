
## Explicacion de proyecto
!["Image not found"](./images/network.png)

Se levantan dos docker que estan conectados entre si, uno debian y el otro vault, el sistema debian contara con usuarios, grupos, contraseñas y estara habilitado el servicio ssh para que cada usuario pueda conectarse ya sea mediante su contraseña o su clave id_rsa la cual se encuantra en la carpeta de cada usuario.
Los grupos creados y los usuarios son los siguientes:
**Admins:** Leandro, Enzo
**Devs:** Juan, Sofia, Cristian, Nicolas, Sebastian
**Supports:** Ramiro, Camila, Hector
Las contraseñas seguras son generadas con `pwgen` con una longitud de 12 caracteres. Los usuarios y contraseñas son enviadas al vault donde son guardadas en diferentes secrets con los nombres pertenecientes a cada grupo

## Demostracion
Creamos las imagenes:
 ` docker compose build `
Ejecutamos los contenedores en segundo plano
 ` docker compose up -d `
Accedemos al contenedor "debian"
 ` docker compose exec debian bash `
Vamos a poder ver los usuarios que se crearon

!["Image not found"](./images/etc_passwd.png)

Consultamos nuestra ip 
 ` hostname -i `
!["Image not found"](./images/ip.png)

El docker de "vault" es el que se ejecuta primero asi que su ip sera una menos que la nuestra(seria "172.18.0.2" en este caso), por el navegador ponemos la direccion del docker "vault" con el numero de puerto por el que va a estar la web (puerto 8200)
URL: ` http://172.18.0.2:8200 `

!["Image not found"](./images/vault.png)

El token asignado es "dev-only-token", una vez ingresado iremos al apartado de secret donde vamos a poder ver los grupos los cuales contienen las contraseñas de los usuarios que pertenecen a esta.

!["Image not found"](./images/secret_groups.png)

Usuarios y contraseñas del grupo devs 

!["Image not found"](./images/devs_passwords_vault.png)

Ahora vamos a acceder al usuario "Cristian" mediante ssh 

!["Image not found"](./images/ssh_cristian.png)

Tambien se puede acceder mediante el uso de la id_rsa que se encuentra en la carpeta .ssh en la carpeta de cada usuario, esto nos permitira conectarnos sin que te pidan contraseña
