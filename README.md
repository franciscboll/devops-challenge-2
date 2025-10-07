# DevOps Challenge – Parte 2

## 📋 Descripción del desafío

Este repositorio contiene la resolución de la **Parte 2** del challenge técnico para la posición **DevOps Engineer**.

### 🎯 Objetivo

Automatizar la instalación y configuración de software en un servidor mediante un **script Bash**, instalando y configurando los siguientes servicios:

- **Docker**
- **Nginx**, configurado como **Proxy Inverso**
- Los servicios deben iniciarse automáticamente tras la instalación

---

## 🧰 Herramientas y recursos utilizados

- **Bash**: lenguaje principal de automatización por su simplicidad, portabilidad y compatibilidad con entornos Linux.
- **Ubuntu Server 24.04 LTS**: sistema operativo base utilizado en la instancia EC2.
- **AWS EC2**: infraestructura utilizada para desplegar el servidor.
- **Docker**: motor de contenedores para ejecutar el backend de prueba (`whoami`).
- **NGINX**: servidor web utilizado como reverse proxy.
- **curl**: herramienta CLI para validar conectividad y respuestas HTTP.

---

## 🧱 Estructura general del repositorio

```
DEVOPS-CHALLENGE-2/
├── scripts/
│   └── setup-reverse-proxy.sh     # Script principal: instala Docker + NGINX y configura proxy inverso
├── docs/
│   └── diagram.png                # Diagrama de arquitectura (EC2 + Nginx + Backend)
└── README.md                      # Documentación general del proyecto
```

---

## ⚙️ Pre-requisitos

Antes de ejecutar el script, se debe disponer de:

- Una **instancia EC2** corriendo **Ubuntu Server 24.04 LTS**.
- Un **Security Group** con las siguientes reglas:
  - `22/tcp` → acceso SSH (solo desde la IP del desarrollador)
  - `80/tcp` → acceso HTTP público
- Par de claves `.pem` configurado para el acceso SSH.
- Acceso con usuario `ubuntu` y permisos `sudo`.

---

---

## 🧩 Funcionamiento del sistema

1. Instala **Docker** y **NGINX** desde los repositorios oficiales de Ubuntu.
2. Habilita ambos servicios (`systemctl enable --now`) para su inicio automático.
3. Despliega un contenedor de prueba (`traefik/whoami`) solo accesible en `127.0.0.1:8080`.
4. Crea una configuración de **Nginx Reverse Proxy** que redirige el tráfico de `:80` al backend interno.
5. Valida la sintaxis y recarga Nginx.
6. Ejecuta una verificación local con `curl`.

### Flujo de tráfico

```
Cliente (Internet)
        │
        ▼
[ NGINX :80 ]  →  Reverse Proxy
        │
        ▼
[ Docker :8080 → traefik/whoami ]
```

---

## 🚀 Uso y ejecución

Una vez desplegada la instancia EC2 y copiado el script al servidor, seguir los siguientes pasos para ejecutar la automatización:

### 1️⃣ Conceder permisos de ejecución
```bash
chmod +x setup-reverse-proxy.sh
```

### 2️⃣ Ejecutar el script con privilegios de administrador
```bash
sudo ./setup-reverse-proxy.sh
```

> 🔹 El uso de `sudo` es obligatorio, ya que el script realiza instalaciones de paquetes y configuraciones del sistema.

### 3️⃣ Verificar la instalación
Durante la ejecución se mostrarán mensajes de progreso por etapas:
```
=== 🚀 Instalando dependencias ===
=== 🔧 Habilitando servicios ===
=== 🐳 Desplegando contenedor de prueba (whoami) ===
=== ⚙️ Configurando NGINX como reverse proxy ===
=== 🔄 Reiniciando NGINX ===
=== ✅ Verificación ===
=== 🎯 Instalación completada ===
```

Al finalizar, el script mostrará una confirmación:
```
Accedé desde tu navegador a: http://<IP_PUBLICA_EC2>/
```

### 4️⃣ Verificación manual adicional

**Comprobar servicios activos:**
```bash
systemctl status docker --no-pager
systemctl status nginx --no-pager
```

**Listar contenedores en ejecución:**
```bash
docker ps
```

**Probar localmente:**
```bash
curl -s http://127.0.0.1/ | head
```

**Acceso externo desde el navegador:**
```
http://<IP_PUBLICA_DE_LA_EC2>/
```

Si todo está correcto, verás la respuesta generada por el contenedor `whoami`, confirmando que NGINX está funcionando como **reverse proxy**.


---
