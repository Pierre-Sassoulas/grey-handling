local addonName, GreyHandling = ...;

local function defaultFunc(GreyHandling, key)
 -- If this function was called, we have no localization for this key.
 -- We could complain loudly to allow localizers to see the error of their ways,
 -- but, for now, just return the key as its own localization. This allows you to—avoid writing the default
 -- localization out explicitly.
 -- print(format("No localisation for key %s", key))
 return key;
end
setmetatable(GreyHandling, {__index=defaultFunc});
