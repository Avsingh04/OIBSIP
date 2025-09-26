#!/bin/bash
# Basic Firewall Configuration using UFW inside Kali Docker
# Author: Arya Vikram Singh (AV)

# Exit on any error
set -e

echo "Updating package list..."
apt update -y

echo "Installing UFW..."
apt install ufw -y

echo "Enabling UFW..."
ufw --force enable

echo "Allowing SSH (port 22)..."
ufw allow ssh

echo "Denying HTTP (port 80)..."
ufw deny http

echo "Reloading UFW to apply changes..."
ufw reload

echo ""
echo "=============================="
echo " Current UFW Status and Rules "
echo "=============================="
ufw status verbose
