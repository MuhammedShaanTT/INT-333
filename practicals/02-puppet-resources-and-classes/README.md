# Practical 2 — Resources, ordering, conditionals and classes

## 🎯 Aim
Use common resource types (`package`, `service`, `file`, `user`, `exec`, `cron`), ordering, conditionals and a class to deploy Nginx.

## 🪜 Steps
1. Review [`webserver.pp`](webserver.pp).
2. Validate and lint
   ```bash
   puppet parser validate webserver.pp
   gem install puppet-lint 2>/dev/null || sudo apt install -y puppet-lint   # optional
   puppet-lint webserver.pp
   ```
3. Apply
   ```bash
   sudo puppet apply webserver.pp
   curl -s http://localhost:8080
   systemctl status nginx --no-pager
   ```
4. **Experiment:** manually `sudo systemctl stop nginx`, then re-run `puppet apply` – Puppet starts it again (configuration drift corrected).
5. **Experiment:** change `$port` and re-apply; the `notify` relationship restarts Nginx automatically.

## ✅ Expected output
`curl` returns the HTML page produced by the manifest; the `service` shows `active (running)`.

## 📝 Viva questions
- What is the difference between `require`/`before` and `notify`/`subscribe`?
- When does a `service` get refreshed?
- What are parameters in a class and how do you override them?
- Which resource type would you use to run a shell command only if a file is missing? (`exec` + `creates`/`unless`)
