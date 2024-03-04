# Checkmk-Initial-Agent-Setup

A simple shell script to simplify the setup process of the Checkmk agent on a host.

## Usage

Create the script:

```bash
nano /tmp/checkmk-initial-agent-setup.sh
```

Paste the content of the script ([`checkmk-initial-agent-setup.sh`](checkmk-initial-agent-setup.sh)) here.

You must now adjust the following variables in the script:

```bash
use_sudo=false
checkmk_packaged_agent="check-mk-agent_2.2.0p11-1_all.deb" # Setup -> Agents -> Linux -> Packaged Agents
checkmk_host="http://X.X.X.X" # It is best if the IP address of Checkmk is entered here
checkmk_site="SITENAME"
checkmk_username="cmkadmin"
checkmk_password=""
checkmk_host_to_be_registered=""
```

The script must then be made executable:

```bash
chmod +x /tmp/checkmk-initial-agent-setup.sh
```

Run the script:

```bash
/tmp/checkmk-initial-agent-setup.sh
```

> After the script has been executed, it is deleted!

For the Checkmk agent to work, the following firewall setting must be made on the host to be registered:

- Direction: `in`
- Action: `ACCEPT`
- Protocol: `tcp`
- Dest. port: `6556`

## Additional information

The following plugins are installed by default: `lvm`, `mk_apt`, `mk_logins`, `smart`

In addition, a custom [script (`checkmk-reboot-status.sh`)](checkmk-reboot-status.sh) is automatically added that monitors whether the host needs to be restarted due to the updates.

## Another repository that might interest you

[Checkmk-Matrix-Notifications](https://github.com/fuchs-fabian/Checkmk-Matrix-Notifications)
