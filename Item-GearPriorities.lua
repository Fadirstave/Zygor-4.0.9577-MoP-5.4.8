local ZGV = ZygorGuidesViewer
if not (ZGV and ZGV.ItemScore) then return end
local IS = ZGV.ItemScore
local stats = {
 {"STRENGTH","Strength"}, {"AGILITY","Agility"}, {"INTELLECT","Intellect"},
 {"STAMINA","Stamina"}, {"SPIRIT","Spirit"}, {"HIT","Hit"},
 {"EXPERTISE","Expertise"}, {"CRIT","Critical strike"}, {"HASTE","Haste"},
 {"MASTERY","Mastery"}, {"DODGE","Dodge"}, {"PARRY","Parry"},
 {"ATTACK_POWER","Attack power"}, {"SPELL_POWER","Spell power"},
 {"DAMAGE_PER_SECOND","Weapon DPS"}, {"DAMAGE","Weapon damage"},
}
local function copy(t)
 local result = {}
 for k,v in pairs(t) do result[k] = type(v)=="table" and copy(v) or v end
 return result
end
local function settings()
 ZGV.db.char.gearPriorities = ZGV.db.char.gearPriorities or {}
 return ZGV.db.char.gearPriorities
end
local function selectedSpec() return IS.priorityEditSpec or GetSpecialization() or 1 end
local function entry(spec)
 local all = settings()
 all[spec] = all[spec] or { weights = {} }
 return all[spec]
end
function IS:BuildPriorityRules(class,spec)
 local base = self.rules[class] and self.rules[class][spec]
 if not base then return nil end
 local result = copy(base)
 local saved = ZGV.db and ZGV.db.char and ZGV.db.char.gearPriorities
 saved = saved and saved[spec]
 if class == select(2,UnitClass("player")) and saved and saved.enabled then
  for _,stat in ipairs(stats) do
   local key = stat[1]
   local value = tonumber(saved.weights[key])
   if value and value>=0 and value<=1000 then
    result.stats[key] = result.stats[key] or {}
    result.stats[key].weight = value
    result.stats[key].default = value
    if key=="HIT" and not result.stats[key].category then
     result.stats[key].category = CR_HIT_MELEE
     result.stats[key].hitcap = 7.5
    elseif key=="EXPERTISE" then
     result.stats[key].expcap = result.stats[key].expcap or 7.5
    end
   end
  end
 end
 return result
end
function IS:RefreshPriorities()
 local ae = self.AutoEquip
 ae.ItemQueue = nil
 ae.call_after_combat = nil
 if ae.Popup then ae.Popup.itemdeclined=nil ae.Popup:Hide() end
 wipe(ae.ScoreCache)
 if self.GearFinder then wipe(self.GearFinder.ResultsCache) end
 self:SetFilters()
 ae:ScoreCurrentEquippedItems()
 ae.LastBagScan = nil
 ae:ScanBagsForUpgrades()
end
function IS:AddPriorityOptions(add)
 add('priority_header',{type='header',name='Gear stat priorities'})
 add('priority_help',{type='description',name='Weights are saved separately for each character and specialization. Higher numbers make a stat more valuable per point. Blank uses the original weight; 0 ignores that stat. Your current specialization is always used for recommendations. Existing hit/expertise cap adjustments and equipment restrictions still apply.'})
 add('priority_spec',{type='select',name='Specialization to edit',
  values=function()
   local values={}
   for i=1,GetNumSpecializations() do local _,name=GetSpecializationInfo(i) values[i]=name end
   return values
  end,
  get=function() return selectedSpec() end,
  set=function(_,v) IS.priorityEditSpec=v end})
 add('priority_enabled',{type='toggle',width='full',name='Use custom weights for this specialization',
  get=function() return entry(selectedSpec()).enabled or false end,
  set=function(_,v) entry(selectedSpec()).enabled=v IS:RefreshPriorities() end})
 for _,stat in ipairs(stats) do
  local key,label = stat[1],stat[2]
  add('priority_'..key,{type='input',name=label,
   desc='Weight per stat point, from 0 to 1000. Blank restores the original weight.',
   disabled=function() return not entry(selectedSpec()).enabled end,
   get=function()
    local value=entry(selectedSpec()).weights[key]
    if value~=nil then return tostring(value) end
    local base=IS.rules[select(2,UnitClass('player'))][selectedSpec()].stats[key]
    return tostring(base and (base.default or base.weight) or 0)
   end,
   validate=function(_,v)
    local n=tonumber(v)
    return v:match('^%s*$')~=nil or (n~=nil and n==n and n>=0 and n<=1000) or 'Enter a number from 0 to 1000, or leave blank.'
   end,
   set=function(_,v) entry(selectedSpec()).weights[key]=tonumber(v) IS:RefreshPriorities() end})
 end
 add('priority_reset',{type='execute',name='Reset this specialization',
  func=function() settings()[selectedSpec()]=nil IS:RefreshPriorities() end})
end
