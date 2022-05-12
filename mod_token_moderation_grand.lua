-- Token moderation
-- this module looks for a field on incoming JWT tokens called "moderator".
-- If it is true the user is added to the room as a moderator, otherwise they are set to a normal user.
-- Note this may well break other affiliation based features like banning or login-based admins
local log = module._log;
local jid_bare = require "util.jid".bare;
local json = require "cjson";
local basexx = require "basexx";
local um_is_admin = require "core.usermanager".is_admin;

local function is_admin(jid)
        return um_is_admin(jid, module.host);
end

log('info', 'Loaded token moderation plugin');
-- Hook into room creation to add this wrapper to every new room
module:hook("muc-occupant-joined", function(event)
        log('info', 'occupant joined, checking token for ownership');
        local room = event.room
        setupAffiliation(room, event.origin, event.stanza);

        local _set_affiliation = room.set_affiliation;
        room.set_affiliation = function(room, actor, jid, affiliation, reason)
                if actor == "token_plugin" then
                        return _set_affiliation(room, true, jid, affiliation, reason)
                elseif affiliation == "owner" then
                        log('debug', 'set_affiliation: room=%s, actor=%s, jid=%s, affiliation=%s, reason=%s', room, actor, jid, affiliation, reason);
                        if string.match(tostring(actor), "focus@") then
                                log('debug', 'set_affiliation not acceptable, focus user');
                                return nil, "modify", "not-acceptable";
                        else
                                return _set_affiliation(room, actor, jid, affiliation, reason);
                        end;

                else
                        return _set_affiliation(room, actor, jid, affiliation, reason);
                end;
        end;
end);
function setupAffiliation(room, origin, stanza)
        if origin.auth_token then
                -- Extract token body and decode it
                local dotFirst = origin.auth_token:find("%.");
                if dotFirst then
                        local dotSecond = origin.auth_token:sub(dotFirst + 1):find("%.");
                        if dotSecond then
                                local bodyB64 = origin.auth_token:sub(dotFirst + 1, dotFirst + dotSecond - 1);
                                local body = json.decode(basexx.from_url64(bodyB64));
                                local jid = jid_bare(stanza.attr.from);
                                -- If user is a moderator or an admin, set their affiliation to be an owner
                                if body["moderator"] == true or is_admin(jid) then
                                        room:set_affiliation("token_plugin", jid, "owner");
                                else
                                        room:set_affiliation("token_plugin", jid, "member");
                                end;
                        end;
                end;
        end;
end;
