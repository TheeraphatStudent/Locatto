#!/bin/bash

echo "Fixing upload directory permissions..."

mkdir -p /usr/src/app/uploads

CONTAINER_UID=${UID:-1000}
CONTAINER_GID=${GID:-1000}

echo "> Setting ownership to user $CONTAINER_UID:$CONTAINER_GID"

if chown -R "$CONTAINER_UID:$CONTAINER_GID" /usr/src/app/uploads 2>/dev/null; then
    echo "Successfully changed ownership"
else
    echo "Failed to change ownership as current user, trying with sudo..."
    if command -v sudo >/dev/null 2>&1; then
        sudo chown -R "$CONTAINER_UID:$CONTAINER_GID" /usr/src/app/uploads
        echo "Successfully changed ownership with sudo"
    else
        echo "Failed to change ownership. Please run this script as root or with sudo."
        echo "   You can also run: docker exec -u root <container_name> chown -R $CONTAINER_UID:$CONTAINER_GID /usr/src/app/uploads"
        exit 1
    fi
fi

chmod 755 /usr/src/app/uploads
find /usr/src/app/uploads -type f -exec chmod 644 {} \;

echo "Current permissions:"
ls -la /usr/src/app/uploads

echo "Upload directory permissions fixed!"
echo "   Owner: $(stat -c '%U:%G' /usr/src/app/uploads)"
echo "   Permissions: $(stat -c '%a' /usr/src/app/uploads)"