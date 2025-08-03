
module App.Action where

import Miso
import Miso.String

data Action
    = ActionChangeUri URI
    | ActionHandleUri URI
    | ActionPopHeroes
    -- | ActionError MisoString
    deriving (Eq)

