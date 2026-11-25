# Practical 1 — Install Puppet and apply a first manifest

## 🎯 Aim
Install Puppet on Ubuntu 22.04 and enforce a simple desired state with `puppet apply`.

## 🧰 Requirements
Ubuntu 22.04 VM (`control` in [`lab/`](../../lab)), sudo access, internet.

## 🪜 Steps
1. **Add the Puppet repository and install the agent**
   ```bash
   wget https://apt.puppet.com/puppet8-release-jammy.deb
   sudo dpkg -i puppet8-release-jammy.deb
   sudo apt update && sudo apt install -y puppet-agent
   echo 'export PATH=$PATH:/opt/puppetlabs/bin' >> ~/.bashrc && source ~/.bashrc
   puppet --version
   ```
2. **Look at facts**
   ```bash
   facter os.family networking.ip
   ```
3. **Write the manifest** – [`hello.pp`](hello.pp)
4. **Validate, dry-run, apply**
   ```bash
   puppet parser validate hello.pp
   sudo puppet apply --noop hello.pp     # shows what WOULD change
   sudo puppet apply hello.pp            # applies
   sudo puppet apply hello.pp            # run again -> no changes (idempotent)
   ```
5. **Verify**
   ```bash
   cat /tmp/hello_puppet.txt
   dpkg -l | grep tree
   ```

## ✅ Expected output
First run shows `Notice: /Stage[main]/Main/File[/tmp/hello_puppet.txt]/ensure: defined content as ...` and `Package[tree]/ensure: created`. Second run prints only `Applied catalog in X seconds` with no changes.

## 📝 Viva questions
- What is the difference between `--noop` and a normal run?
- What does idempotent mean?
- Where is the Puppet binary installed, and why isn't it in `PATH` by default?
