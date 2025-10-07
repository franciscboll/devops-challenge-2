#!/bin/bash
# setup-reverse-proxy.sh
# Instala Docker y NGINX, configurando un reverse proxy básico hacia un contenedor whoami.

set -e

# --- Validación de permisos ---
if [[ $EUID -ne 0 ]]; then
  echo "❌ Este script debe ejecutarse como root o con sudo."
  echo "👉 Uso: sudo ./setup-reverse-proxy.sh"
  exit 1
fi

echo "=== 🚀 Instalando dependencias ==="
apt update -y
apt install -y nginx docker.io curl

echo "=== 🔧 Habilitando servicios ==="
systemctl enable --now nginx
systemctl enable --now docker

echo "=== 🐳 Desplegando contenedor de prueba (whoami) ==="
docker run -d --name whoami --restart unless-stopped -p 127.0.0.1:8080:80 traefik/whoami

echo "=== ⚙️ Configurando NGINX como reverse proxy ==="
cat > /etc/nginx/sites-available/reverse-proxy <<EOF
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
EOF

ln -sf /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
rm -f /etc/nginx/sites-enabled/default

echo "=== 🔄 Reiniciando NGINX ==="
nginx -t && systemctl reload nginx

echo "=== ✅ Verificación ==="
curl -s http://127.0.0.1/ | head -n 5 || echo "⚠️ Verificar manualmente con: curl http://127.0.0.1/"

echo "=== 🎯 Instalación completada ==="
echo "Accedé desde tu navegador a: http://<IP_PUBLICA_EC2>/"