

module Heroes.Action where

import Miso

-- | Event Actions
data Action
    = ChangeURI URI
    | HandleURI URI
    | ToggleNavMenu
    deriving (Eq)

