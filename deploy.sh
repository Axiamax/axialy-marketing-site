#!/usr/bin/env bash
# This runs ON the droplet (via ssh-action)
set -euo pipefail

DEST=/var/www/axialy-ui
cd $DEST

# Example PHP/Node build steps – customise for your stack
if [ -f composer.json ]; then
  composer install --no-dev --optimize-autoloader
fi
if [ -f package.json ]; then
  npm ci --omit=dev
  npm run build
fi

systemctl reload apache2
echo "Deploy script finished at $(date)" >> $DEST/DEPLOY_INFO.txt
