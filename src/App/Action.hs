
module App.Action where

import Miso
import Miso.String

import Domain.Hero (Hero)

data Action
    = ActionChangeUri URI
    | ActionHandleUri URI
    | ActionPopHeroes
    | ActionError MisoString
    | ActionFetchFail
    | ActionFetchHeroes
    | ActionSetHeroes [Hero]
    deriving (Eq)

