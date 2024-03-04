#!/bin/bash

# ----------------------------------------------------------------------------------------------------
# You must adjust the following variables
use_sudo=false
checkmk_packaged_agent="check-mk-agent_2.2.0p11-1_all.deb" # Setup -> Agents -> Linux -> Packaged Agents
checkmk_ip_address="X.X.X.X"
checkmk_site="SITENAME"
checkmk_username="cmkadmin"
checkmk_host_to_be_registered=""
# ----------------------------------------------------------------------------------------------------

set -e	# option in bash scripts that causes the script to terminate immediately if a command generates an error (non-null exit code)

echo
echo "***** Checkmk initial agent setup *****"

url_for_checkmk_agents="http://$checkmk_ip_address/$checkmk_site/check_mk/agents"

echo
echo "Installing Checkmk agent..."
cd /tmp
wget "$url_for_checkmk_agents/$checkmk_packaged_agent"
apt install "/tmp/$checkmk_packaged_agent"
rm "$checkmk_packaged_agent"
cd ~

echo
echo "Registration of the host ($checkmk_host_to_be_registered) in Checkmk ($checkmk_ip_address)..."
if [ "$use_sudo" = true ]; then
    sudo cmk-agent-ctl register --hostname $checkmk_host_to_be_registered --server $checkmk_ip_address --site $checkmk_site --user $checkmk_username
else
    cmk-agent-ctl register --hostname $checkmk_host_to_be_registered --server $checkmk_ip_address --site $checkmk_site --user $checkmk_username
fi

echo
echo "Installing Checkmk plugins..."

path_for_checkmk_agent="/usr/lib/check_mk_agent"

# Create a script for Checkmk reboot status
path_for_checkmk_reboot_status="$path_for_checkmk_agent/local/checkmk-reboot-status.sh"
cat <<EOF > $path_for_checkmk_reboot_status
#!/bin/bash
if [ -e /var/run/reboot-required ]; then
    status=2
    statustxt="CRITICAL - Restart required due to pending updates"
else
    status=0
    statustxt="OK - No restart required due to pending updates"
fi

echo "\$status Reboot-Status varname=2;crit \$statustxt"
EOF
chmod +x $path_for_checkmk_reboot_status

# Download additional Checkmk plugins
# If you need more or something else, please customise it - Setup -> Agents -> Linux -> Plugins
url_for_checkmk_plugins="$url_for_checkmk_agents/plugins"
cd $path_for_checkmk_agent/plugins/
wget "$url_for_checkmk_plugins/README"
wget "$url_for_checkmk_plugins/lvm"
wget "$url_for_checkmk_plugins/mk_apt"
wget "$url_for_checkmk_plugins/mk_logins"
wget "$url_for_checkmk_plugins/smart"
chmod +x lvm mk_apt mk_logins smart
cd ~

# Delete the temporary script
rm /tmp/checkmk-initial-agent-setup.sh

echo
echo "***** Finished *****"