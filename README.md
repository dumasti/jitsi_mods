# jitsi_mods
jitsi_mods


## mod_muc_lobby_rooms.lua
Default enable lobby

### Installation


/etc/prosody/conf.d/<fqdn>.cfg.lua

```bash
VirtualHost "<fqdn>"
  ...
  modules_enabled = {
    ...
    ...
    "muc_lobby_rooms";
  }
```
Restart the services

```bash
systemctl restart prosody jicofo
```

## mod_token_moderation_grand.lua
  allows to give moderator rights
  
### Installation


/etc/prosody/conf.d/<fqdn>.cfg.lua

```bash
Component "conference.<fqdn>" "muc"
  modules_enabled = {
    ...
    ...
    "token_moderation_grand";
  }
```
Restart the services

```bash
systemctl restart prosody jicofo
```

## mod_moderation_end.lua

### Installation


/etc/prosody/conf.d/<fqdn>.cfg.lua

```bash
Component "conference.<fqdn>" "muc"
  modules_enabled = {
    ...
    ...
    "moderation_end";
  }
  conference_max_minutes = 10
```
Restart the services

```bash
systemctl restart prosody jicofo
```
Add body.html to redirect on any page when meeting is ended
  
  /usr/share/jitsi-meet/body.html 
