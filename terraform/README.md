# Guía de Despliegue de Microservicios en AWS con Terraform y EKS

¡Bienvenido! Esta guía te llevará paso a paso para desplegar una arquitectura completa de microservicios en AWS. Usaremos Terraform para crear la infraestructura y Kubernetes (EKS) para orquestar los servicios.

## Arquitectura

Lo que vamos a construir:
- Una **VPC** (nuestra red privada en la nube).
- Un **Clúster de EKS** (Kubernetes gestionado por AWS) para nuestros microservicios.
- **Repositorios de ECR** para almacenar las imágenes Docker de cada servicio.
- Dos bases de datos **RDS**: una **PostgreSQL** para `order-service` y una **MySQL** para `user-service`.
- **CloudWatch** para el monitoreo y registro de logs.

---

## 1. Prerrequisitos

Antes de empezar, asegúrate de tener instaladas las siguientes herramientas:

- **AWS CLI**: [Instrucciones de instalación](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- **Terraform**: [Instrucciones de instalación](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **kubectl**: [Instrucciones de instalación](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- **Docker**: [Instrucciones de instalación](https://docs.docker.com/get-docker/)

---

## 2. Configuración de Credenciales de AWS

Terraform necesita credenciales para crear recursos en tu cuenta de AWS. La forma más segura de hacerlo es configurando tu AWS CLI.

```bash
aws configure
```

Sigue las instrucciones e introduce tu `AWS Access Key ID`, `AWS Secret Access Key`, y `Default region name` (por ejemplo, `us-east-1`).

---

## 3. Despliegue de la Infraestructura con Terraform

Ahora vamos a crear toda la infraestructura de AWS con dos simples comandos.

**Paso 3.1: Inicializar Terraform**
Navega a la carpeta `infra-aws` y ejecuta `init`. Este comando prepara tu espacio de trabajo y descarga los proveedores necesarios.

```bash
cd infra-aws
terraform init
```

**Paso 3.2: Aplicar la Configuración**
Ejecuta `apply`. Terraform te mostrará un plan de todos los recursos que va a crear. Escribe `yes` cuando te lo pida para confirmar.

```bash
terraform apply
```

Este proceso puede tardar varios minutos (entre 15 y 20 min), ya que está creando un clúster de Kubernetes y bases de datos.

**Paso 3.3: Revisa las Salidas (Outputs)**
Una vez que `apply` termine, Terraform mostrará una lista de "outputs". Estos son datos importantes que usaremos más tarde, como los endpoints de las bases de datos y el nombre del clúster. ¡Tenlos a mano!

---

## 4. Despliegue de los Microservicios

Ahora que la infraestructura está lista, vamos a desplegar cada microservicio. Repetiremos estos pasos para `order-service` y `user-service`.

**Paso 4.1: Configurar `kubectl`**
Necesitamos que `kubectl` se comunique con nuestro nuevo clúster de EKS. Ejecuta el siguiente comando, reemplazando `<region>` y `<cluster-name>` con los valores de tu configuración (puedes obtener el nombre del clúster de los outputs de Terraform).

```bash
aws eks --region <tu-region> update-kubeconfig --name <nombre-del-cluster-eks>
```

**Paso 4.2: Construir y Subir la Imagen Docker**
Para cada servicio (ej. `order-service`):

1.  **Navega a la carpeta del servicio**:
    ```bash
    cd ../order-service
    ```

2.  **Construye la imagen Docker**:
    ```bash
    docker build -t order-service .
    ```

3.  **Autentícate en ECR**:
    Obtén la URL de tu repositorio ECR de los outputs de Terraform.
    ```bash
    aws ecr get-login-password --region <tu-region> | docker login --username AWS --password-stdin <url-del-repositorio-ecr-sin-el-nombre-del-servicio>
    ```

4.  **Etiqueta (Tag) y Sube (Push) la imagen**:
    Usa la URL completa del repositorio de ECR para `order-service` que te dio Terraform.
    ```bash
    docker tag order-service:latest <url-completa-del-repositorio-ecr/order-service:latest>
    docker push <url-completa-del-repositorio-ecr/order-service:latest>
    ```

**Paso 4.3: Crear el Secreto de Kubernetes**

1.  **Copia la plantilla**:
    ```bash
    cp secrets.yml.template secrets.yml
    ```

2.  **Obtén y codifica tus credenciales**:
    De los outputs de Terraform, toma la URL, el usuario y la contraseña de la base de datos PostgreSQL. Codifícalos en base64:
    ```bash
    echo -n 'jdbc:postgresql://<endpoint-rds>:<port>/<db-name>' | base64
    echo -n '<usuario-rds>' | base64
    echo -n '<contraseña-rds>' | base64
    ```

3.  **Edita `secrets.yml`**:
    Abre `secrets.yml` y pega los valores codificados que acabas de generar en los campos correspondientes.

**Paso 4.4: Actualizar y Aplicar los Manifiestos de Kubernetes**

1.  **Actualiza la URL de la imagen**:
    Abre `deployment.yml` y reemplaza `__IMAGE_URL__` con la URL de la imagen que subiste a ECR (ej. `<url-completa-del-repositorio-ecr/order-service:latest>`).

2.  **Aplica los manifiestos**:
    Ejecuta `kubectl apply` para desplegar el servicio. Esto creará el secreto, el despliegue (Pods) y el servicio (para exponer la aplicación).
    ```bash
    kubectl apply -f secrets.yml
    kubectl apply -f deployment.yml
    kubectl apply -f service.yml
    ```

**Paso 4.5: Verifica el Despliegue**
Puedes ver si tus Pods están corriendo con:
```bash
kubectl get pods
```
Y los servicios con:
```bash
kubectl get services
```

---

**¡Felicidades!** Has desplegado un microservicio. Ahora solo tienes que **repetir los pasos 4.2 a 4.5** para el `user-service`, usando sus propios archivos, la base de datos MySQL y el repositorio ECR correspondiente.
