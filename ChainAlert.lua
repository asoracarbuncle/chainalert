_addon.name = 'ChainAlert'
_addon.author = 'Asora'
_addon.version = '0.1'
_addon.commands = {'ca','chainalert'}

packets = require('packets')

alert_gearswap = false

----------------------------------------------------------------------
-- Skillchain table
----------------------------------------------------------------------
skillchains = {
    [288] = 'Light',
    [289] = 'Darkness',
    [290] = 'Gravitation',
    [291] = 'Fragmentation',
    [292] = 'Distortion',
    [293] = 'Fusion',
    [294] = 'Compression',
    [295] = 'Liquefaction',
    [296] = 'Induration',
    [297] = 'Reverberation',
    [298] = 'Transfixion',
    [299] = 'Scission',
    [300] = 'Detonation',
    [301] = 'Impaction',
    [385] = 'Light',
    [386] = 'Darkness',
    [387] = 'Gravitation',
    [388] = 'Fragmentation',
    [389] = 'Distortion',
    [390] = 'Fusion',
    [391] = 'Compression',
    [392] = 'Liquefaction',
    [393] = 'Induration',
    [394] = 'Reverberation',
    [395] = 'Transfixion',
    [396] = 'Scission',
    [397] = 'Detonation',
    [398] = 'Impaction',
    [767] = 'Radiance',
    [768] = 'Umbra',
    [769] = 'Radiance',
    [770] = 'Umbra',
}

----------------------------------------------------------------------
-- Add Incoming Chunk Event Listener
----------------------------------------------------------------------
windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
    -- Trim down the list of packets to filter
    if id == 0x028 then
        -- Attempt to get the currently targeted mob id
        local target = windower.ffxi.get_mob_by_target('t')
        -- Check if there is a current target
        if target then
            -- Parse the incoming packet
            local packet = packets.parse('incoming', original)
            -- Make sure we only continue if our target matches the packet target
            if target.id == packet['Target 1 ID'] then
                -- Ensure the packet action is something that can cause a chain
                if packet['Category'] == 3 or packet['Category'] == 4 then
                    -- Check if the added effect message is a skillchain
                    local added_effect_message_id = packet['Target 1 Action 1 Added Effect Message']
                    if skillchains[added_effect_message_id] then
                        local last_skillchain = skillchains[added_effect_message_id]
                        windower.add_to_chat(207, '<----- Skillchain: '..last_skillchain..' Opened ----->')
                        if alert_gearswap == true then
                            windower.send_command('gs c toggle burst mode on')
                        end
                        coroutine.sleep(9)
                        windower.add_to_chat(207, '<----- Skillchain: '..last_skillchain..' Closed ----->')
                        if alert_gearswap == true then
                            windower.send_command('gs c toggle burst mode off')
                        end
                    end
                end
            end
        end
    end
end)

----------------------------------------------------------------------
-- Add Command Listener
----------------------------------------------------------------------
windower.register_event('addon command', function(...)
    local args = T{...}
    if args ~= nil then
        local comm = table.remove(args,1):lower()
        if comm == 'gearswap' then
            if alert_gearswap == true then
                alert_gearswap = false
                windower.add_to_chat(207, "ChainAlert: Gearswap alert OFF")
            else
                alert_gearswap = true
                windower.add_to_chat(207, "ChainAlert: Gearswap alert ON")
            end
        elseif comm == 'help' then
            local helptext = [[ChainAlert - Command List:
1. gearswap - Allows the addon to alert gearswap that a burst is occurring.
2. help --Shows this menu.]]
            for _, line in ipairs(helptext:split('\n')) do
                windower.add_to_chat(207, line)
            end
        end
    end
end)
