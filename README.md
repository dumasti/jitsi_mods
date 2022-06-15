# jitsi_mods
jitsi_mods



Installation


/etc/prosody/conf.d/<fqdn>.cfg.lua

Component "conference.<fqdn>" "muc"
  modules_enabled = {
    ...
    ...
    "moderation_end";
  }
  conference_max_minutes = 10
Restart the services

systemctl restart prosody jicofo
  
/usr/share/jitsi-meet/body.html work whith mod_moderation_end.lua
